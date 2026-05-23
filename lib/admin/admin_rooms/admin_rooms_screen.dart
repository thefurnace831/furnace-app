import 'package:flutter/material.dart';
import 'package:furnace_app/admin/admin_rooms/admin_rooms_screen_viewmodel.dart';
import 'package:furnace_app/furnace_ui.dart';

class AdminViewRoomsScreen extends StatelessWidget {
  final RoomsScreenViewmodel viewModel;
  const AdminViewRoomsScreen({super.key, required this.viewModel});

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
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                      ListenableBuilder(
                          listenable: viewModel,
                          builder: (context, child) {
                            final totalRooms = viewModel.roomsSize;
                            final roomNames = viewModel.roomsName;
                            return Column(children: [
                              FurnaceBrandHeader(
                                title: "Admin Dashboard",
                                subtitle: 'Viewing $totalRooms Rooms',
                                logoWidth: 220,
                              ),
                              ListTile(
                                  leading: Icon(Icons.qr_code),
                                  title: Text('test'))
                            ]);
                          }),
                      SizedBox(height: 10),
                    ])))));
  }
}
