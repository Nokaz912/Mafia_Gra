import 'RoomSettings.dart';

class Room {
  final int id;
  final List<String> accountUsernames;
  final String hostUsername;
  final String accessCode;
  final RoomSettings roomSettings;

  Room({
    required this.id,
    required this.accountUsernames,
    required this.hostUsername,
    required this.accessCode,
    required this.roomSettings
  });


  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      accountUsernames: List<String>.from(json['accountUsernames']),
      hostUsername: json['hostUsername'],
      accessCode: json['accessCode'],
      roomSettings: RoomSettings.fromJson(json['roomSettings'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountUsernames': accountUsernames,
      'hostUsername': hostUsername,
      'accessCode': accessCode,
      'roomSettings': roomSettings.toJson()
    };
  }
}
