class Room {
  String? roomId;
  String? roomName;
  String? qrRoomValue;
  String? qrCheckoutValue;

  Room(
      {required this.roomId,
      required this.roomName,
      required this.qrRoomValue,
      required this.qrCheckoutValue});

  factory Room.fromJson(Map<String, dynamic> responseData) {
    return Room(
        roomId: responseData['id'],
        roomName: responseData['roomName'],
        qrRoomValue: responseData['qrRoomValue'],
        qrCheckoutValue: responseData['qrCheckoutValue']);
  }
}
