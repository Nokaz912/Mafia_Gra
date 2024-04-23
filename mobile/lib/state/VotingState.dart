import 'package:flutter/cupertino.dart';
import 'package:mobile/models/VotingSummary.dart';

import '../models/Round.dart';
import '../services/WebSocketClient.dart';

class VotingState extends ChangeNotifier {
  static VotingState? _instance;

  VotingSummary? _currentVotingSummary;
  VotingSummary? get currentVotingSummary => _currentVotingSummary;

  VotingState._internal();

  factory VotingState() {
    _instance ??= VotingState._internal();
    return _instance!;
  }

  void setVotingSummary(VotingSummary? votingSummary) {
    _currentVotingSummary = votingSummary;
    notifyListeners();
  }
}