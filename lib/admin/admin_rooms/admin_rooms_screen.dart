import 'package:flutter/material.dart';
import 'package:furnace_app/furnace_ui.dart';
import 'package:go_router/go_router.dart';

import 'package:furnace_app/admin/admin_rooms/admin_rooms_screen_viewmodel.dart';

// push to add, pop after new room is saved, update previous page
class AdminViewRoomsScreen extends StatefulWidget {
  final RoomsScreenViewmodel viewModel;
  const AdminViewRoomsScreen({super.key, required this.viewModel});

  @override
  State<AdminViewRoomsScreen> createState() => _AdminRoomsState();
}

class _AdminRoomsState extends State<AdminViewRoomsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),
      body: FurnaceBackground(
          pattern: true,
          child: FurnaceContent(
              maxWidth: 560,
              child: FurnacePanel(
                child: ListenableBuilder(
                  //Handle any changes to rooms/viewmodel and reflect to ui
                  listenable: Listenable.merge(
                      [widget.viewModel, widget.viewModel.loadRooms]),
                  builder: (context, _) {
                    int totalRooms = widget.viewModel.rooms.length;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FurnaceBrandHeader(
                          title: "Admin Dashboard",
                          subtitle: 'Viewing $totalRooms Rooms',
                          logoWidth: 220,
                        ),
                        const SizedBox(height: 10),
                        // Listen for Commands
                        ListenableBuilder(
                          //Maybe still redundant
                          listenable: Listenable.merge(
                              [widget.viewModel, widget.viewModel.loadRooms]),
                          builder: (context, child) {
                            if (widget.viewModel.loadRooms.running) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (widget.viewModel.loadRooms.error) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text("There was an error fetching rooms."),
                                  ElevatedButton(
                                      onPressed:
                                          widget.viewModel.loadRooms.execute,
                                      child: Text("Try Again"))
                                ],
                              );
                            }

                            return SizedBox(
                              height: 400,
                              child: widget.viewModel.rooms.isEmpty
                                  ? const Center(
                                      child: Text('No rooms found.'),
                                    )
                                  : ListView.separated(
                                      itemCount: widget.viewModel.rooms.length,
                                      separatorBuilder: (context, index) {
                                        return const Divider(height: 1);
                                      },
                                      itemBuilder: (context, index) {
                                        final room =
                                            widget.viewModel.rooms[index];
                                        return ListTile(
                                          leading: const Icon(Icons.qr_code),
                                          title: Text(room.roomName),
                                          onTap: () {
                                            context.pushNamed(
                                                'adminRoomDetails',
                                                pathParameters: {
                                                  'roomId': room.roomId
                                                });
                                          },
                                        );
                                      },
                                    ),
                            );
                          },
                        )
                      ],
                    );
                  },
                ),
              ))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
