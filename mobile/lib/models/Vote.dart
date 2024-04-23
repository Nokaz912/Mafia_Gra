import 'Account.dart';
import 'Round.dart';
import 'Voting.dart';

class Vote {
  final int id;
  final Voting voting;
  final Account voter;
  final Account voted;

  Vote({
    required this.id,
    required this.voting,
    required this.voter,
    required this.voted,
  });

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      id: json['id'],
      voting: Voting.fromJson(json['voting'] ?? {}),
      voter: Account.fromJson(json['voter'] ?? {}),
      voted: Account.fromJson(json['voted'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'voting': voting.toJson(),
      'voter': voter.toJson(),
      'voted': voted.toJson(),
    };
  }
}
