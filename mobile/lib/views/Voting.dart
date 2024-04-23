import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile/state/AccountState.dart';
import 'package:mobile/views/VotingResults.dart';
import 'package:mobile/views/styles.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:mobile/viewModels/VotingViewModel.dart';

class VotingPage extends StatefulWidget {
  const VotingPage({super.key});

  @override
  _VotingPageState createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  final AccountState _accountState = AccountState();
  StreamSubscription<void>? _votingFinishedSubscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _votingFinishedSubscription ??= context.read<VotingViewModel>().votingFinished.listen((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 1500),
          child: const VotingResultsPage(),
        ));
      });
    });
  }

  @override
  void dispose() {
    _votingFinishedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 35),
                const Text(
                  'What\'s your gut feeling?\nWho\'s the mafia?',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(
                          color: MyStyles.purpleLowOpacity,
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Consumer<VotingViewModel>(
                      builder: (context, viewModel, child) {
                        return ListView.builder(
                          itemCount: viewModel.players.length,
                          itemBuilder: (context, index) {
                            Player player = viewModel.players[index];
                            if (player.nickname == _accountState.currentAccount!.username) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: PlayerButton(
                                      player: player,
                                      onPressed: () => viewModel.vote(player.nickname)
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        );
                      },
                    ),
                  ),
                ),
              ]
            ),
          ),
        )
      )
    );
  }
}

class PlayerButton extends StatefulWidget {
  final Player player;
  final VoidCallback onPressed;

  PlayerButton({
    required this.player,
    required this.onPressed
  });

  @override
  _PlayerButtonState createState() => _PlayerButtonState();
}

class _PlayerButtonState extends State<PlayerButton> {
  bool _isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GestureDetector(
        onTap: widget.player.canVote &&
            context.watch<VotingViewModel>().votedPlayer == null
            ? () {
          setState(() {
            _isButtonPressed = !_isButtonPressed;
          });

          widget.onPressed();
        }
            : null,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedAlign(
              curve: Curves.fastOutSlowIn,
              duration: Duration(seconds: 1),
              alignment: _isButtonPressed ? Alignment.center : Alignment.centerLeft,
              child: CircleAvatar(
                radius: 30.0,
                backgroundColor: _isButtonPressed ? MyStyles.red : MyStyles.buttonStyle.backgroundColor!.resolve({}),
                child: Icon(Icons.person, size: 35.0, color: Colors.white),
              ),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: _isButtonPressed ? 0.0 : 1.0,
              child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: Text(
                    widget.player.nickname,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}