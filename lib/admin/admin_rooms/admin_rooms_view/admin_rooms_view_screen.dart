import 'package:flutter/material.dart';
import 'package:furnace_app/admin/admin_rooms/admin_rooms_list/admin_rooms_screen_viewmodel.dart';
import 'package:furnace_app/admin/admin_rooms/admin_rooms_view/admin_rooms_view_viewmodel.dart';
import 'package:furnace_app/data/repositories/room_repository/room_repository.dart';

class AdminRoomDetailsScreen extends StatelessWidget {
  final AdminRoomDetailViewmodel viewModel;
  const AdminRoomDetailsScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.asset(
        'assets/images/otter_wip.png',
        width: 200,
        height: 200,
        fit: BoxFit.contain,
      ),
      const SizedBox(height: 10),
      const Text("Under Construction"),
    ])));
  }
}
