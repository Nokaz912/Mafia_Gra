import 'Account.dart';
import 'Round.dart';

class GameResult {
  final DateTime date;
  final bool won; // true - wygrana, false - przegrana

  GameResult({required this.date, required this.won});


  factory GameResult.fromJson(Map<String, dynamic> json) {
    return GameResult(
      date: DateTime.parse(json['date']),
      won: json['won'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'won': won,
    };
  }
}
