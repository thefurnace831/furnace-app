import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:furnace_app/data/repositories/student/student_repository_remote.dart';
import 'package:furnace_app/routes.dart';
import 'package:furnace_app/utils/result.dart';
import 'package:page_transition/page_transition.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'package:flutter/material.dart';
import 'package:furnace_app/furnace_ui.dart';
import 'package:furnace_app/register.dart';

import 'api/room.dart';
import 'api/user.dart';
import 'login.dart';
import 'secure_core_store.dart';
import 'welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  final keyApplicationId = dotenv.env['PARSE_APP_ID']!;
  final keyClientKey = dotenv.env['PARSE_CLIENT_KEY']!;
  final keyParseServerUrl = dotenv.env['PARSE_SERVER_URL']!;
  final adminEmail = dotenv.env['ADMIN_TEST_EMAIL'];

  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    autoSendSessionId: true,
    coreStore: await SecureCoreStore.getInstance(),
  );

  final currentUser = await ParseUser.currentUser() as ParseUser?;
  final isLoggedIn = currentUser?.sessionToken != null;
  // In the future, we should be checking the user's role in the
  // database to decide if they are an admin or not.
  // For now, we are just hard coding an admin email for testing the admin view.
  final isAdmin = currentUser?.emailAddress == adminEmail;

  final result = await StudentRepositoryRemote().getAllStudents();

  switch (result) {
    case Ok<List<User>>():
      final students = result.value;

      for (final student in students) {
        print(student.username);
      }

    case Error<List<User>>():
      print(result.error);
  }

  runApp(MyApp(isLoggedIn: isLoggedIn, isAdmin: isAdmin,));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool isAdmin;

  const MyApp({super.key, required this.isLoggedIn, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'The Furnace',
        theme: FurnaceTheme.build(),
        routerConfig: AppRouter.router(isLoggedIn: isLoggedIn, isAdmin: isAdmin));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: FurnaceBackground(
          pattern: true,
          child: FurnaceContent(
            maxWidth: 440,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const FurnaceBrandHeader(
                  title: 'The Furnace',
                  subtitle: 'Check in',
                  logoWidth: 260,
                ),
                const SizedBox(height: 22),
                FurnacePanel(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FilledButton.icon(
                        onPressed: () => _goToLogin(context),
                        icon: const Icon(Icons.login_rounded),
                        label: const Text('Log in'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => _goToRegister(context),
                        icon: const Icon(Icons.person_add_alt_1_rounded),
                        label: const Text('Create account'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _goToLogin(BuildContext context) async {
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    if (!context.mounted) return;

    if (currentUser == null || currentUser.sessionToken == null) {
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
  }

  void _goToRegister(BuildContext context) {
    Navigator.of(context).push(PageTransition(
        child: const Register(),
        type: PageTransitionType.topToBottom,
        duration: const Duration(milliseconds: 600)));
  }
}
