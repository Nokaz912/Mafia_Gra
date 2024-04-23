import 'package:flutter/foundation.dart';
import 'package:mobile/models/RoomSettings.dart';
import 'package:mobile/services/network/RoomService.dart';

class RoomSettingsViewModel with ChangeNotifier {
  final RoomService _roomService = RoomService();

  bool _loading = false;
  bool get loading => _loading;

  String _messageError = "";
  String get messageError => _messageError;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> saveGameSettings(RoomSettings roomSettings) async {
    try {
      setLoading(true);
      await _roomService.modifyRoomProperties(roomSettings);
    } catch (error) {
      _messageError = "Error saving game settings: $error";
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }
}
