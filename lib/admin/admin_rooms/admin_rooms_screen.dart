import 'package:flutter/material.dart';
import 'package:furnace_app/admin/admin_rooms/admin_rooms_screen_viewmodel.dart';
import 'package:furnace_app/furnace_ui.dart';

class AdminViewRoomsScreen extends StatelessWidget {
  final RoomsScreenViewmodel viewModel;
  const AdminViewRoomsScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Admin Dashboard"),
        ),
        body: FurnaceBackground(
            pattern: true,
            child: FurnaceContent(
                maxWidth: 560,
                child: FurnacePanel(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListenableBuilder(
                            listenable: viewModel,
                            builder: (context, child) {
                              int totalRooms = viewModel.roomsSize;
                              return FurnaceBrandHeader(
                                title: "Admin Dashboard",
                                subtitle: 'Viewing $totalRooms Rooms',
                                logoWidth: 220,
                              );
                            }),
                        SizedBox(height: 10),
                        ListenableBuilder(
                            listenable: viewModel.loadRooms,
                            builder: (context, child) {
                              if (viewModel.loadRooms.running) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              if (viewModel.loadRooms.error) {
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text("There was an error fetching rooms."),
                                    ElevatedButton(
                                        onPressed: viewModel.loadRooms.execute,
                                        child: Text("Try Again"))
                                  ],
                                );
                              }
                              return child!;
                            },
                            child: ListView.separated(
                                itemCount: viewModel.rooms.length,
                                separatorBuilder: (context, index) {
                                  return const Divider(height: 1);
                                },
                                itemBuilder: (context, index) {
                                  final room = viewModel.rooms[index];
                                  return ListTile(
                                      leading: const Icon(Icons.qr_code),
                                      title: Text(room.roomName));
                                }))
                      ]),
                ))),
      ),
    );
  }
}
