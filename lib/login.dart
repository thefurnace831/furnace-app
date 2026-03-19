import 'package:flutter/material.dart';
import 'package:furnace_app/welcome.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'api/room.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
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
                    padding: EdgeInsets.fromLTRB(20, 50, 20, 50),
                    child: Text(
                      "Login",
                      textScaleFactor: 3,
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        width: 300,
                        margin: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            TextField(
                              textAlign: TextAlign.center,
                              controller: _emailController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Email",
                                prefixIcon: Icon(Icons.email),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        width: 300,
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            TextField(
                              textAlign: TextAlign.center,
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Password",
                                prefixIcon: Icon(Icons.lock),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                      ),
                      SizedBox(
                        width: 175.0,
                        height: 40.0,
                        child: ElevatedButton(
                            onPressed: () async {
                              login();
                            },
                            child: const Text('Submit')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
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
              },
            ),
          ],
        );
      },
    );
  }

  // Attempts to log the user in to Parse
  void login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showError("All fields are required!");
      return;
    }

    final user = ParseUser(email, password, email);

    var response = await user.login();

    if (response.success) {
      if (!mounted) return;
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
            return WelcomePage(
                false,
                null,
                Room(
                    roomId: '',
                    roomName: '',
                    qrRoomValue: '',
                    qrCheckoutValue: ''));
          },
        ),
      );
    } else {
      showError(response.error!.message);
    }
  }
}
