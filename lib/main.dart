import 'package:parse_server_sdk/parse_server_sdk.dart';

import 'package:flutter/material.dart';
import 'package:furnace_app/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'welcome.dart';
import 'scanner.dart';

String finalEmail = "empty";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const keyApplicationId = 'j7D0LsyZNZZf5VgBYrc6FFe6lu2AP5abAab8vcZk';
  const keyClientKey = 'tNNM7p3yOvnxYT95ideyWwZogR0hI57bn1YrX5Qh';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Function for persistent login
    Future getValidationData() async {
      final SharedPreferences sharedPreferences = await SharedPreferences
          .getInstance();
      String obtainedEmail = sharedPreferences.get('email').toString();
      finalEmail = obtainedEmail;

      print("This is " + finalEmail);
    }

    // Function call for persistent login
    getValidationData();

    return MaterialApp(
        title: 'The Furnace',
        theme: ThemeData(
          // This is the theme of your application.
          primarySwatch: Colors.red,
        ),
        // finalEmail=="empty" ? LoginPage() : WelcomePage(false)
        initialRoute: '/',
        routes: {
          '/': (context) => const MyHomePage(title: 'The Furnace Home Page'),
          '/login': (context) => LoginPage(),
          '/register': (context) => const Register(),
          '/welcome': (context) => WelcomePage(false, null),
          '/scanner': (context) => ScanPage(false, null)
        });


  }
}


// This widget contains buttons for navigating to Login and Registration
class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                Container(
                    padding: EdgeInsets.all(1),
                    width: 300,
                    //margin: const EdgeInsets.all(20),
                    child: Column(
                        children: [
                          Text("Welcome",
                              textScaleFactor: 1.3,
                              style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,  fontFamily: 'Crunchy')
                          ),

                        ]
                    )
                )
              ],
            ),

            const Spacer(
              flex: 3,
            ),
            Image.asset('assets/images/logo.png',
                height: 200, width: 300, fit: BoxFit.fitWidth),
            const Spacer(
              flex: 1,
            ),
            FloatingActionButton.extended(
              heroTag: "loginMenuButton",
              onPressed:  () async {
                // Code for persistent login
                final SharedPreferences sharedPreferences = await SharedPreferences
                    .getInstance();

                if( sharedPreferences.get('email')== "empty") {
                  Navigator.pushNamed(context, '/login');
                }
                else{
                  Navigator.pushNamed(context, '/welcome');
                }
              },
              label: const Text('Login'),
            ),
            const Spacer(
              flex: 1,
            ),
            FloatingActionButton.extended(
              heroTag: "registerMenuButton",
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              label: const Text('Register'),
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
