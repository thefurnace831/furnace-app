import 'package:flutter/material.dart';
import 'package:furnace_app/api/room.dart';
import 'package:furnace_app/data/repositories/room_repository/room_repository.dart';
import 'package:furnace_app/utils/command.dart';
import 'package:furnace_app/utils/result.dart';

class AdminRoomDetailViewmodel extends ChangeNotifier {
  final String roomId;

  AdminRoomDetailViewmodel(
      {required this.roomId, required RoomRepository roomRepository})
      : _roomRepository = roomRepository {
    loadRoomById = Command1<Room?, String>(_getRoomById)..execute(roomId);
  }

  final RoomRepository _roomRepository;
  late Command1<Room?, String> loadRoomById;

  Room? _room;
  Room? get room => _room;
  bool _saving = false;
  bool _editing = false;

  Future<Result<Room?>> _getRoomById(String roomId) async {
    try {
      final result = await _roomRepository.getRoomById(roomId);

      switch (result) {
        case Ok<Room?>():
          _room = result.value;
        case Error<Room?>():
      }
      return result;
    } finally {
      notifyListeners();
    }
  }
}
