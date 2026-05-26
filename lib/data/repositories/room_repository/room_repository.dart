import 'package:furnace_app/utils/result.dart';

import '../../../api/room.dart';

abstract class RoomRepository {
  Future<Result<List<Room>>> getAllRooms();
  Future<Result<Room?>> getRoomById(String roomId);
  Future<Result<void>> updateRoom(String roomId, String roomName,
      String qrRoomValue, String qrCheckoutValue);
  Future<Result<Room>> createNewRoom(
      String roomName, String qrRoomValue, String qrCheckoutValue);
  Future<Result<void>> deleteRoom(String roomId);
}
