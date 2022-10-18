import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  String username = "";
  String password = "";

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                    padding: EdgeInsets.fromLTRB(20, 50, 20, 50),
                    child: Text(
                      "Login",
                      textScaleFactor: 3,
                    ),
                  ),
                  Column(
                    children: [
                      Container( // EMAIL BOX
                        width: 200,
                        margin: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            // const Text("Email", textScaleFactor: 1.2),
                            TextField(
                              textAlign: TextAlign.center,
                              controller: _emailController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Email',
                              ),
                            )
                          ],
                        ),
                      ),


                      Container( // PASSWORD BOX
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2, color: Colors.green),
                        ),
                        width: 200,
                        margin: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            // const Text(
                            //   "Password",
                            //   textScaleFactor: 1.2,
                            // ),
                            TextField(
                              textAlign: TextAlign.center,
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Password'
                              ),
                            ),
                          ],
                        ),


                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 20.0),
                      ),
                      SizedBox(
                        width: 175.0,
                        height: 40.0,
                        child: ElevatedButton(
                            onPressed: () { login(); },
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

    final user = ParseUser(email, password, null);

    var response = await user.login();

    if (response.success) {
      Navigator.pushNamed(context, '/welcome');
    } else {
      showError(response.error!.message);
    }
  }
}
