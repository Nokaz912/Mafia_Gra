import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/GameResult.dart';

class GameHistoryViewModel extends ChangeNotifier {
 // final GameService _gameService = GameService();
  List<GameResult> _gameHistory = [];

  List<GameResult> get gameHistory => _gameHistory;

  Future<void> fetchGameHistory() async {
    try{
      //zakomentowane bo serwsue ni ma
       // List <Game> games = await _gameHistory.getGames();
       // jakiea prkladowe nizej
      _gameHistory = [
        GameResult(date: DateTime(2024, 1, 1), won: true),
        GameResult(date: DateTime(2024, 1, 5), won: false),
      ];
        notifyListeners();
      } catch (e) {
        print('Error: $e');
      }
  }
}
