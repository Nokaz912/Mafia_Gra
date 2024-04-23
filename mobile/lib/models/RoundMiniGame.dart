import 'Account.dart';
import 'Minigame.dart';
import 'Round.dart';

class RoundMiniGame {
  final Round round;
  final Minigame minigame;
  final Account account;

  RoundMiniGame({
    required this.round,
    required this.minigame,
    required this.account,
  });

  factory RoundMiniGame.fromJson(Map<String, dynamic> json) {
    return RoundMiniGame(
      round: Round.fromJson(json['round']),
      minigame: Minigame.fromJson(json['minigame']),
      account: Account.fromJson(json['account']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'round': round.toJson(),
      'minigame': minigame.toJson(),
      'account': account.toJson(),
    };
  }
}
