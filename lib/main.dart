import 'package:page_transition/page_transition.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'package:flutter/material.dart';
import 'package:furnace_app/register.dart';

import 'api/room.dart';
import 'login.dart';
import 'secure_core_store.dart';
import 'welcome.dart';
import 'scanner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const keyApplicationId = 'q5fW7bzeVL9PnFWUoWt8l9tGl3HxHVvFOLQKe8G5';
  const keyClientKey = '3XYTD8qj1WVOkzZmyDng5Mdi1e3YLGuiQamD2yrv';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    autoSendSessionId: true,
    coreStore: await SecureCoreStore.getInstance(),
  );

  final currentUser = await ParseUser.currentUser() as ParseUser?;
  final isLoggedIn = currentUser?.sessionToken != null;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'The Furnace',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        initialRoute: isLoggedIn ? '/welcome' : '/',
        routes: {
          '/': (context) => const MyHomePage(title: 'The Furnace Home Page'),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const Register(),
          '/welcome': (context) => WelcomePage(
              false,
              null,
              Room(
                  roomId: '',
                  roomName: '',
                  qrRoomValue: '',
                  qrCheckoutValue: '')),
          '/scanner': (context) => ScanPage(
              false,
              null,
              Room(
                  roomId: '',
                  roomName: '',
                  qrRoomValue: '',
                  qrCheckoutValue: ''))
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

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Home Page"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Center(
                    child: Image.asset('assets/images/logo.png',
                        height: 200, width: 300, fit: BoxFit.fitWidth),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                  child: Center(
                    child: FloatingActionButton.extended(
                      heroTag: "loginMenuButton",
                      onPressed: () async {
                        final currentUser =
                            await ParseUser.currentUser() as ParseUser?;

                        if (!context.mounted) return;
                        if (currentUser == null ||
                            currentUser.sessionToken == null) {
                          Navigator.of(context).push(PageTransition(
                              child: const LoginPage(),
                              type: PageTransitionType.topToBottom,
                              duration: const Duration(milliseconds: 600)));
                        } else {
                          Navigator.of(context).push(PageTransition(
                              child: WelcomePage(
                                  false,
                                  null,
                                  Room(
                                      roomId: '',
                                      roomName: '',
                                      qrRoomValue: '',
                                      qrCheckoutValue: '')),
                              type: PageTransitionType.topToBottom,
                              duration: const Duration(milliseconds: 600)));
                        }
                      },
                      label: const Text('Login'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                  child: Center(
                    child: FloatingActionButton.extended(
                      heroTag: "registerMenuButton",
                      onPressed: () {
                        Navigator.of(context).push(PageTransition(
                            child: const Register(),
                            type: PageTransitionType.topToBottom,
                            duration: const Duration(milliseconds: 600)));
                      },
                      label: const Text('Register'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
