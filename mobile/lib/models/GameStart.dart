class GameStart {
  final int id;
  final String role;

  GameStart({
    required this.id,
    required this.role
  });

  factory GameStart.fromJson(Map<String, dynamic> json) {
    return GameStart(
      id: json['id'],
      role: json['role']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role
    };
  }
}