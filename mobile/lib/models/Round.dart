class Round {
  final int id;
  final int votingCityId;

  Round({
    required this.id,
    required this.votingCityId
  });

  factory Round.fromJson(Map<String, dynamic> json) {
    return Round(
      id: json['id'],
      votingCityId: json['votingId']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'votingId': votingCityId
    };
  }
}

