import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:furnace_app/welcome.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'api/room.dart';

class ScanPage extends StatefulWidget {
  bool checkedIn;
  DateTime? initTime;
  Room room;

  ScanPage(this.checkedIn, this.initTime, this.room, {Key? key})
      : super(key: key);
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<ScanPage> {
  bool scanned = false;
  String scannedCode = "";

  _scanCode() async {
    try {
      scannedCode = await FlutterBarcodeScanner.scanBarcode(
          "#000000", "Cancel", true, ScanMode.QR);
      scanned = true;
    } on PlatformException {
      scannedCode = "Failed";
      scanned = false;
    }
    // If widget removed while message was in flight then discard it
    if (!mounted) return;

    if (scanned) {
      if (!widget.checkedIn) {
        // Don't retrieve room information again unless logged out of room
        widget.room = await parseRoom();

        if (widget.room.qrCheckoutValue == scannedCode) {
          showError("Check into a room first");
          return;
        }
      }

      if (scannedCode == widget.room.qrCheckoutValue) {
        createLog(widget.room.roomName, true);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                WelcomePage(widget.checkedIn = false, null, widget.room)));
        return;
      } else if (widget.checkedIn && scannedCode != widget.room.qrRoomValue) {
        showError("Checkout of ${widget.room.roomName} first!");
        return;
      } else if (scannedCode == widget.room.qrRoomValue) {
        if (widget.checkedIn) {
          showError("Already checked into ${widget.room.roomName}!");
          return;
        }
        setState(() {
          createLog(widget.room
              .roomName, false); // Create log with location from scanned qr code data
        });
      } else {
        showError("Invalid QR Code!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!scanned) {
      _scanCode();
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
    widget.room.qrCheckoutValue = qrCheckoutValue;

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
  void createLog(String? roomName, bool checkOut) async {
    ParseObject timeLog = ParseObject("TimeLog");
    ParseUser? user = await ParseUser.currentUser() as ParseUser?;
    timeLog.set("User", user);
    timeLog.set("Room", roomName);

    if (!checkOut) {
      timeLog.set('CheckInTime', DateTime.now());
    } else {
      timeLog.set('CheckOutTime', DateTime.now());
    }

    var response = await timeLog.save();

    if (response.success) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WelcomePage(
              widget.checkedIn = true, widget.initTime, widget.room)));
    } else {
      widget.checkedIn = false;
      widget.room =
          Room(roomId: '', roomName: '', qrRoomValue: '', qrCheckoutValue: '');
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
                    builder: (context) => WelcomePage(
                        widget.checkedIn, widget.initTime, widget.room)));
              },
            ),
          ],
        );
      },
    );
  }
}
