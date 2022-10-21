import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:furnace_app/welcome.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

// TODO: Remove hardcoded strings, add to a database instead

class ScanPage extends StatefulWidget {
  bool checkedIn;
  DateTime? initTime;

  ScanPage(this.checkedIn, this.initTime, {Key? key}) : super(key: key);
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<ScanPage> {
  String _qrData = "";
  bool scanned = false;

  // The Furnace Teen Center Rooms to track
  Map<String, String> rooms = {
    'The Study-Z72N!eWw*D': 'The Study',
    'Gym-^eAh5#8MGM': 'Gym',
    'Cafe-Bju9#o\$pxg': 'Cafe',
    'Multipurpose-XyiZW&%v5w': 'Multipurpose',
    'Game Room-rxpU#Q56G!': 'Game Room',
    'Prayer Room-^Gh@m7RJ!s': 'Prayer Room'
  };

  _scanCode() async {
    String scannedCode = "";

    try {
      scannedCode = await FlutterBarcodeScanner.scanBarcode("#000000", "Cancel", true, ScanMode.QR);
      scanned = true;
    } on PlatformException {
      scannedCode = "Failed";
      scanned = false;
    }

    // If widget removed while message was in flight then discard it
    if (!mounted) return;

    if (scannedCode == "Check out-Qq86!^B*UW") {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => WelcomePage(widget.checkedIn = false, null)));
      return;
    } else if (widget.checkedIn && scannedCode != "Check out-Qq86!^B*UW") {
      //TODO: SHOW WHICH ROOM THEY NEED TO CHECK OUT OF IN ERROR MSG
      showError("Checkout of Previous Room!");
      return;
    } else if (rooms.containsKey(scannedCode)) {
      setState(() {
        _qrData = rooms[scannedCode].toString();
        createLog(_qrData); // Create log with location from scanned qr code data
      });
    } else {
      showError("Invalid QR Code!");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!scanned) {
      _scanCode();
    }
    return const Scaffold();
  }

  // Create a log of which user checked into which location
  void createLog(String location) async {
    ParseObject newLog = ParseObject("log");
    ParseUser? user = await ParseUser.currentUser() as ParseUser?;
    newLog.set("location", location);
    newLog.set("user", user);

    var response = await newLog.save();

    if (response.success) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => WelcomePage(widget.checkedIn = true, widget.initTime)));
    } else {
      widget.checkedIn = false;
      showError(response.error!.message);
    }
  }

  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => WelcomePage(widget.checkedIn, widget.initTime)));
              },
            ),
          ],
        );
      },
    );
  }
}