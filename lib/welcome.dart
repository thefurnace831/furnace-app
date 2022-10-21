import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:furnace_app/scanner.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  bool checkedIn;
  WelcomePage(this.checkedIn, {Key? key}) : super(key: key);


  @override
  WelcomePageState createState() => WelcomePageState();
}

// The page of the app that is displayed a to logged-in user
class WelcomePageState extends State<WelcomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("The Furnace"),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(primary: Colors.white),
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
            FloatingActionButton.extended(
              heroTag: "cameraButton",
              onPressed: () {
                //Navigator.pushNamed(context, '/scanner');
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScanPage(widget.checkedIn)));
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

     print("This is " + sharedPreferences.get('email').toString());

    //final user = await ParseUser.currentUser();
    if (user == null) {
      print("inside");
      return;
    }

    await user.logout();

    Navigator.pushNamed(context, "/");
  }
}
