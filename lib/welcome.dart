import 'dart:async';

import 'package:flutter/material.dart';
import 'package:furnace_app/account.dart';
import 'package:furnace_app/furnace_ui.dart';
import 'package:furnace_app/main.dart';
import 'package:furnace_app/scanner.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'api/room.dart';

class WelcomePage extends StatefulWidget {
  final bool checkedIn;
  final DateTime? checkInTime;
  final Room room;

  const WelcomePage(this.checkedIn, this.checkInTime, this.room, {super.key});

  @override
  State<StatefulWidget> createState() => WelcomePageState();
}

// The page of the app that is displayed a to logged-in user
class WelcomePageState extends State<WelcomePage> {
  Timer? timer;
  String? loggedTime;
  DateTime? logInTime;

  @override
  void initState() {
    super.initState();
    loggedTime = "";

    if (widget.checkInTime == null && widget.checkedIn) {
      // Start timer
      logInTime = DateTime.now();
    } else if (widget.checkInTime != null && widget.checkedIn) {
      // Timer was already started so resume
      logInTime = widget.checkInTime;
    }

    if (widget.checkedIn) {
      loggedTime = getLoggedTime(logInTime!);
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          loggedTime = getLoggedTime(logInTime!);
        });
      });
    } else {
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('The Furnace'),
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: 'Menu',
            ),
          ),
        ),
        drawer: _buildDrawer(context),
        body: FurnaceBackground(
          pattern: true,
          child: FurnaceContent(
            maxWidth: 560,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const FurnaceBrandHeader(
                  title: 'Check-In Dashboard',
                  subtitle: 'The Furnace',
                  logoWidth: 220,
                ),
                const SizedBox(height: 22),
                FurnacePanel(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FurnaceSectionHeader(
                        title: widget.checkedIn
                            ? 'Current session'
                            : 'Ready for your next session',
                        icon: widget.checkedIn
                            ? Icons.local_fire_department_rounded
                            : Icons.qr_code_scanner_rounded,
                      ),
                      const SizedBox(height: 18),
                      _buildSessionSummary(context),
                      const SizedBox(height: 22),
                      FilledButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ScanPage(
                                widget.checkedIn,
                                logInTime,
                                widget.room,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.qr_code_scanner_rounded),
                        label: Text(
                          widget.checkedIn ? 'QR check out' : 'QR check in',
                        ),
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

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  FurnaceColors.coal,
                  FurnaceColors.ember,
                ],
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 70,
                    width: 150,
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomLeft,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Account'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AccountPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSessionSummary(BuildContext context) {
    if (!widget.checkedIn) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: FurnaceColors.teal.withAlpha(18),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: FurnaceColors.teal.withAlpha(55)),
        ),
        child: const Padding(
          padding: EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(
                Icons.verified_outlined,
                color: FurnaceColors.teal,
                size: 28,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'No active room session',
                  style: TextStyle(
                    color: FurnaceColors.ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.room.roomName ?? 'Current room',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 14),
        DecoratedBox(
          decoration: BoxDecoration(
            color: FurnaceColors.ink,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: FurnaceColors.amber.withAlpha(42),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.timer_outlined,
                    color: FurnaceColors.amber,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Time logged',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        loggedTime ?? '0:00:00',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontFeatures: [FontFeature.tabularFigures()],
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void logout() async {
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser != null) {
      await currentUser.logout();
    }

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
          return const MyHomePage(title: 'The Furnace Home Page');
        },
      ),
    );
  }
}

String getLoggedTime(DateTime startTime) {
  Duration totalTime = DateTime.now().difference(startTime);

  String hours = totalTime.inHours.toString().padLeft(0, '2');
  String minutes = totalTime.inMinutes.remainder(60).toString().padLeft(2, '0');
  String seconds = totalTime.inSeconds.remainder(60).toString().padLeft(2, '0');

  return "$hours:$minutes:$seconds";
}
