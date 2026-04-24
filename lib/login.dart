import 'package:flutter/material.dart';
import 'package:furnace_app/forgot_password.dart';
import 'package:furnace_app/welcome.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'api/room.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static final _emailRegex = RegExp(r'^[\w\.\-\+]+@[\w\.\-]+\.\w{2,}$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Furnace Login"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                  child: Center(
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 42),
                    ),
                  ),
                ),
                Center(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          width: 300,
                          margin: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Email",
                              prefixIcon: Icon(Icons.email),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email is required';
                              }
                              if (!_emailRegex.hasMatch(value.trim())) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          width: 300,
                          margin: const EdgeInsets.all(10),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: _passwordController,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Password",
                              prefixIcon: Icon(Icons.lock),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Password is required';
                              }
                              if (value.trim().length < 6) {
                                return 'Must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                        ),
                        Center(
                          child: SizedBox(
                            width: 175.0,
                            height: 40.0,
                            child: ElevatedButton(
                                onPressed: () async {
                                  login();
                                },
                                child: const Text('Submit')),
                          ),
                        ),
                        TextButton(
                          onPressed: _openPasswordReset,
                          child: const Text('Forgot password?'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _openPasswordReset() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ForgotPasswordPage(
          initialEmail: _emailController.text,
        ),
      ),
    );
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

  void login() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

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
