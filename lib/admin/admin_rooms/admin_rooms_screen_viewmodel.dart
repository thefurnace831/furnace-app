// Connect to Room table/repository
import 'package:flutter/material.dart';
import 'package:furnace_app/api/room.dart';
import 'package:furnace_app/data/repositories/room_repository/room_repository.dart';
import 'package:furnace_app/utils/command.dart';
import 'package:furnace_app/utils/result.dart';
import 'package:logging/logging.dart';

class RoomsScreenViewmodel extends ChangeNotifier {
  // Repository
  RoomsScreenViewmodel({required RoomRepository roomrepository})
      : _roomRepository = roomrepository {
    loadRooms = Command0(_load)..execute();
  }

  final RoomRepository _roomRepository;
  final _log = Logger('RoomsScreenViewmodel');
  List<Room> _rooms = [];
  List<Room> get rooms => _rooms;
  int get roomsSize => _rooms.length;

  late Command0 loadRooms;

// Load rooms
  Future<Result> _load() async {
    try {
      final result = await _roomRepository.getAllRooms();
      print('in load');
      switch (result) {
        case Ok<List<Room>>():
          print('in result value');
          _rooms = result.value;
          print(_rooms);
          _log.fine('loaded Rooms $_rooms');
        case Error<List<Room>>():
          print('in error');
          _log.warning('Failed to load rooms', result.error);
        // return result;
      }
      return result;
    } finally {
      notifyListeners();
    }
  }
}
