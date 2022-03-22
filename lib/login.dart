import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class loginPage extends StatefulWidget {
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("place holder text"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Login Page",
            ),
            Container(
              width: 100,
              margin: const EdgeInsets.all(10.0),
              child: Column(
                children: const [Text("Username"), TextField()],
              ),
            ),
            Container(
              width: 100,
              margin: const EdgeInsets.all(10.0),
              child: Column(
                children: const [Text("Password"), TextField()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
