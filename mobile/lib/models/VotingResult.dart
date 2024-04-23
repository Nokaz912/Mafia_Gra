class VotingResult {
  final String username;
  final int voteCount;

  VotingResult({
    required this.username,
    required this.voteCount
  });

  factory VotingResult.fromJson(Map<String, dynamic> json) {
    return VotingResult(
      username: json['username'],
      voteCount: json['voteCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'voteCount': voteCount
    };
  }
}
