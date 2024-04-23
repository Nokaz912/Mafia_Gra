import 'package:flutter/material.dart';
import 'package:mobile/Views/styles.dart';
import 'package:provider/provider.dart'; 
import 'package:mobile/viewModels/GameHistoryViewModel.dart';
 
class GameHistoryPage extends StatefulWidget {
  const GameHistoryPage({Key? key}) : super(key: key);

  @override
  _GameHistoryPageState createState() => _GameHistoryPageState();
}

class _GameHistoryPageState extends State<GameHistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<GameHistoryViewModel>().fetchGameHistory();
  }

  @override
  Widget build(BuildContext context) {
    //List<Game> gameHistory = context.watch<GameHistoryViewModel>().gameHistory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game History'),
        flexibleSpace: Container(
          decoration:  BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                MyStyles.appBarColor,
                MyStyles.lightestPurple,
                // Color(0xFF8E44AD),
                // Color(0xFFc8a2d8),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: ListView(
          children: const [
            SizedBox(height: 25.0),
            Text(
              'Game History',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 25.0),
            // for (Game game in gameHistory)
            //   ListTile(
            //     title: Text('Game - ${game.date.toString()}'),
            //     subtitle: Text(game.won ? 'Won' : 'Lost'),
            //   ),
          ],
        ),
      ),
    );
  }
}
