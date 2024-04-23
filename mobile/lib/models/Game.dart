import 'Account.dart';
import 'Round.dart';

class Game {
  final int id;
  final DateTime createTimestamp;
  final String accessCode;
  final List<Account> accounts;
  final List<Round> rounds;

  Game({
    required this.id,
    required this.createTimestamp,
    required this.accessCode,
    required this.accounts,
    required this.rounds,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      createTimestamp: DateTime.parse(json['createTimestamp']),
      accessCode: json['accessCode'],
      accounts: List<Account>.from((json['accounts'] ?? []).map((accountJson) => Account.fromJson(accountJson))),
      rounds: List<Round>.from((json['rounds'] ?? []).map((roundJson) => Round.fromJson(roundJson))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createTimestamp': createTimestamp.toIso8601String(), // Przykład konwersji daty
      'accessCode': accessCode,
      'accounts': List<dynamic>.from(accounts.map((account) => account.toJson())),
      'rounds': List<dynamic>.from(rounds.map((round) => round.toJson())),
    };
  }
}

