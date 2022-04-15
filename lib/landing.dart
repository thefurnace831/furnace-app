import 'package:flutter/material.dart';

class landingPage extends StatefulWidget {
  landingPageState createState() => landingPageState();
}

class landingPageState extends State<landingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("The Furnace"),
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
              heroTag: "loginMenuButton",
              onPressed: () {},
              label: const Text('Scan QR'),
            ),
            const Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}
