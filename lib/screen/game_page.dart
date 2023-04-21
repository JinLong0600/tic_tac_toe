import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

class GamePage extends StatefulWidget {
  //const GamePage({Key? key}) : super(key: key);
  final bool isPvP;
  final bool isPcEasy;

  @override
  State<GamePage> createState() => _GamePageState();
  GamePage({required this.isPvP, required this.isPcEasy});
}

class IndexAndValue {
  final int? value;
  final List<int> indices;

  IndexAndValue({required this.value, required this.indices});
}

class _GamePageState extends State<GamePage> {
  //Player Turns
  bool oTurn = true;
  // Total filled in order to check whether the match is a draw
  int filledBoxes = 0;
  // Outplay message when a winner is produced
  String resultDeclartion = '';
  // Winning combination
  List<int> matchIndexes = [];
  // Fill the grid will empty image
  List<String> displayX0 = List.filled(9, 'images/transparent.png');

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child:
            Text(
                oTurn && widget.isPvP ? "Player One's turn" :
                !oTurn && widget.isPvP ? "Player Two's turn" :
                oTurn && !widget.isPvP ? "Player's turn" : "Computer's turn"
            )
        ),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xFF0A0068),
                  Color(0xFF26007B),
                  Color(0xFF42008D),
                ],
                stops: [
                  0.3,
                  0.6,
                  0.9,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
            ),
          ),
        ),
      ),
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
          children: [
            SizedBox(height: 50, width: double.infinity,),
            Expanded(
              flex: 3,
              child: GridView.builder(
                  itemCount: 9,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemBuilder: (BuildContext, int index){
                    return GestureDetector(
                      onTap: () async {
                        playSound('audio/click.mp3', 1);
                        _tapped(index);
                        if(!widget.isPvP){
                          // Delay 0.5 sec before the move is made by Computer
                          Future.delayed(Duration(milliseconds: 500), ()
                          {
                            if(resultDeclartion == ''){
                              if(widget.isPcEasy)
                                {
                                  EasyComputer();
                                }
                              else
                                {
                                  NormalComputer();
                                }
                            }
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              width: 10,
                              color: Colors.black,
                            ),
                            gradient: RadialGradient(
                            colors : matchIndexes.contains(index) ? [Color(0xFF003A6C), Color(0xFF89CFF0), Color(0xFFB0E0E6)] : [Color(0xFF47046C), Color(0xFF731E9D), Color(0xFFA041C5)],
                            center: Alignment.topLeft, radius: 3
                            ),

                            //color: matchIndexes.contains(index) ? MainColor.accentColor : MainColor.secondaryColor
                        ),
                        child: Center(
                          child: Image.asset(displayX0[index]),
                        ),
                      ),
                    );
                  }
              ),
            ),
          ],

        ),
      ),
    );
  }

  // Play sound effects
  Future<AudioPlayer> playSound(String fileName, double volume) async {
    await audioPlayer.play(fileName, isLocal: true);
    audioPlayer.setVolume(volume);
    return audioPlayer;
  }

  void _tapped(int index) {
    setState(() {
      // When player tapped on the slot will
      if (oTurn && displayX0[index]  == 'images/transparent.png') {
        displayX0[index] = 'images/white_o.png';
        filledBoxes++;
        // Change player turns
        oTurn = false;
      }
      else if (widget.isPvP && !oTurn && displayX0[index] == 'images/transparent.png') {
        displayX0[index] = 'images/white_x.png';
        filledBoxes++;
        // Change player turns
        oTurn = true;
      }

      // Check winner during each tap
      _checkWinner();
    });
  }

  // Difficulty Easy for Computer
  void EasyComputer(){
    // Random number from 0-8 which is the array length/grid slot
    int num =  Random().nextInt(9);

    // Check if the randomed number slot is Empty, meaning haven't been filled wiht O || X
    while (displayX0[num] != 'images/transparent.png')
    {
      num =  Random().nextInt(9);
      //index = Random().nextInt(displayX0.length);
    }

    // Change the image from transparent.png to X image
    setState(() {

      if (!oTurn && displayX0[num]  == 'images/transparent.png') {
        displayX0[num] = 'images/white_x.png';//Image.asset('images/white_x.png');
        filledBoxes++;

        // Change player turns
        oTurn = true;

        // Play sound effect
        playSound('audio/click.mp3', 1);
      }
      // Check did it win after the move
      _checkWinner();
    });
  }

  // Difficulty Normal for Computer
  void NormalComputer(){
    Random random = new Random();
    // Will be used to record which slot has been placed by O.
    List<int> slotO = [];

    // Losing percentage based on the winning combinations by O. In total is 8 combinations
    List<int> losingPercentage = [0,0,0,0,0,0,0,0];

    // List out all the winning combinations for O
    List<Set<int>> listOWinningSets = [
      {0, 1, 2},
      {3, 4, 5},
      {6, 7, 8},
      {0, 3, 6},
      {1, 4, 7},
      {2, 5, 8},
      {0, 4, 8},
      {2, 4, 6},
    ];

    // To Store the Largest and 2nd Largest Losing Percantage from the combination
    var maxIndex = IndexAndValue(value: null, indices: []);
    var secondMaxIndex= IndexAndValue(value: null, indices: []);

    //
    List<int> randomWinningCombination = [];

    // Add the slot that has mark as O into "slotO"
    displayX0.asMap().forEach((index, value) {
      if (value == 'images/white_o.png')
      {
        slotO.add(index);
      }
    });

    // Adding the losingPercentage for X based on the winningCombiation of O
    for(int index in slotO)
    {
      // Based on rows
      if(listOWinningSets[0].contains(index))
      {
        losingPercentage[0] += 33; // A
      }
      else if(listOWinningSets[1].contains(index))
      {
        losingPercentage[1] += 33; // B
      }
      else if(listOWinningSets[2].contains(index))
      {
        losingPercentage[2] += 33; // C
      }

      // Based on Columns
      if(listOWinningSets[3].contains(index))
      {
        losingPercentage[3] += 33; // D
      }
      else if(listOWinningSets[4].contains(index))
      {
        losingPercentage[4] += 33; // E
      }
      else if(listOWinningSets[5].contains(index))
      {
        losingPercentage[5] += 33; // F
      }

      // Based on Diagonal
      if(listOWinningSets[6].contains(index))
      {
        losingPercentage[6] += 33; // G
      }
      else if(listOWinningSets[7].contains(index))
      {
        losingPercentage[7] += 33; // H
      }
    }

    // Getting the largest and 2nd large losing percentage combinations
    losingPercentage.asMap().forEach((index, value) {
      if (maxIndex.value == null || value > maxIndex.value!) {
        maxIndex = IndexAndValue(value: value, indices: [index]);
      } else if (value == maxIndex.value) {
        maxIndex.indices.add(index);
      }else if (secondMaxIndex.value == null || value > secondMaxIndex!.value!) {
        secondMaxIndex = IndexAndValue(value: value, indices: [index]);
      } else if (value == secondMaxIndex!.value) {
        secondMaxIndex!.indices.add(index);
      }
    });

    // 1st looping to get the Winning Combination based on the Largest losing percentages
    while(randomWinningCombination.isEmpty)
    {
      // Check the 1st Largest percentages whether all the move inside has been made.
      if(maxIndex.indices.isNotEmpty)
      {
        // Random the moves inside the winning combinations
        int largestIndex = random.nextInt(maxIndex.indices.length);
        int randomValue = maxIndex.indices[largestIndex];

        // Looping for checking the available moves
        for(int val in listOWinningSets[randomValue])
        {
          // Check all the moves inside the winning combination is still available
          if(displayX0[val] == 'images/transparent.png')
          {
            randomWinningCombination.add(val);
          }
        }
        // Check the available move inside the winning combination is all been made
        if(randomWinningCombination.isEmpty)
        {
          // If yes, remove the winning combination
          maxIndex.indices.remove(randomValue);
        }
      }
      // Else  break loop
      else{
        break;
      }
    }

    // If 1st Largest percentages has no more moves will proceed into the second one.
    if(randomWinningCombination.length == 0 || randomWinningCombination.isEmpty)
    {
      // 2nd looping to get the Winning Combination based on the 2nd Largest losing percentages
      while(randomWinningCombination.isEmpty)
      {
        // Random the moves inside the winning combinations
        int randomIndex = random.nextInt(secondMaxIndex.indices.length);
        int randomValue = secondMaxIndex.indices[randomIndex];

        // Looping for checking the available moves
        for(int val in listOWinningSets[randomValue])
        {
          // Check all the moves inside the winning combination is still available
          if(displayX0[val] == 'images/transparent.png')
          {
            randomWinningCombination.add(val);
          }
        }
        // Check the available move inside the winning combination is all been made
        if(randomWinningCombination.isEmpty)
        {
          secondMaxIndex.indices.remove(randomValue);
        }
      }
    }

    setState(() {
      // To random a slot from the Winning Combination to play X move
      int randomSlotToBePlaced = random.nextInt(randomWinningCombination.length);
      if (!oTurn) {
        displayX0[randomWinningCombination[randomSlotToBePlaced]] = 'images/white_x.png';
        filledBoxes++;

        // Play sound effect
        playSound('audio/click.mp3', 1);

        // Change player turns
        oTurn = true;
      }
      // Check did it win after the move
      _checkWinner();

      });
  }

  // Check winner
  void _checkWinner() {
    // Check winning by rows whether 3 is matched
    // Checking 1st row
    if (
    displayX0[0] == displayX0[1] &&
        displayX0[0] == displayX0[2] &&
        displayX0[0] != 'images/transparent.png')
    {
      setState(() {

        resultDeclartion =
        displayX0[0] == 'images/white_o.png' && widget.isPvP ? 'Player One Wins!' :
        displayX0[0] == 'images/white_x.png' && widget.isPvP ? 'Player Two Wins!' :
        displayX0[0] == 'images/white_o.png' && !widget.isPvP ? 'Player Wins!' : 'Player Lose!';
        matchIndexes.addAll([0, 1, 2]);
        showMyDialog(context, false);
      });
    }
    // Checking 2nd row
    else if (displayX0[3] == displayX0[4] &&
        displayX0[3] == displayX0[5] &&
        displayX0[3] != 'images/transparent.png') {
      setState(() {
        resultDeclartion =
        displayX0[3] == 'images/white_o.png' && widget.isPvP ? 'Player One Wins!' :
        displayX0[3] == 'images/white_x.png' && widget.isPvP ? 'Player Two Wins!' :
        displayX0[3] == 'images/white_o.png' && !widget.isPvP ? 'Player Wins!' : 'Player Lose!';
        matchIndexes.addAll([3, 4, 5]);
        showMyDialog(context, false);
      });
    }
    // Checking 3rd row
    else if (displayX0[6] == displayX0[7] &&
        displayX0[6] == displayX0[8] &&
        displayX0[6] != 'images/transparent.png') {
      setState(() {
        resultDeclartion =
        displayX0[6] == 'images/white_o.png' && widget.isPvP ? 'Player One Wins!' :
        displayX0[6] == 'images/white_x.png' && widget.isPvP ? 'Player Two Wins!' :
        displayX0[6] == 'images/white_o.png' && !widget.isPvP ? 'Player Wins!' : 'Player Lose!';
        matchIndexes.addAll([6, 7, 8]);
        showMyDialog(context, false);
      });
    }

    // Check winning by columns whether 3 is matched
    // Checking 1st colum
    else if (displayX0[0] == displayX0[3] &&
        displayX0[0] == displayX0[6] &&
        displayX0[0] != 'images/transparent.png') {
      setState(() {
        resultDeclartion =
        displayX0[0] == 'images/white_o.png' && widget.isPvP ? 'Player One Wins!' :
        displayX0[0] == 'images/white_x.png' && widget.isPvP ? 'Player Two Wins!' :
        displayX0[0] == 'images/white_o.png' && !widget.isPvP ? 'Player Wins!' : 'Player Lose!';
        matchIndexes.addAll([0, 3, 6]);
        showMyDialog(context, false);
      });
    }
    // Checking 2st colum
    else if (displayX0[1] == displayX0[4] &&
        displayX0[1] == displayX0[7] &&
        displayX0[1] != 'images/transparent.png') {
      setState(() {
        resultDeclartion =
        displayX0[1] == 'images/white_o.png' && widget.isPvP ? 'Player One Wins!' :
        displayX0[1] == 'images/white_x.png' && widget.isPvP ? 'Player Two Wins!' :
        displayX0[1] == 'images/white_o.png' && !widget.isPvP ? 'Player Wins!' : 'Player Lose!';
        matchIndexes.addAll([1, 7, 4]);
        showMyDialog(context, false);
      });
    }
    // Checking 3rd colum
    else if (displayX0[2] == displayX0[5] &&
        displayX0[2] == displayX0[8] &&
        displayX0[2] != 'images/transparent.png') {
      setState(() {
        resultDeclartion =
        displayX0[2] == 'images/white_o.png' && widget.isPvP ? 'Player One Wins!' :
        displayX0[2] == 'images/white_x.png' && widget.isPvP ? 'Player Two Wins!' :
        displayX0[2] == 'images/white_o.png' && !widget.isPvP ? 'Player Wins!' : 'Player Lose!';
        matchIndexes.addAll([2, 5, 8]);
        showMyDialog(context, false);
      });
    }

    // Check winning by diagonal
    // Checking from top-left to bottom-right
    else if (displayX0[0] == displayX0[4] &&
        displayX0[0] == displayX0[8] &&
        displayX0[0] != 'images/transparent.png') {
      setState(() {
        resultDeclartion =
        displayX0[0] == 'images/white_o.png' && widget.isPvP ? 'Player One Wins!' :
        displayX0[0] == 'images/white_x.png' && widget.isPvP ? 'Player Two Wins!' :
        displayX0[0] == 'images/white_o.png' && !widget.isPvP ? 'Player Wins!' : 'Player Lose!';
        matchIndexes.addAll([0, 4, 8]);
        showMyDialog(context, false);
      });
    }
    // Checking from top-right to bottom-left
    else if (displayX0[2] == displayX0[4] &&
        displayX0[2] == displayX0[6] &&
        displayX0[2] != 'images/transparent.png') {
      setState(() {
        resultDeclartion =
        displayX0[2] == 'images/white_o.png' && widget.isPvP ? 'Player One Wins!' :
        displayX0[2] == 'images/white_x.png' && widget.isPvP ? 'Player Two Wins!' :
        displayX0[2] == 'images/white_o.png' && !widget.isPvP ? 'Player Wins!' : 'Player Lose!';
        matchIndexes.addAll([4, 6, 2]);
        showMyDialog(context, false);
        //stopTimer();
      });
    }

    // Checking whether is a draw, when 9 slot is been filled
    else if (filledBoxes == 9) {
      setState(() {
        resultDeclartion = 'Its a draw!';
        showMyDialog(context, true);
      });
    }
  }

  // Pop-up window when a result is produced
  void showMyDialog(BuildContext context, bool isDraw) {
    if(resultDeclartion.contains("Win"))
      {
        playSound("audio/win.mp3", 0.2);
      }
    else if (resultDeclartion == "Its a draw!")
      {
        playSound("audio/draw.mp3", 0.2);
      }else
      {
        playSound("audio/fail.mp3", 0.2);
      }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // WillPopScope will prevent the AlertDialog been close when clicking outside
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          // AlertDialog will allow user to return to "Main Menu" when clicking "Quit"; To play again click "Play Again"
          child: AlertDialog(
            title: Text('Result', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
            content: Text(resultDeclartion),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 18)),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(12)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                child: Text('Main Menu'),
                onPressed: () {
                  // Close the pop-up window
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 18)),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(12)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                child: Text('Play Again'),
                onPressed: () {
                  // Once click will the broad
                  _clearBoard();
                  // Close the pop-up window
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Resetting the board to empty in order to play again
  void _clearBoard() {
    setState(() {
      // Set all image to empty
      for (int i = 0; i < 9; i++) {
        displayX0[i] ='images/transparent.png';
      }
      matchIndexes.clear();
      resultDeclartion = '';
    });
    // Reset the value for filledBoxed
    filledBoxes = 0;
    // Reset player turns to Player One's turns
    oTurn = true;
  }


}

