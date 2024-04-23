import 'package:flutter/material.dart';
import 'package:mobile/services/WebSocketClient.dart';
import 'package:mobile/services/network/AccountService.dart';
import 'package:mobile/services/network/RoomService.dart';
import 'package:mobile/models/Room.dart';
import 'package:mobile/state/AccountState.dart';
import 'package:mobile/state/RoomState.dart';

class MenuViewModel extends ChangeNotifier {
  final AccountState _accountState = AccountState();
  final RoomState _roomState = RoomState();

  final AccountService _accountService = AccountService();
  final RoomService _roomService = RoomService();

  final WebSocketClient _webSocketClient = WebSocketClient();

  late String _username;
  String get username => _username;

  MenuViewModel() {
    _accountState.addListener(_updateUsername); _updateUsername();
  }

  void _updateUsername() {
    if(_accountState.currentAccount == null) return;
    _username = _accountState.currentAccount!.username;
    notifyListeners();
  }

  Future<void> createRoom(void Function() onSuccess, void Function() onError) async {
    try {
      Room room = await _roomService.createRoom();
      await _webSocketClient.connect(room.id);
      _roomState.setRoom(room);
      onSuccess.call();
    } catch (e) {
      print("Error creating room: $e");
      onError.call();
    }
  }

  Future<void> logout(void Function() onSuccess, void Function() onError) async {
    try {
      _accountService.logout();
      _accountState.setAccount(null);
      onSuccess.call();
    } on Exception catch (e) {
      onError.call();
    }
  }
}
