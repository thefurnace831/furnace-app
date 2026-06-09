import 'package:furnace_app/api/room.dart';
import 'package:furnace_app/data/repositories/room_repository/room_repository.dart';
import 'package:furnace_app/utils/result.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class RoomRepositoryRemote extends RoomRepository {
  @override
  Future<Result<Room>> createNewRoom(
      String roomName, String qrRoomValue, String qrCheckoutValue) async {
    final roomObject = ParseObject('Room')
      ..set('roomName', roomName)
      ..set('qrRoomValue', qrRoomValue)
      ..set('qrCheckoutValue', qrCheckoutValue);

    // Persist new object
    final ParseResponse response = await roomObject.save();

    if (response.success) {
      return Result.ok(Room.fromParseObject(roomObject));
    }
    return Result.error(
        Exception(response.error?.message ?? 'Failed to create new room.'));
  }

  @override
  Future<Result<List<Room>>> getAllRooms() async {
    final QueryBuilder<ParseObject> query = QueryBuilder(ParseObject('Room'));
    final response = await query.query();

    if (response.success) {
      // If no rooms are returned, return null
      final List<ParseObject> roomsObject =
          (response.results ?? []).cast<ParseObject>();
      return Result.ok(roomsObject.map(Room.fromParseObject).toList());
    }
    return Result.error(
      Exception(response.error?.message ?? 'Failed to load rooms.'),
    );
  }

  @override
  Future<Result<Room>> getRoomById(String roomId) async {
    // Find room by id
    final QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject('Room'))
          ..whereEqualTo('objectId', roomId);
    // Query
    final response = await query.query();

    if (response.success) {
      final ParseObject roomObject = response.results?.first as ParseObject;
      return Result.ok(Room.fromParseObject(roomObject));
    }
    return Result.error(
      Exception(response.error?.message ?? 'Failed to find room by id.'),
    );
  }

  @override
  Future<Result<void>> updateRoom(String roomId, String roomName,
      String qrRoomValue, String qrCheckoutValue) async {
    // Find room by id
    final QueryBuilder<ParseObject> query = QueryBuilder(ParseObject('Room'))
      ..whereEqualTo('objectId', roomId);

    // Query
    final response = await query.query();

    if (response.success) {
      // Update room
      final ParseObject roomObject = response.results?.first as ParseObject;
      roomObject.set('roomName', roomName);
      roomObject.set('qrRoomValue', qrRoomValue);
      roomObject.set('qrCheckOutValue', qrCheckoutValue);

      await roomObject.save();
      return Result.ok(null);
    }
    return Result.error(Exception(
        response.error?.message ?? 'Failed to find and update room by id'));
  }

  @override
  Future<Result<void>> deleteRoom(String roomId) async {
    // Find room by id
    final QueryBuilder<ParseObject> query = QueryBuilder(ParseObject('Room'))
      ..whereEqualTo('objectId', roomId);
    // Query
    final response = await query.query();

    if (response.success) {
      final ParseObject roomObject = response.results?.first as ParseObject;
      roomObject.delete();
      return Result.ok(null);
    }
    return Result.error(Exception(
        response.error?.message ?? 'Failed to find and delete room by id'));
  }
}
