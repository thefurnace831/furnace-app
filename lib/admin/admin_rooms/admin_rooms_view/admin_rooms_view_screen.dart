import 'package:flutter/material.dart';
import 'package:furnace_app/admin/admin_rooms/admin_rooms_view/admin_rooms_view_viewmodel.dart';
import 'package:furnace_app/furnace_ui.dart';
import 'package:furnace_app/widgets/qr_buttons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:furnace_app/widgets/room_status_widget.dart';

class AdminRoomDetailsScreen extends StatefulWidget {
  final AdminRoomDetailViewmodel viewModel;
  const AdminRoomDetailsScreen({super.key, required this.viewModel});

  @override
  State<AdminRoomDetailsScreen> createState() => _AdminViewRoomState();
}

//edit button -> push to edit page -> pop to view page with new edit
class _AdminViewRoomState extends State<AdminRoomDetailsScreen> {
  bool _isEditing = false;

  // Text controllers for input
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              //Show either View or Edit status
              Center(
                child: RoomStatusWidget(
                    isEditing: _isEditing,
                    icon: _isEditing ? Icons.edit : Icons.visibility),
              ),
              ListenableBuilder(
                  listenable: widget.viewModel.loadRoomById,
                  builder: (context, _) {
                    if (widget.viewModel.loadRoomById.running) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (widget.viewModel.loadRoomById.error) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("There was an error fetching room."),
                          ElevatedButton(
                              onPressed: () {
                                widget.viewModel.loadRoomById
                                    .execute(widget.viewModel.roomId);
                              },
                              child: Text("Try Again"))
                        ],
                      );
                    }
                    return FurnaceContent(
                        maxWidth: 560,
                        child: FurnacePanel(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // Checkin
                                children: [
                              // Room name
                              Text('Name',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(widget.viewModel.room!.roomName),
                              // Divider
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: Divider(color: Colors.grey),
                              ),
                              // Checkin
                              Text("Check-In"),
                              // QR Code
                              Center(
                                child: QrImageView(
                                    data: widget.viewModel.room!.qrRoomValue,
                                    version: QrVersions.auto,
                                    size: 200.0),
                              ),
                              Center(
                                  child: QrButtons(
                                      qrRoomValue:
                                          widget.viewModel.room!.qrRoomValue,
                                      roomName:
                                          widget.viewModel.room!.roomName)),
                              // Divider
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 22.0),
                                child: Divider(color: Colors.grey),
                              ),
                              // Checkout
                              Text("Check-Out"),
                              Center(
                                  child: // Checking Type
                                      // QR Code
                                      QrImageView(
                                          data: widget
                                              .viewModel.room!.qrRoomValue,
                                          version: QrVersions.auto,
                                          size: 200.0)),
                            ])));
                  })
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _isEditing = !_isEditing;
          });
        },
        label: Text(_isEditing ? 'Save' : 'Edit'),
        icon: Icon(_isEditing ? Icons.save : Icons.edit),
      ),
    );
  }
}
