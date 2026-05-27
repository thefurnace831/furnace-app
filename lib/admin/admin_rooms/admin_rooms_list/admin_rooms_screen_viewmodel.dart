// Connect to Room table/repository
import 'package:flutter/material.dart';
import 'package:furnace_app/api/room.dart';
import 'package:furnace_app/data/repositories/room_repository/room_repository.dart';
import 'package:furnace_app/utils/command.dart';
import 'package:furnace_app/utils/result.dart';
import 'package:logging/logging.dart';

class RoomsScreenViewmodel extends ChangeNotifier {
  RoomsScreenViewmodel({required RoomRepository roomrepository})
      : _roomRepository = roomrepository {
    loadRooms = Command0(_load)..execute();
  }

  final RoomRepository _roomRepository;
  final _log = Logger('RoomsScreenViewmodel');
  List<Room> _rooms = [];
  List<Room> get rooms => _rooms;

  late Command0 loadRooms;

// Load all rooms
  Future<Result> _load() async {
    try {
      final result = await _roomRepository.getAllRooms();
      switch (result) {
        case Ok<List<Room>>():
          _rooms = result.value;
          _log.fine('loaded Rooms $_rooms');
        case Error<List<Room>>():
          _log.warning('Failed to load rooms', result.error);
      }
      return result;
    } finally {
      notifyListeners();
    }
  }
}
