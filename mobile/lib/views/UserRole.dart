import 'package:flutter/material.dart';
import 'package:mobile/Views/styles.dart';
import 'package:mobile/views/Voting.dart';
import 'package:mobile/views/VotingResults.dart';
import 'package:provider/provider.dart';
import 'package:mobile/viewModels/WinnerRoleViewModel.dart';
import 'package:mobile/models/Room.dart';

class UserRolePage extends StatefulWidget {
  @override
  _UserRolePageState createState() => _UserRolePageState();
}

class _UserRolePageState extends State<UserRolePage> {
  bool buttonPressed = false;

  @override
  void initState() {
    super.initState();
    // Start a timer to automatically navigate to the voting page after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      if (!buttonPressed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VotingPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // String role = 'mafia';
    // String role = 'citizen';
    String role = context.watch<WinnerRoleViewModel>().userRole;
    Color textColor = role == 'mafia' ? Colors.red : Colors.green;

    return Scaffold(
      backgroundColor: MyStyles.backgroundColor,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [MyStyles.purple, MyStyles.lightestPurple],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: const EdgeInsets.all(55.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 35.0),
                        child: Text(
                          'Your role is: $role',
                          style: TextStyle(color: textColor, fontSize: 36),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 65.0),
                        child: role == 'mafia'
                            ? Image.asset(
                          'assets/images/mafia.png',
                          width: 90,
                        )
                            : Image.asset(
                          'assets/images/citizen.png',
                          width: 110,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
