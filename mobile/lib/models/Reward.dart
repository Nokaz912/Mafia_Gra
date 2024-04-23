import 'Game.dart';
import 'Round.dart';

class Reward {
  final int id;
  final String title;
  final String acquiringMethod;
  final List<Round> rounds;

  Reward({
    required this.id,
    required this.title,
    required this.acquiringMethod,
    required this.rounds,
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'],
      title: json['title'],
      acquiringMethod: json['acquiring_method'],
      rounds: (json['rounds'] as List<dynamic>? ?? []).map((round) => Round.fromJson(round)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'acquiring_method': acquiringMethod,
      'rounds': rounds.map((round) => round.toJson()).toList(),
    };
  }
}
