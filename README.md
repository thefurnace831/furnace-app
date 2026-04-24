# Furnace App

A mobile app for the Furnace Teen Center that allows for scanning QR codes to log information into a database. 

## Mockup
![App flow mockup](assets/images/mockup.svg)

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
