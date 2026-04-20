# Furnace App

A mobile app for the Furnace Teen Center that allows for scanning QR codes to log information into a database. 

## Send check-in data to Google Sheets

1. Create a Google Sheet and open `Extensions -> Apps Script`.
2. Copy code from `scripts/google_sheets_webhook.gs` into the script editor.
3. Set `SECRET` in that script.
4. Deploy as a Web App (`Deploy -> New deployment -> Web app`) with access set so your app can POST to it.
5. Copy the deployment URL.

Run Flutter with your webhook settings:

```zsh
cd /Users/anthony/AndroidStudioProjects/furnace-app
/Users/anthony/AndroidStudioProjects/sdk/flutter/bin/flutter run -d android \
  --dart-define=SHEETS_WEBHOOK_URL="<YOUR_APPS_SCRIPT_WEBAPP_URL>" \
  --dart-define=SHEETS_WEBHOOK_SECRET="<YOUR_SECRET>"
```

Check-in and check-out events are posted from `lib/scanner.dart` and include user profile data from Parse plus room/QR/time values.

## Mockup
![Screenshot from 2022-03-08 10-10-15](https://user-images.githubusercontent.com/70172259/157299673-d72c1228-e09f-4747-8b78-b442f4f799bd.png)

## Schema (Parse back4app)
### Models


#### User (See [ParseUser](https://pub.dev/documentation/flutter_parse/latest/flutter_parse/ParseUser-class.html) for full details, below are the most relevant properties)

| Property | Type               | Description                           |
| -------- | ------------------ | ------------------------------------- |
| username  | String | The email used as the identfying username for the user |
| fullName     | String             | The user's full real name |

#### Log 

| Property | Type               | Description                           |
| -------- | ------------------ | ------------------------------------- |
| createdAt  | Date | The exact timestamp the log was created. Generated automatically |
| location     | String             | The location the user checked in/out of, provided by the scanned QR code |
| user     | Pointer to Object         | A pointer to the user who created the log|

## Packages
- [Parse Server Sdk Flutter](https://pub.dev/packages/parse_server_sdk_flutter)
- [Camera](https://pub.dev/packages/camera)
- [Flutter Barcode Scanner](https://pub.dev/packages/flutter_barcode_scanner)


## Flutter Resources

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

#### Furnace QR scanner App environment setup
Basic step by help of setting environment is in "Furnace_QR_scanner_App_environment_setup.pdf" file open with some pdf opener like "Adobe" or "Chrome"