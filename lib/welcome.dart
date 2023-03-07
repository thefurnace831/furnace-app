import 'dart:async';

import 'package:flutter/material.dart';
import 'package:furnace_app/main.dart';
import 'package:furnace_app/scanner.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/room.dart';

class WelcomePage extends StatefulWidget {
  final bool checkedIn;
  final DateTime? checkInTime;
  final Room room;

  const WelcomePage(this.checkedIn, this.checkInTime, this.room, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => WelcomePageState();
}

// The page of the app that is displayed a to logged-in user
class WelcomePageState extends State<WelcomePage> {
  Timer? timer;
  String? loggedTime;
  DateTime? logInTime;

  @override
  void initState() {
    super.initState();
    loggedTime = "";

    if (widget.checkInTime == null && widget.checkedIn) {
      // Start timer
      logInTime = DateTime.now();
    } else if (widget.checkInTime != null && widget.checkedIn) {
      // Timer was already started so resume
      logInTime = widget.checkInTime;
    }

    if (widget.checkedIn) {
      timer = Timer.periodic(const Duration(seconds: 0), (timer) {
        setState(() {
          loggedTime = getLoggedTime(logInTime!);
        });
      });
    } else {
      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Going back from welcomePage will delete check in status and timer information
    // By wrapping widget contents in WillPopScope it disables the back button
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          // Disable appBar back button
          automaticallyImplyLeading: false,
          title: const Text("The Furnace"),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              onPressed: () {
                logout();
              },
              child: const Text('Logout'),
            )
          ],
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  Container(
                      padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                      child: Image.asset('assets/images/logo.png',
                          height: 200, width: 300, fit: BoxFit.fitWidth)),
                  Container(
                      padding: const EdgeInsets.fromLTRB(0, 35, 0, 0),
                      width: 300,
                      child: Column(children: const [
                        Text("Welcome",
                            textScaleFactor: 3.5,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Creation',
                                color: Colors.orange)),
                      ])),
                  Container(
                      padding: const EdgeInsets.all(1),
                      width: 300,
                      child: Column(children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                          child: Text(
                            widget.checkedIn ? '${widget.room.roomName}' : "",
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                          child: Text(
                              widget.checkedIn ? 'Timer: $loggedTime' : ""),
                        ),
                      ])),
                  Container(
                    child: FloatingActionButton.extended(
                      heroTag: "cameraButton",
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ScanPage(
                                widget.checkedIn, logInTime, widget.room)));
                      },
                      label: Text(
                          widget.checkedIn ? "QR Check Out" : "QR Check In"),
                      icon: const Icon(Icons.qr_code_scanner),
                    ),
                  ),
                ],
              ),
              const Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logout() async {
    // Code for persistent login
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final user = ParseUser(sharedPreferences.get('email').toString(),
        sharedPreferences.get('pass').toString(), null);

    sharedPreferences.setString('email', "empty");
    sharedPreferences.setString('pass', '');
    sharedPreferences.setBool('loggedIn', false);

    await user.logout();

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, animationTime, child) {
          return ScaleTransition(
            alignment: Alignment.center,
            scale: animation,
            child: child,
          );
        },
        pageBuilder: (context, animation, animationTime) {
          return const MyHomePage(title: 'The Furnace Home Page');
        },
      ),
    );
  }
}

String getLoggedTime(DateTime startTime) {
  Duration totalTime = DateTime.now().difference(startTime);

  String hours = totalTime.inHours.toString().padLeft(0, '2');
  String minutes = totalTime.inMinutes.remainder(60).toString().padLeft(2, '0');
  String seconds = totalTime.inSeconds.remainder(60).toString().padLeft(2, '0');

  return "$hours:$minutes:$seconds";
}
