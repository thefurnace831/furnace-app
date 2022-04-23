import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  String usermame = "";
  String password = "";

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Furnace Login"),
        ),
        body: Column(
          children: [
            Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 100),
                    child: Text(
                      "Login Page",
                      textScaleFactor: 2,
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: 100,
                        margin: const EdgeInsets.all(10.0),
                        child: Column(
                          children: const [
                            Text("Email", textScaleFactor: 1.2),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 100,
                        margin: const EdgeInsets.all(10.0),
                        child: Column(
                          children: const [
                            Text(
                              "Password",
                              textScaleFactor: 1.2,
                            ),
                            TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                            onPressed: () {
                              // ignore: dead_code
                              if (false) {
                                //todo: implement button functionality
                              }
                            },
                            child: const Text('Submit')),
                      ),
                    ],
                  ),
                  FloatingActionButton.extended(
                    heroTag: "loginMenuButton",
                    onPressed: () {
                      Navigator.pushNamed(context, '/landing');
                    },
                    label: const Text('Login'),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
