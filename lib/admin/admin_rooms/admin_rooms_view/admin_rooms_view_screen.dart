import 'package:flutter/material.dart';
import 'package:furnace_app/admin/admin_rooms/admin_rooms_list/admin_rooms_screen.dart';
import 'package:furnace_app/admin/admin_rooms/admin_rooms_list/admin_rooms_screen_viewmodel.dart';
import 'package:furnace_app/admin/admin_rooms/admin_rooms_view/admin_rooms_view_viewmodel.dart';
import 'package:furnace_app/data/repositories/room_repository/room_repository.dart';
import 'package:furnace_app/furnace_ui.dart';

class AdminRoomDetailsScreen extends StatefulWidget {
  final AdminRoomDetailViewmodel viewModel;
  const AdminRoomDetailsScreen({super.key, required this.viewModel});

  @override
  State<AdminRoomDetailsScreen> createState() => _AdminViewRoomState();
}

class _AdminViewRoomState extends State<AdminRoomDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Rooms List")),
        body: FurnaceBackground(
            pattern: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/otter_wip.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                const Text("Under Construction"),
                SizedBox(height: 10),
                ListenableBuilder(
                    listenable: Listenable.merge([widget.viewModel]),
                    builder: (context, _) {
                      return FurnaceContent(
                          maxWidth: 560,
                          child: FurnacePanel(
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [Text('room name')])));
                    })
              ],
            )));
  }
}
