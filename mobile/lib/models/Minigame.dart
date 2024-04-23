import 'RoundMiniGame.dart';

class Minigame {
  final int id;
  final String title;
  final List<RoundMiniGame> roundMiniGames;

  Minigame({
    required this.id,
    required this.title,
    required this.roundMiniGames,
  });

  factory Minigame.fromJson(Map<String, dynamic> json) {
    return Minigame(
      id: json['id'],
      title: json['title'],
      roundMiniGames: (json['roundMiniGames'] as List<dynamic>? ?? []).map((roundMiniGame) => RoundMiniGame.fromJson(roundMiniGame)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'roundMiniGames': roundMiniGames.map((roundMiniGame) => roundMiniGame.toJson()).toList(),
    };
  }
}
