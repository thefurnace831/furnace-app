import 'package:flutter/material.dart';

class AdminRoomDetailsScreen extends StatelessWidget {
  const AdminRoomDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: Scaffold(
            appBar: AppBar(title: const Text("The Furnace")),
            body: Center(
              child: Image.asset(
                'assets/images/otter_wip.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            )));
  }
}
