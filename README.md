# Attendance Website (CURRENT)

This repo holds two separate projects. They share no code and no data.

I do not know why people me before tried their hand at a specific Android app. To me, a universal light weight website that can be easily visted though a qr code and never downloaded makes a lot more sense for Katie use case and needs...

**check-in website code? It's in [`checkin-website/`](checkin-website/).**

Check-in website: [`checkin-website/`](checkin-website/)

Setup guide [`checkin-website/README.md`](checkin-website/README.md)

**For daily attendance, use the check-in website.** It does one job, needs no
app install, and its code is small enough for anyone to maintain.

Flutter's `web/` folder is one of the mobile app's build targets and is
unrelated to `checkin-website/`.

---

# Furnace App (ARCHIVED)

### Mobile app (Flutter)

A mobile app for the Furnace Teen Center that allows for scanning QR codes to log information into a database. 

### Mockup
![App flow mockup](assets/images/mockup.svg)

## Features
- QR code scanning for student check-in/check-out
- Secure user authentication and registration
- Student profile management
- Real-time logging of attendance data
- Backend powered by Parse (Back4App)

## Schema (Parse back4app)
### Models


#### User (See [ParseUser](https://pub.dev/documentation/flutter_parse/latest/flutter_parse/ParseUser-class.html) for full details, below are the most relevant properties)

| Property | Type | Description |
| -------- | ---- | ----------- |
| username | String | The email used as the identifying username for the user |
| emailAddress | String | The user's email — also used for password reset |
| fullName | String | The user's full real name |
| studentId | String | The user's school-issued student ID |
| phoneNumber | String | The user's phone number, stored as digits only |
| schoolName | String | The name of the school the user attends |
| birthday | String | The user's date of birth (formatted string from the registration form) |
| gender | String | Selected from the gender dropdown on registration |
| ethnicity | String | Selected from the ethnicity dropdown on registration |
| ecFirstName | String | Emergency contact's first name |
| ecLastname | String | Emergency contact's last name |
| ecRelation | String | Emergency contact's relationship to the user |
| ecPhone | String | Emergency contact's phone number, stored as digits only |

#### Log 

| Property | Type               | Description                           |
| -------- | ------------------ | ------------------------------------- |
| createdAt  | Date | The exact timestamp the log was created. Generated automatically |
| location     | String             | The location the user checked in/out of, provided by the scanned QR code |
| user     | Pointer to Object         | A pointer to the user who created the log|

## Packages
- [parse_server_sdk_flutter](https://pub.dev/packages/parse_server_sdk_flutter) — Parse/Back4App client
- [mobile_scanner](https://pub.dev/packages/mobile_scanner) — QR/barcode scanning
- [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) — loads Parse credentials from `.env`
- [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) — backs the encrypted session-token store (`SecureCoreStore`)
- [shared_preferences](https://pub.dev/packages/shared_preferences) — lightweight key/value storage
- [path_provider](https://pub.dev/packages/path_provider) / [path](https://pub.dev/packages/path) — filesystem paths
- [http](https://pub.dev/packages/http) — HTTP client
- [provider](https://pub.dev/packages/provider) — state management
- [page_transition](https://pub.dev/packages/page_transition) — animated route transitions
- [marquee](https://pub.dev/packages/marquee) — scrolling text widget


## Flutter Resources

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

#### Furnace QR scanner App environment setup
Basic step by help of setting environment is in "Furnace_QR_scanner_App_environment_setup.pdf" file open with some pdf opener like "Adobe" or "Chrome"
