import 'package:flutter/cupertino.dart';

import '../models/Round.dart';
import '../services/WebSocketClient.dart';

class RoundState extends ChangeNotifier {
  static RoundState? _instance;

  Round? _currentRound;
  Round? get currentRound => _currentRound;

  RoundState._internal();

  factory RoundState() {
    _instance ??= RoundState._internal();
    return _instance!;
  }

  void setRound(Round? round) {
    _currentRound = round;
    notifyListeners();
  }
}