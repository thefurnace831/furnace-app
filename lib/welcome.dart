import 'dart:async';

import 'package:flutter/material.dart';
import 'package:furnace_app/main.dart';
import 'package:furnace_app/scanner.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/room.dart';

import 'api/room.dart';

class WelcomePage extends StatefulWidget {
  bool checkedIn;
  DateTime? initTime;
  Room room;
  WelcomePage(this.checkedIn, this.initTime, this.room, {Key? key}) : super(key: key);

  @override
  WelcomePageState createState() => WelcomePageState();
}

// The page of the app that is displayed a to logged-in user
class WelcomePageState extends State<WelcomePage> {
  Timer? timer;
  String? loggedTime;

  @override
  void initState() {
    super.initState();
    loggedTime = "";

    if (widget.initTime == null && widget.checkedIn) {
      widget.initTime = DateTime.now();
    }

    if (widget.checkedIn) {
      timer = Timer.periodic(const Duration(seconds: 0), (timer) {
        setState(() {
          loggedTime = getLoggedTime(widget.initTime!);
        });
      });
    } else {
      timer?.cancel();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(
              flex: 3,
            ),
            const Text(
              'The Furnace',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const Spacer(
              flex: 1,
            ),
            Text(
              widget.checkedIn ? '${widget.room.roomName}' : "",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Spacer(
              flex: 1,
            ),
            Text(
              widget.checkedIn ?  'Checked In: $loggedTime' : "",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
            ),
            const Spacer(
              flex: 1,
            ),
            FloatingActionButton.extended(
              heroTag: "cameraButton",
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ScanPage(widget.checkedIn, widget.initTime, widget.room)));
              },
              label: Text(widget.checkedIn ? "QR Check Out" : "QR Check In"),
              icon: const Icon(Icons.qr_code_scanner),
            ),
            const Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }

  void logout() async {

    // Code for persistent login
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final user = ParseUser(sharedPreferences.get('email').toString(), sharedPreferences.get('pass').toString(), null);

     sharedPreferences.setString('email', "empty");
     sharedPreferences.setString('pass', '');
     sharedPreferences.setBool('loggedIn', false);

     print("This is " + sharedPreferences.get('email').toString());

    //final user = await ParseUser.currentUser();
    if (user == null) {
      print("inside");
      return;
    }

    await user.logout();

    //Navigator.pushNamed(context, "/");
    Navigator.push(context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, animationTime,child) {
          return ScaleTransition(
            alignment: Alignment.center,
            scale: animation,

            child: child,
          );
        },
        pageBuilder: (context, animation, animationTime){
          return MyHomePage(title: 'The Furnace Home Page');
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
