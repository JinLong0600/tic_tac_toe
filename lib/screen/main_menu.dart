import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tic_tac_toe/screen/game_page.dart';
import 'package:tic_tac_toe/screen/select_difficulty.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:tic_tac_toe/consts/text_style.dart';

class MainMenu extends StatefulWidget {
  //const MainMenu({Key? key}) : super(key: key);
  @override
  State<MainMenu> createState() => _MainMenuState();
}


AudioPlayer audioPlayer = AudioPlayer();
AudioCache audioCache = AudioCache();

@override
void initState() {
  //super.initState();
  audioPlayer = AudioPlayer();
  audioCache = AudioCache();
}

Future<AudioPlayer> playSound() async {
  await audioPlayer.play('audio/backgroundmusic.mp3', isLocal: true);
  audioPlayer.setVolume(0.1);
  audioPlayer.setReleaseMode(ReleaseMode.LOOP);
  return audioPlayer;
}

class IndexAndValue {
  final int? value;
  final List<int> indices;

  IndexAndValue({required this.value, required this.indices});
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    playSound();
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2B0933),
                Color(0xFF3B0933),
                Color(0xFF4B0933),
                Color(0xFF5B0933),
                Color(0xFF6B0933),
                Color(0xFF7B093C),
              ],
            stops: [
              0.2,
              0.5,
              0.6,
              0.7,
              0.8,
              0.9,
            ],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 75, width: double.infinity,),
                    CircleAvatar(
                      backgroundImage: AssetImage('images/logo.png'),
                      radius: 70.0,
                    ),
                    SizedBox(height: 30, width: double.infinity,),
                    Center(
                        child: Text('Tic Tac Toe', style: font35()),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Center(
                      child: OutlinedButton(
                        onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => GamePage(isPvP: true, isPcEasy: true)));},
                        child: Text('Player VS Player', style: TextStyle(fontWeight: FontWeight.bold),),
                        style: OutlinedButton.styleFrom(
                          textStyle: font20(),
                          padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 65.0),
                          primary: Colors.white,
                          side: BorderSide(width: 5, color: Colors.grey.shade300,),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30, width: double.infinity,),
                    Center(
                      child: OutlinedButton(
                        onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SelectDifficulty()));},
                        child: Text('Player VS Computer'),
                        style: OutlinedButton.styleFrom(
                          textStyle: font20(),
                          padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 50.0),
                          primary: Colors.white,
                          side: BorderSide(width: 5, color: Colors.grey.shade300,),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ],
          ),
        )

      ),
    );
  }

}

