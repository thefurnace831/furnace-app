-- The Furnace check-in database.
-- Paste this whole file into Supabase → SQL Editor and click Run.
-- Safe to run again after changes.
--
-- The website can't touch the tables directly. It can only call the three
-- functions at the bottom, and each one checks who is asking.


-- One row per person per day.
create table if not exists attendance (
  user_id       uuid        not null,
  day           date        not null,
  name          text,
  email         text,
  checked_in_at timestamptz not null default now(),
  primary key (user_id, day)
);

-- Who can see the monthly report. Add people in the Table Editor.
create table if not exists coordinators (
  email text primary key
);

-- Lock both tables: with row level security on and no policies, the
-- website can't read or write them directly.
alter table attendance   enable row level security;
alter table coordinators enable row level security;


-- Today's date at the center. Change the time zone here if needed.
create or replace function center_today() returns date
language sql stable set search_path = '' as $$
  select (now() at time zone 'America/Los_Angeles')::date;
$$;

-- Is the signed-in person a coordinator? (Only counts verified emails.)
create or replace function is_coordinator() returns boolean
language sql stable security definer set search_path = '' as $$
  select exists (
    select 1
    from auth.users u
    join public.coordinators c on lower(c.email) = lower(u.email)
    where u.id = auth.uid() and u.email_confirmed_at is not null
  );
$$;


-- 1. Everything the page shows the signed-in person.
create or replace function my_status() returns json
language sql stable security definer set search_path = '' as $$
  select json_build_object(
    'name', coalesce(u.raw_user_meta_data ->> 'full_name', u.raw_user_meta_data ->> 'name', u.email),
    'today', public.center_today(),
    'checked_in_at', (
      select a.checked_in_at from public.attendance a
      where a.user_id = u.id and a.day = public.center_today()),
    'days_this_month', (
      select count(*) from public.attendance a
      where a.user_id = u.id and a.day >= date_trunc('month', public.center_today())),
    'is_coordinator', public.is_coordinator()
  )
  from auth.users u
  where u.id = auth.uid();
$$;

-- 2. Check the signed-in person in for today. Doing it twice is harmless.
create or replace function check_in() returns json
language sql security definer set search_path = '' as $$
  insert into public.attendance (user_id, day, name, email)
  select u.id,
         public.center_today(),
         coalesce(u.raw_user_meta_data ->> 'full_name', u.raw_user_meta_data ->> 'name', u.email),
         u.email
  from auth.users u
  where u.id = auth.uid()
  on conflict do nothing;

  select public.my_status();
$$;

-- 3. Who came in a month, and how many days. Coordinators only.
--    `month_start` can be any day in the month.
create or replace function monthly_report(month_start date)
returns table (name text, email text, days bigint, dates text)
language plpgsql stable security definer set search_path = '' as $$
begin
  if not public.is_coordinator() then
    raise exception 'Only coordinators can see the report';
  end if;

  return query
    select (array_agg(a.name  order by a.day desc))[1],  -- most recent name
           (array_agg(a.email order by a.day desc))[1],
           count(*),
           string_agg(to_char(a.day, 'Mon FMDD'), ', ' order by a.day)
    from public.attendance a
    where a.day >= date_trunc('month', month_start)
      and a.day <  date_trunc('month', month_start) + interval '1 month'
    group by a.user_id
    order by count(*) desc, 1;
end;
$$;


-- Only signed-in people can call the functions.
grant usage on schema public to authenticated;
revoke execute on function my_status(), check_in(), monthly_report(date), is_coordinator()
  from public, anon;
grant execute on function my_status(), check_in(), monthly_report(date), is_coordinator()
  to authenticated;
