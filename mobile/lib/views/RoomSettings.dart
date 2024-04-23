import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:provider/provider.dart';

import 'package:mobile/models/RoomSettings.dart';
import 'package:mobile/viewModels/RoomSettingsViewModel.dart';
import 'styles.dart';

class _CustomThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size.fromRadius(20);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;
    final Paint paint = Paint()
      ..color = sliderTheme.thumbColor!
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 20, paint);

    labelPainter.paint(
      canvas,
      Offset(center.dx - (labelPainter.width / 2),
          center.dy - (labelPainter.height / 2)),
    );
  }
}

class RoomSettingsPage extends StatefulWidget {
  @override
  _RoomSettingsPageState createState() => _RoomSettingsPageState();
}

class _RoomSettingsPageState extends State<RoomSettingsPage> {
  bool _isPublic = false; // Default to private room
  int _numberOfPlayers = 6; // Default number of players

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [MyStyles.appBarColor, MyStyles.lightestPurple])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Room settings",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: MyStyles.backgroundColor,),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 45,
                        ),
                        const Text(
                          'Max players:',
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SliderTheme(
                          data: SliderThemeData(
                            thumbColor: MyStyles.purple,
                            activeTrackColor: MyStyles.lightPurple,
                            activeTickMarkColor: MyStyles.lightPurple,
                            inactiveTrackColor: MyStyles.lightestPurple,
                            inactiveTickMarkColor: MyStyles.lightestPurple,
                            thumbShape: _CustomThumbShape(),
                            showValueIndicator:
                            ShowValueIndicator.never,
                            valueIndicatorTextStyle: const TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          child: Slider(
                            value: _numberOfPlayers.toDouble(),
                            min: 4,
                            max: 10,
                            divisions: 6,
                            label: _numberOfPlayers.toString(),
                            onChanged: (value) {
                              setState(() {
                                _numberOfPlayers = value.round();
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 90,),
                        const Text(
                          'Room type:',
                          style: TextStyle(fontSize: 20),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top:20),
                            child: LiteRollingSwitch(
                              value: _isPublic,
                              width: 200,
                              textSize: 22,
                              textOn: 'Public',
                              textOff: 'Private',
                              colorOn: MyStyles.green,
                              colorOff: MyStyles.red,
                              textOnColor: MyStyles.backgroundColor,
                              textOffColor: MyStyles.backgroundColor,
                              iconOn: Icons.lock_open,
                              iconOff: Icons.lock,
                              onChanged: (value) {
                                setState(() {
                                  _isPublic = value!;
                                });
                              },
                              onTap: () {},
                              onDoubleTap: () {},
                              onSwipe: () {},
                            )
                        ),
                        const SizedBox(height: 120,),
                        ElevatedButton(
                          style: MyStyles.buttonStyle,
                          onPressed: () async {
                            RoomSettings roomSettings = RoomSettings(
                                isPublic: _isPublic,
                                numberOfPlayers: _numberOfPlayers,
                            );
                            await context.read<RoomSettingsViewModel>().saveGameSettings(
                                roomSettings);
                          },
                          child: const Text(
                            "Save settings",
                          ),
                        )
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
