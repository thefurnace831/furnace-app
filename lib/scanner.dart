import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:furnace_app/welcome.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/room.dart';

class ScanPage extends StatefulWidget {
  final bool checkedIn;
  final DateTime? checkInTime;
  final Room savedRoom;

  const ScanPage(this.checkedIn, this.checkInTime, this.savedRoom, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanState();
}

class _ScanState extends State<ScanPage> {
  bool scanned = false;
  String scannedCode = "";
  String scannedCodeResult = "";
  late Room roomInfo;
  DateTime? checkInTime;

  Future<void> scanQRCode() async {
    try {
      scannedCodeResult = await FlutterBarcodeScanner.scanBarcode(
          "#000000", "Cancel", true, ScanMode.QR);
      scanned = true;
    } on PlatformException {
      scannedCodeResult = "Failed";
      scanned = false;
    }
    // If widget removed while message was in flight then discard it
    if (!mounted) return;

    setState(() {
      scannedCode = scannedCodeResult;
    });

    if (scanned) {
      if (!widget.checkedIn) {
        // Don't retrieve room information again unless logged out of room
        roomInfo = await parseRoom();

        if (roomInfo.qrCheckoutValue == scannedCode) {
          showError("Check into a room first");
          return;
        }
      } else {
        roomInfo = widget.savedRoom;
      }

      checkInTime = DateTime.now();

      if (scannedCode == roomInfo.qrCheckoutValue && widget.checkedIn) {
        createLog(roomInfo.roomName);

        //mounted property must be checked after an asynchronous gap.
        if (!mounted) return;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                WelcomePage(false, widget.checkInTime, roomInfo)));
        return;
      } else if (widget.checkedIn && scannedCode != roomInfo.qrRoomValue) {
        checkInTime = widget.checkInTime;
        showError("Checkout of ${roomInfo.roomName} first!");
        return;
      } else if (scannedCode == roomInfo.qrRoomValue) {
        if (widget.checkedIn) {
          checkInTime = widget.checkInTime;
          showError("Already checked into ${roomInfo.roomName}!");
          return;
        }

        //mounted property must be checked after an asynchronous gap.
        if (!mounted) return;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => WelcomePage(true, checkInTime, roomInfo)));
      } else {
        showError("Invalid QR Code!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!scanned) {
      scanQRCode();
    }
    return const Scaffold();
  }

  // Convert ParseObject to RoomObject
  Future<Room> parseRoom() async {
    var obj = await fetchRoomFromDatabase();
    final roomId = obj[0].get('objectId').toString();
    final roomName = obj[0].get('roomName').toString();
    final qrRoomValue = obj[0].get('qrRoomValue').toString();
    final qrCheckoutValue = obj[0].get('qrCheckoutValue').toString();

    return Room(
        roomId: roomId,
        roomName: roomName,
        qrRoomValue: qrRoomValue,
        qrCheckoutValue: qrCheckoutValue);
  }

  // Query database for row with same qrCodeValue
  Future<List<ParseObject>> fetchRoomFromDatabase() async {
    final QueryBuilder<ParseObject> parseQuery1 =
        QueryBuilder<ParseObject>(ParseObject('Room'));

    final QueryBuilder<ParseObject> parseQuery2 =
        QueryBuilder<ParseObject>(ParseObject('Room'));

    parseQuery1.whereEqualTo('qrRoomValue', scannedCode);
    parseQuery2.whereEqualTo('qrCheckoutValue', scannedCode);

    QueryBuilder<ParseObject> mainQuery =
        QueryBuilder.or(ParseObject('Room'), [parseQuery1, parseQuery2]);

    final ParseResponse apiResponse = await mainQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  // Create a log of which user checked into which location
  void createLog(String? roomName) async {
    ParseObject timeLog = ParseObject("TimeLog");
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var email = sharedPreferences.get('email').toString();
    var fullName = sharedPreferences.get('fullName').toString();

    timeLog.set("Room", roomName);

    // SET USER INFO ----------------------------------------------------------
    // todo: ParseUser object instead of using sharedPreferences!
    timeLog.set("fullName", fullName);
    timeLog.set("Email", email);
    // ------------------------------------------------------------------------

    // SET THE TIME -----------------------------------------------------------
    DateTime currentTime = DateTime.now();

    // Only create log when user checks out of room
    timeLog.set('CheckInTime', widget.checkInTime);
    timeLog.set('CheckOutTime', currentTime);

    Duration totalTime = currentTime.difference(widget.checkInTime!);
    String hours = totalTime.inHours.toString().padLeft(0, '2');
    String minutes =
        totalTime.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        totalTime.inSeconds.remainder(60).toString().padLeft(2, '0');

    timeLog.set('TotalTime', "$hours:$minutes:$seconds");

    //--------------------------------------------------------------------------

    var response = await timeLog.save();

    if (response.success) {
      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WelcomePage(false, checkInTime, roomInfo)));
    } else {
      showError(response.error!.message);
    }
  }

  void showError(String? errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(errorMessage!),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        WelcomePage(widget.checkedIn, checkInTime, roomInfo)));
              },
            ),
          ],
        );
      },
    );
  }
}
