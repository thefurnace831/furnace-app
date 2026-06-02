import 'package:furnace_app/admin/admin_view_users/student_details/student_details_screen.dart';
import 'package:furnace_app/admin/admin_view_users/student_details/student_details_viewmodel.dart';
import 'package:furnace_app/admin/admin_view_users/view_users_screen.dart';
import 'package:furnace_app/admin/admin_view_users/view_users_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'admin/admin_home/admin_home_screen.dart';
import 'admin/admin_view_users/view_students/admin_view_students_viewmodel.dart';
import 'admin/admin_view_users/view_students/view_students_screen.dart';
import 'admin/analytics/analytics_screen.dart';
import 'api/room.dart';
import 'login.dart';
import 'main.dart';
import 'register.dart';
import 'welcome.dart';
import 'scanner.dart';
import 'admin/admin_home/admin_home_screen_viewmodel.dart';
import 'admin/admin_settings/admin_settings_screen.dart';

import 'admin/admin_settings/admin_settings_edit_screen.dart';

import 'admin/admin_rooms/admin_rooms_view/admin_rooms_view_screen.dart';
import 'admin/admin_rooms/admin_rooms_view/admin_rooms_view_viewmodel.dart';

import 'admin/admin_settings/admin_settings_viewmodel.dart';

import 'admin/admin_rooms/admin_rooms_list/admin_rooms_screen.dart';
import 'admin/admin_rooms/admin_rooms_list/admin_rooms_screen_viewmodel.dart';
import 'admin/admin_rooms/admin_rooms_view/admin_rooms_view_screen.dart';
import 'admin/admin_rooms/admin_rooms_view/admin_rooms_view_viewmodel.dart';

class AppRouter {
  static GoRouter router({
    required bool isLoggedIn,
    required bool isAdmin,
  }) {
    final adminSettingsViewmodel = AdminSettingsViewmodel();
    return GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        final location = state.uri.toString();

        final isAuthPage =
            location == '/' || location == '/login' || location == '/register';

        if (!isLoggedIn && !isAuthPage) {
          return '/login';
        }

        if (isLoggedIn && isAuthPage) {
          return isAdmin ? '/admin-home' : '/welcome';
        }

        // Prevent non-admin users from manually navigating to admin routes
        if (location.startsWith('/admin') && !isAdmin) {
          return '/welcome';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) {
            return const MyHomePage(title: 'The Furnace Home Page');
          },
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) {
            return const Register();
          },
        ),
        GoRoute(
          path: '/welcome',
          name: 'welcome',
          builder: (context, state) {
            return WelcomePage(
              false,
              null,
              Room(
                roomId: '',
                roomName: '',
                qrRoomValue: '',
                qrCheckoutValue: '',
              ),
            );
          },
        ),
        GoRoute(
          path: '/scanner',
          name: 'scanner',
          builder: (context, state) {
            return ScanPage(
              false,
              null,
              Room(
                roomId: '',
                roomName: '',
                qrRoomValue: '',
                qrCheckoutValue: '',
              ),
            );
          },
        ),
        GoRoute(
          path: '/admin-home',
          name: 'Admin Home',
          builder: (context, state) {
            return AdminHomePage(
              viewModel: AdminHomeScreenViewmodel(),
            );
          },
        ),
        GoRoute(
          path: '/admin-analytics',
          name: 'adminAnalytics',
          builder: (context, state) {
            return const AnalyticsScreen();
          },
        ),
        GoRoute(
          path: '/admin-settings',
          name: 'adminSettings',
          builder: (context, state) {
            return AdminSettingsScreen(
              viewModel: adminSettingsViewmodel,
            );
          },
        ),
        GoRoute(
          path: '/admin-settings-edit',
          name: 'adminSettingsEdit',
          builder: (context, state) {
            return AdminSettingsEditScreen(
              viewModel: adminSettingsViewmodel,
            );
          },
        ),
        GoRoute(
          path: '/admin-view-students',
          name: "Admin View Students",
          builder: (context, state) {
            return AdminViewStudentsScreen(
              viewModel: AdminViewStudentsViewmodel(
                studentRepository: context.read(),
              ),
            );
          },
        ),
        GoRoute(
            path: '/admin-view-users',
            builder: (context, state) {
              return ViewUsersScreen(
                viewModel: ViewUsersViewmodel(),
              );
            }),
        GoRoute(
            path: '/admin-view-admins',
            builder: (context, state) {
              // Placeholder screen
              return ViewUsersScreen(
                viewModel: ViewUsersViewmodel(),
              );
            }),
        GoRoute(
            path: '/admin-student-details/:userId',
            name: 'adminStudentDetails',
            builder: (context, state) {
              return StudentDetailsScreen(
                  viewModel: StudentDetailsViewmodel(
                      studentRepository: context.read(),
                      timeLogRepository: context.read(),
                      userId: state.pathParameters['userId']!));
            }),
        GoRoute(
            path: '/admin-view-rooms',
            name: "Admin View Rooms",
            builder: (context, state) {
              return AdminViewRoomsScreen(
                viewModel: RoomsScreenViewmodel(roomrepository: context.read()),
              );
            }),
        GoRoute(
            path: '/admin-room-details/:roomId',
            name: "adminRoomDetails",
            builder: (context, state) {
              return AdminRoomDetailsScreen(
                viewModel: AdminRoomDetailViewmodel(
                    roomRepository: context.read(),
                    roomId: state.pathParameters['roomId']!),
              );
            }),
      ],
    );
  }
}
