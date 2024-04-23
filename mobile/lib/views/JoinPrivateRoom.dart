import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:mobile/viewModels/JoinPrivateRoomViewModel.dart';
import 'Room.dart';
import 'styles.dart';

class JoinPrivateRoomPage extends StatefulWidget {
  const JoinPrivateRoomPage({super.key});

  @override
  JoinPrivateRoomState createState() => JoinPrivateRoomState();
}

class JoinPrivateRoomState extends State<JoinPrivateRoomPage> {
  List<TextEditingController> codeControllers = List.generate(7, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [MyStyles.purple, MyStyles.lightestPurple],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 40),
            Center(
              child: Image.asset(
                'assets/images/mafialogo.png',
                width: MediaQuery.of(context).size.width * 0.40,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Join Room",
                style: TextStyle(color: MyStyles.backgroundColor, fontSize: 35),
              ),
            ),

            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: MyStyles.backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Enter the Room Code to join",
                        style: TextStyle(color: MyStyles.purple, fontSize: 20),
                      ),
                      const SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(7, (index) {
                          return SizedBox(
                            width: 40,
                            child: TextField(
                              controller: codeControllers[index],
                              textAlign: TextAlign.center,
                              style: MyStyles.inputTextStyle,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(color: Colors.black, width: 2),
                                ),
                                counterText: "",
                              ),
                              maxLength: 1,
                              onChanged: (value) {
                                if (value.length == 1 && index < 6) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 8),
                      const SizedBox(height: 27),
                      ElevatedButton(
                        style: MyStyles.buttonStyle,
                        onPressed: () async {
                          String accessCode = codeControllers.map((controller) => controller.text).join();
                          final viewModel = context.read<JoinPrivateRoomViewModel>();
                          await viewModel.joinRoom(
                            accessCode,
                            () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RoomPage()));
                            },
                            (errorMsg) {
                              Fluttertoast.showToast(msg: errorMsg);
                            },
                          );
                        },
                        child: Text(
                          'Join',
                          style: MyStyles.buttonTextStyle,
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