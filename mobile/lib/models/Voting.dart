import 'Account.dart';
import 'Vote.dart';

class Voting {
  final int id;
  final Account account;
  final List<Vote> votes;

  Voting({
    required this.id,
    required this.account,
    required this.votes,
  });

  factory Voting.fromJson(Map<String, dynamic> json) {
    return Voting(
      id: json['id'],
      account: Account.fromJson(json['account'] ?? {}),
      votes: List<Vote>.from((json['votes'] ?? []).map((voteJson) => Vote.fromJson(voteJson))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account': account.toJson(),
      'votes': List<dynamic>.from(votes.map((vote) => vote.toJson())),
    };
  }
}
