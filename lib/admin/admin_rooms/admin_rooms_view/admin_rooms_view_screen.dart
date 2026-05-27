import 'package:flutter/material.dart';
import 'package:furnace_app/admin/admin_rooms/admin_rooms_view/admin_rooms_view_viewmodel.dart';
import 'package:furnace_app/data/repositories/room_repository/room_repository.dart';
import 'package:furnace_app/furnace_ui.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AdminRoomDetailsScreen extends StatefulWidget {
  final AdminRoomDetailViewmodel viewModel;
  const AdminRoomDetailsScreen({super.key, required this.viewModel});

  @override
  State<AdminRoomDetailsScreen> createState() => _AdminViewRoomState();
}

//edit button -> push to edit page -> pop to view page with new edit
class _AdminViewRoomState extends State<AdminRoomDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      final String text = _nameController.text.toLowerCase();
      _nameController.value = _nameController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

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
                const SizedBox(height: 5),
                const Text("Under Construction"),
                SizedBox(height: 10),
                ListenableBuilder(
                    listenable: widget.viewModel,
                    builder: (context, _) {
                      return FurnaceContent(
                          maxWidth: 560,
                          child: FurnacePanel(
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  // Checkin
                                  children: [
                                // Room name
                                Text(widget.viewModel.roomId),
                                // Checking Type
                                Text("Check-in"),
                                // QR Code
                                QrImageView(
                                    data: widget.viewModel.roomId,
                                    version: QrVersions.auto,
                                    size: 200.0),
                                // Checkout
                              ])));
                    })
              ],
            )));
  }
}
