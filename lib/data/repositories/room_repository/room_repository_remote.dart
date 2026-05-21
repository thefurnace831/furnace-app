import 'package:furnace_app/api/room.dart';
import 'package:furnace_app/data/repositories/room_repository/room_repository.dart';
import 'package:furnace_app/utils/result.dart';

class RoomRepositoryRemote extends RoomRepository {
  @override
  Future<Result<void>> createNewRoom(String roomName, String qrRoomValue, String qrCheckoutValue) {
    // TODO: implement createNewRoom
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Room>>> getAllRooms() {
    // TODO: implement getAllRooms
    throw UnimplementedError();
  }

  @override
  Future<Result<Room>> getRoomById(String roomId) {
    // TODO: implement getRoomById
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> updateRoom(String roomId, String roomName, String qrRoomValue, String qrCheckoutValue) {
    // TODO: implement updateRoom
    throw UnimplementedError();
  }

}