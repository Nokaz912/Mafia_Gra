import 'VotingViewModel.dart';
import 'package:flutter/material.dart';

class VotingResultsViewModel extends ChangeNotifier {

  late List<Player> _players;
  VotingResultsViewModel()
  {

  _players = [
  Player(nickname: 'Gracz 1', canVote: true),
  Player(nickname: 'Gracz 2', canVote: true),
  Player(nickname: 'Gracz 3', canVote: true),
  ];

}

List<Player> getPlayers() {
  return _players;
}

}