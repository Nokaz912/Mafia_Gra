import 'package:flutter/material.dart';
import 'package:mobile/state/GameState.dart';
import 'package:mobile/state/RoomState.dart';
import 'package:mobile/state/RoundState.dart';
import 'package:mobile/state/VotingState.dart';
import 'package:mobile/viewModels/WinnerRoleViewModel.dart';
import 'package:mobile/views/GameHistory.dart';
import 'package:mobile/viewModels/JoinPrivateRoomViewModel.dart';
import 'package:mobile/viewModels/MenuViewModel.dart';
import 'package:mobile/viewModels/RoomSettingsViewModel.dart';
import 'package:mobile/viewModels/RoomViewModel.dart';
import 'package:mobile/views/VotingResults.dart';
import 'package:provider/provider.dart';
import 'package:mobile/viewModels/LoginViewModel.dart';
import 'package:mobile/viewModels/RegisterViewModel.dart';
import 'package:mobile/views/Login.dart';
import 'package:mobile/views/VotingResults.dart';
import 'package:mobile/viewModels/PublicRoomsViewModel.dart';
import 'package:mobile/views/Register.dart';
import 'package:mobile/viewModels/GameHistoryViewModel.dart';
import 'package:mobile/viewModels/VotingViewModel.dart';

void main() {
  RoomState(); GameState(); RoundState(); VotingState();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RegisterViewModel()),
        ChangeNotifierProvider(create: (context) => LoginViewModel()),
        ChangeNotifierProvider(create: (context) => MenuViewModel()),
        ChangeNotifierProvider(create: (context) => JoinPrivateRoomViewModel()),
        ChangeNotifierProvider(create: (context) => PublicRoomsViewModel()),
        ChangeNotifierProvider(create: (context) => RoomSettingsViewModel()),
        ChangeNotifierProvider(create: (context) => GameHistoryViewModel()),
        ChangeNotifierProvider(create: (context) => RoomViewModel()),
        ChangeNotifierProvider(create: (context) => VotingViewModel()),
        ChangeNotifierProvider(create: (context) => WinnerRoleViewModel())
      ],
      child: const MaterialApp(
        title: 'MAFIA+',
        home: LoginPage(),
      ),
    );
  }
}
