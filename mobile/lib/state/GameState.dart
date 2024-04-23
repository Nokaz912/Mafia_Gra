import 'package:flutter/cupertino.dart';
import 'package:mobile/services/WebSocketClient.dart';

import '../models/GameStart.dart';
import '../models/Round.dart';

class GameState extends ChangeNotifier {
  static GameState? _instance;

  GameStart? _currentGame;
  GameStart? get currentGame => _currentGame;

  GameState._internal();

  factory GameState() {
    _instance ??= GameState._internal();
    return _instance!;
  }

  void setGame(GameStart? game) {
    _currentGame = game;
    notifyListeners();
  }
}