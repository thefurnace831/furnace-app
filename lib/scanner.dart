import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:furnace_app/welcome.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

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
  bool _processing = false;
  late Room roomInfo;
  DateTime? checkInTime;
  final MobileScannerController _controller = MobileScannerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_processing) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;

    _processing = true;
    final scannedCode = barcode!.rawValue!;
    await _controller.stop();

    if (!mounted) return;
    await _processCode(scannedCode);
  }

  Future<void> _processCode(String scannedCode) async {
    if (!widget.checkedIn) {
      final parsed = await _parseRoom(scannedCode);
      if (!mounted) return;
      if (parsed == null) {
        showError("Invalid QR Code!");
        return;
      }
      roomInfo = parsed;

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

      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WelcomePage(true, checkInTime, roomInfo)));
    } else {
      showError("Invalid QR Code!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: _onDetect,
      ),
    );
  }

  Future<Room?> _parseRoom(String scannedCode) async {
    var obj = await _fetchRoomFromDatabase(scannedCode);
    if (obj.isEmpty) return null;

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

  Future<List<ParseObject>> _fetchRoomFromDatabase(String scannedCode) async {
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

  void createLog(String? roomName) async {
    ParseObject timeLog = ParseObject("TimeLog");
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    final email = currentUser?.username ?? '';
    final fullName = currentUser?.get<String>('fullName') ?? '';

    timeLog.set("Room", roomName);
    timeLog.set("fullName", fullName);
    timeLog.set("Email", email);

    DateTime currentTime = DateTime.now();

    timeLog.set('CheckInTime', widget.checkInTime);
    timeLog.set('CheckOutTime', currentTime);

    Duration totalTime = currentTime.difference(widget.checkInTime!);
    String hours = totalTime.inHours.toString().padLeft(2, '0');
    String minutes =
        totalTime.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        totalTime.inSeconds.remainder(60).toString().padLeft(2, '0');

    timeLog.set('TotalTime', "$hours:$minutes:$seconds");

    var response = await timeLog.save();
    if (!mounted) return;

    if (response.success) {
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
