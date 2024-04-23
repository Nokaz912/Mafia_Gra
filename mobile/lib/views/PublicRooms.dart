import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/models/Room.dart';
import 'package:mobile/viewModels/PublicRoomsViewModel.dart';
import 'styles.dart';

class PublicRoomsPage extends StatefulWidget {
  const PublicRoomsPage({super.key});

  @override
  PublicRoomsPageState createState() => PublicRoomsPageState();
}

class PublicRoomsPageState extends State<PublicRoomsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PublicRoomsViewModel>().fetchPublicRooms();
  }

  void _refreshRooms() {
    context.read<PublicRoomsViewModel>().fetchPublicRooms();
  }

  @override
  Widget build(BuildContext context) {
    List<Room> publicRooms = context.watch<PublicRoomsViewModel>().publicRooms;

    return Scaffold(
      backgroundColor: MyStyles.backgroundColor,
      appBar: AppBar(
        backgroundColor: MyStyles.appBarColor,
        automaticallyImplyLeading: false,
        title:  Text('Public Rooms'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                MyStyles.appBarColor,
                MyStyles.lightestPurple,
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 25.0),

            ElevatedButton(
              onPressed: _refreshRooms,
              style:MyStyles.buttonStyle,
              child: const Text('Refresh'),
            ),
            const SizedBox(height: 25.0),
            const Text(
              'Choose a Public Room',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
            const SizedBox(height: 25.0),
            for (Room room in publicRooms)
              ElevatedButton(
                onPressed: () {
                  //context.read<PublicRoomsViewModel>().pressed(room);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyStyles.purple,
                  minimumSize: const Size(double.infinity, 60),
                  textStyle: const TextStyle(fontSize: 32.0),
                  shape:
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    )
                ),
                child: Text(room.hostUsername.toString()),
              ),
          ],
        ),
      ),
    );
  }
}
