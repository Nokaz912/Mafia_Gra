import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/Room.dart';
import 'package:mobile/services/network/RoomService.dart';

class PublicRoomsViewModel with ChangeNotifier {
  final RoomService _roomService = RoomService();
  List<Room> _publicRooms = [];

  List<Room> get publicRooms => _publicRooms;

  Future<void> fetchPublicRooms() async {
    try {
      List<Room> rooms = await _roomService.getPublicRooms();
      _publicRooms = rooms;
      notifyListeners();
    } catch (e) {
      print('Error while fetching room list: $e');
    }
  }

  Future<void> refreshPublicRooms() async {
    await fetchPublicRooms();
  }

  void pressed(BuildContext context, Room room) {
    /* Przekierowanie do pokoju
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Room(room: room),
      ),
    );*/
  }
}
