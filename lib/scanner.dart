import 'package:flutter/material.dart';
import 'package:furnace_app/furnace_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:furnace_app/welcome.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'api/room.dart';

class ScanPage extends StatefulWidget {
  final bool checkedIn;
  final DateTime? checkInTime;
  final Room savedRoom;

  const ScanPage(this.checkedIn, this.checkInTime, this.savedRoom, {super.key});

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

    setState(() => _processing = true);
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
      final saved = await createLog(roomInfo.roomName);
      if (!saved || !mounted) return;

      Navigator.of(context).pushReplacement(MaterialPageRoute(
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
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => WelcomePage(true, checkInTime, roomInfo)));
    } else {
      showError("Invalid QR Code!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = widget.checkedIn ? 'Check out' : 'Check in';

    return Scaffold(
      appBar: AppBar(
        title: Text('$mode QR code'),
        backgroundColor: FurnaceColors.ink,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.78,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha(52),
                    Colors.black.withAlpha(185),
                  ],
                  stops: const [0.38, 0.58, 1],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
              child: Column(
                children: [
                  _buildStatusBanner(mode),
                  const Spacer(),
                  const _ScannerFrame(),
                  const Spacer(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: _processing
                        ? const _ProcessingBanner()
                        : const SizedBox(height: 48),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBanner(String mode) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FurnaceColors.ink.withAlpha(216),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withAlpha(50)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: FurnaceColors.amber.withAlpha(42),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.qr_code_scanner_rounded,
                color: FurnaceColors.amber,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$mode at The Furnace',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
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

  Future<bool> createLog(String? roomName) async {
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
    if (response.success) return true;

    if (mounted) showError(response.error!.message);
    return false;
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
                setState(() => _processing = false);
                _controller.start();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _ScannerFrame extends StatelessWidget {
  const _ScannerFrame();

  @override
  Widget build(BuildContext context) {
    final size = (MediaQuery.of(context).size.width - 88).clamp(220.0, 300.0);
    const corners = [
      Alignment.topLeft,
      Alignment.topRight,
      Alignment.bottomLeft,
      Alignment.bottomRight,
    ];

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withAlpha(210)),
              ),
            ),
          ),
          for (final alignment in corners)
            Align(
              alignment: alignment,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: alignment == Alignment.topLeft
                        ? const Radius.circular(8)
                        : Radius.zero,
                    topRight: alignment == Alignment.topRight
                        ? const Radius.circular(8)
                        : Radius.zero,
                    bottomLeft: alignment == Alignment.bottomLeft
                        ? const Radius.circular(8)
                        : Radius.zero,
                    bottomRight: alignment == Alignment.bottomRight
                        ? const Radius.circular(8)
                        : Radius.zero,
                  ),
                  border: Border(
                    top: alignment.y < 0
                        ? const BorderSide(
                            color: FurnaceColors.amber,
                            width: 5,
                          )
                        : BorderSide.none,
                    bottom: alignment.y > 0
                        ? const BorderSide(
                            color: FurnaceColors.amber,
                            width: 5,
                          )
                        : BorderSide.none,
                    left: alignment.x < 0
                        ? const BorderSide(
                            color: FurnaceColors.amber,
                            width: 5,
                          )
                        : BorderSide.none,
                    right: alignment.x > 0
                        ? const BorderSide(
                            color: FurnaceColors.amber,
                            width: 5,
                          )
                        : BorderSide.none,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProcessingBanner extends StatelessWidget {
  const _ProcessingBanner();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FurnaceColors.paper,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 10),
            Text(
              'Reading code',
              style: TextStyle(
                color: FurnaceColors.ink,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
