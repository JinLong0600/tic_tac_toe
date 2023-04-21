import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screen/game_page.dart';

class SelectDifficulty extends StatefulWidget {
  const SelectDifficulty({Key? key}) : super(key: key);
  @override
  State<SelectDifficulty> createState() => _SelectDifficultyState();
}

class IndexAndValue {
  final int? value;
  final List<int> indices;

  IndexAndValue({required this.value, required this.indices});
}

class _SelectDifficultyState extends State<SelectDifficulty> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Container(
            decoration: BoxDecoration(
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
                // For Logo of the page
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 75, width: double.infinity,),
                      Center(
                        child: Image.asset('images/vs.png', height: 150,),
                      ),
                      SizedBox(height: 30, width: double.infinity,),
                      Center(
                        child: Text('Select Difficulty', style:  TextStyle(fontSize: 25.0, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),

                //For the buttons
                Expanded(
                  child: Column(
                    children: [
                      // First button, Easy
                      Center(
                        child: OutlinedButton(
                          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => GamePage(isPvP: false, isPcEasy: true)));},
                          child: Text('Easy'),
                          style: OutlinedButton.styleFrom(
                            textStyle: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
                            padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 63.0),
                            primary: Colors.white,
                            side: BorderSide(width: 5, color: Colors.blue),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                            ),
                          ),
                        ),
                      ),
                      // Spacing between the next button
                      SizedBox(height: 30, width: double.infinity,),
                      // Second button, Normal
                      Center(
                        child: OutlinedButton(
                          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => GamePage(isPvP: false, isPcEasy: false)));},
                          child: Text('Normal'),
                          style: OutlinedButton.styleFrom(
                            textStyle: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
                            padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 50.0),
                            primary: Colors.white,
                            side: BorderSide(width: 5, color: Colors.blue),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                            ),
                          ),
                        ),
                      ),
                      // Spacing between the next button
                      SizedBox(height: 30, width: double.infinity,),
                      // Third button, Back
                      Center(
                        child: OutlinedButton(
                          onPressed: () {Navigator.pop(context);},
                          child: Text('Back'),
                          style: OutlinedButton.styleFrom(
                            textStyle: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
                            padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 60.0),
                            primary: Colors.white,
                            side: BorderSide(width: 5, color: Colors.blue),
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

