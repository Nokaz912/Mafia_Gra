import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/state/RoomState.dart';
import 'package:mobile/state/RoundState.dart';
import '../models/Room.dart';
import '../models/VotingSummary.dart';
import '../services/network/GameService.dart';
import '../state/VotingState.dart';

class VotingViewModel extends ChangeNotifier {
  final RoomState _roomState = RoomState();
  final RoundState _roundState = RoundState();
  final VotingState _votingState = VotingState();
  final GameService _gameService = GameService();
  VotingSummary? _votingSummary;
  VotingSummary? get votingSummary => _votingSummary;
  List<Player> _players = [];
  List<Player> get players => _players;
  Player? _votedPlayer;
  Player? get votedPlayer => _votedPlayer;
  late Map<String, String> _roles; // Change key type to String
  int? _votingId=0;
  Room? _room;
  Room? get room => _room;
  final _votingFinished = StreamController<void>.broadcast();
  Stream<void> get votingFinished => _votingFinished.stream;

  VotingViewModel() {
    _roomState.addListener(_updatePlayers); _updatePlayers();
    _roundState.addListener(_updateVoting); _updateVoting();
    _votingState.addListener(_updateVotingSummary);
  }

  void _updatePlayers() {
    if(_roomState.currentRoom == null) return;
    _room = _roomState.currentRoom!;
    _players = _room!.accountUsernames.map(
      (username) => Player(nickname: username, canVote: true)
    ).toList();
    notifyListeners();
  }

  void _updateVoting() {
    if(_roundState.currentRound == null) return;
    _votingId = _roundState.currentRound!.votingCityId;
    notifyListeners();
  }

  void _updateVotingSummary() {
    if(_votingState.currentVotingSummary == null) return;
    _votingSummary = _votingState.currentVotingSummary!;
    _votedPlayer = null;
    _votingFinished.add(null);
    notifyListeners();
  }

  void vote(String playerNickname) async {
    Player? player = _players.firstWhere((p) => p.nickname == playerNickname, orElse: () => Player(nickname: '', canVote: false));
    _votedPlayer = player;

    if (player.canVote) {
      print('Głos oddany na gracza: $playerNickname');
      await _gameService.addVote(_votingId!, playerNickname);
      notifyListeners();
    } else {
      print('Nie można głosować na $playerNickname');
    }

    notifyListeners();
  }
}

class Player {
  final String nickname;
  final bool canVote;

  Player({required this.nickname, required this.canVote});
}