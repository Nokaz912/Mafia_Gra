import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/models/Room.dart';
import 'RoomSettings.dart';
import 'package:mobile/viewModels/RoomViewModel.dart';
import 'UserRole.dart';
import 'styles.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  RoomPageState createState() => RoomPageState();
}

class RoomPageState extends State<RoomPage> {
  StreamSubscription<void>? _gameStartedSubscription;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies()
  {
    super.didChangeDependencies();
    _gameStartedSubscription ??= context.read<RoomViewModel>().gameStarted.listen((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => UserRolePage()));
      });
    });
  }

  @override
  void dispose() {
    _gameStartedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Room'),
          backgroundColor: MyStyles.appBarColor,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RoomSettingsPage()),
                  );
                },
                child: const Icon(
                  Icons.settings,
                  size: 30
                ),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                MyStyles.purple,
                MyStyles.lightestPurple,
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: MyStyles.purpleLowOpacity,
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/mafialogo.png',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Invite your friends and start the game!',
                        style: TextStyle(fontSize: 28, color: MyStyles.appBarColor, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 80),
                      Text(
                        'Players: ${context.watch<RoomViewModel>().room?.accountUsernames.length}',
                        style: TextStyle(fontSize: 28, color: MyStyles.appBarColor, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      if (context.watch<RoomViewModel>().isHost)
                        ElevatedButton(
                          onPressed: () {
                            int roomId = context.read<RoomViewModel>().room?.id ?? 0;
                            context.read<RoomViewModel>().startGame(
                                roomId,
                                    (){},
                                    (){
                                  if (context.read<RoomViewModel>().messageError.isNotEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(context.watch<RoomViewModel>().messageError),
                                      ),
                                    );
                                  }
                                }
                            );
                          },
                          style: MyStyles.buttonStyle,
                          child: const Text('Start game'),
                        ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          context.read<RoomViewModel>().leaveRoom(
                                  () {
                                Navigator.pop(context);
                              },
                                  () {}
                          );
                        },
                        style: MyStyles.buttonStyle,
                        child: const Text('Exit'),
                      ),
                      const SizedBox(height: 20),
                      if (context.read<RoomViewModel>().room?.roomSettings.isPublic == false)
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Room is PRIVATE 🔐',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      if (context.read<RoomViewModel>().room?.roomSettings.isPublic == true)
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Room is PUBLIC 🔓',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),
                      Text(
                        'AccesCode: ${context.read<RoomViewModel>().room?.accessCode}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        drawer: Drawer(
          surfaceTintColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: MyStyles.purple,
                ),
                child: const Text(
                  'Players in room',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Text(context.watch<RoomViewModel>().room!.hostUsername),
                    const Text(
                      '👑', // Emotikona korony
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
                onTap: () {
                  // Obsługa naciśnięcia na gospodarza
                },
              ),
              ...context.watch<RoomViewModel>().room!.accountUsernames.where((uzytkownik) => uzytkownik != context.watch<RoomViewModel>().room!.hostUsername).map((uzytkownik) => ListTile(
                title: Text(uzytkownik),
                onTap: () {
                  // Obsługa naciśnięcia na innych graczy
                },
              )).toList(),
            ],
          ),
        ),
      ),
    );
  }
}