class RoomSettings {
  final bool isPublic;
  final int numberOfPlayers;

  RoomSettings({
    required this.isPublic,
    required this.numberOfPlayers,
  });

  factory RoomSettings.fromJson(Map<String, dynamic> json) {
    return RoomSettings(
      isPublic: json['isPublic'],
      numberOfPlayers: json['numberOfPlayers'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isPublic': isPublic,
      'numberOfPlayers': numberOfPlayers,
    };
  }
}