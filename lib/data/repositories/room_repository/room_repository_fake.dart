import 'package:furnace_app/api/room.dart';
import 'package:furnace_app/data/repositories/room_repository/room_repository.dart';
import 'package:furnace_app/utils/result.dart';
import 'package:collection/collection.dart';

// For demo purposes
class RoomRepositoryFake extends RoomRepository {
  final List<Room> _rooms = [
    Room(
        roomId: '1',
        roomName: 'Test Room',
        qrRoomValue: 'a',
        qrCheckoutValue: 'b'),
    Room(
        roomId: '2',
        roomName: 'Break Room',
        qrRoomValue: 'c',
        qrCheckoutValue: 'd')
  ];

  bool isSuccessful = true;

  @override
  Future<Result<Room>> createNewRoom(
      String roomName, String qrRoomValue, String qrCheckoutValue) async {
    int count = _rooms.length + 1;
    Room newRoom = Room(
        roomId: (count).toString(),
        roomName: roomName,
        qrRoomValue: qrRoomValue,
        qrCheckoutValue: qrCheckoutValue);
    _rooms.add(newRoom);
    return Result.ok(newRoom);
  }

  @override
  Future<Result<List<Room>>> getAllRooms() async {
    if (isSuccessful) {
      return Result.ok(_rooms);
    }

    return Result.error(
      Exception('Failed to load rooms'),
    );
  }

  @override
  Future<Result<Room?>> getRoomById(String roomId) async {
    if (isSuccessful) {
      Room? room = _rooms.firstWhereOrNull((room) => room.roomId == roomId);
      return Result.ok(room);
    }
    return Result.error(
      Exception('Failed to load rooms'),
    );
  }

  @override
  Future<Result<void>> updateRoom(String roomId, String roomName,
      String qrRoomValue, String qrCheckoutValue) async {
    int index = _rooms.indexWhere((room) => room.roomId == roomId);
    _rooms.elementAt(index).roomName = roomName;
    _rooms.elementAt(index).qrRoomValue = qrRoomValue;
    _rooms.elementAt(index).qrCheckoutValue =
        qrCheckoutValue; //This does not change
    return Result.ok(null);
  }

  @override
  Future<Result<void>> deleteRoom(String roomId) async {
    int index = _rooms.indexWhere((room) => room.roomId == roomId);
    _rooms.removeAt(index);
    return Result.ok(null);
  }
}
