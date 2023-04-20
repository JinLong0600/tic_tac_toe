import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../styles//colors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

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
  //Player turns
  bool oTurn = true;
  int filledBoxes = 0;

  bool winnerFound = false;
  String resultDeclartion = '';

  List<String> displayX0 = List.filled(9, 'images/transparent.png');
  //List<string> displayX0 = List.generate(9, (index) => Image.asset('images/transparent.png'));
  List<int> matchIndexes = [];
  AudioPlayer audioPlayer = AudioPlayer();
  Future<AudioPlayer> playSound() async {
    int result = await audioPlayer.play('audio/click.mp3', isLocal: true);
    return audioPlayer;
  }

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
                        playSound();
                        _tapped(index);
                        if(!widget.isPvP){
                          Future.delayed(Duration(milliseconds: 500), ()
                          {
                            if(resultDeclartion == ''){
                              if(widget.isPcEasy)
                                {
                                  EasyComputer();
                                  playSound();
                                }
                              else
                                {
                                  NormalComputer();
                                  playSound();
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
                              color: MainColor.primaryColor,
                            ),
                            color: matchIndexes.contains(index) ? MainColor.accentColor : MainColor.secondaryColor
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

  void _tapped(int index) {
    setState(() {
      // When player tapped on the slot will
      if (oTurn && displayX0[index]  == 'images/transparent.png') {
        displayX0[index] = 'images/white_o.png';//Image.asset('images/white_o.png');
        filledBoxes++;
      }
      else if (widget.isPvP && !oTurn && displayX0[index] == 'images/transparent.png') {
        displayX0[index] = 'images/white_x.png';//Image.asset('images/white_x.png');
        filledBoxes++;
      }

      _checkWinner();

      oTurn = !oTurn;
    }
    );
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
      if (displayX0[num]  == 'images/transparent.png') {
        displayX0[num] = 'images/white_x.png';//Image.asset('images/white_x.png');
        filledBoxes++;
      }
      // Check did it win after the move
      _checkWinner();

      // Lastly update the turn
      oTurn = !oTurn;
    });
  }

  // Difficulty Normal for Computer
  void NormalComputer(){
    // Init slot that has placed by O
    List<int> slotO = [];

    // Init losing condition for X
    List<int> losingPercentage = [0,0,0,0,0,0,0,0];

    // List out all the winning combinations
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

    //
    displayX0.asMap().forEach((index, value) {
      if (value == 'images/white_o.png')
      {
        slotO.add(index);
      }
    });



    for(int index in slotO)
    {
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

      if(listOWinningSets[6].contains(index))
      {
        losingPercentage[6] += 33; // G
      }
      else if(listOWinningSets[7].contains(index))
      {
        losingPercentage[7] += 33; // H
      }
    }

    var maxIndex = IndexAndValue(value: null, indices: []);
    var secondMaxIndex= IndexAndValue(value: null, indices: []);

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
    //print('${losingPercentage} step 2: The highest value is ${maxIndex.value} at index/indices: ${maxIndex.indices}');

    //print('step 3: The 2nd highest value is ${secondMaxIndex.value} at index/indices: ${secondMaxIndex.indices}');
    //print('step 4: The 2nd highest value but is maxIndex is ${maxIndex.value} at index/indices: ${maxIndex.indices}');
    Random random = new Random();

    List<int> toberandom = [];

    while(toberandom.isEmpty)
    {
      if(maxIndex.indices.isNotEmpty)
      {
        int largestIndex = random.nextInt(maxIndex.indices.length);
        print('1st if ${maxIndex.indices}');
        int randomValue = maxIndex.indices[largestIndex]; // the value is respented as set
        print('start of if ${maxIndex.indices.length}');
        for(int val in listOWinningSets[randomValue])
        {
          if(displayX0[val] == 'images/transparent.png')
          {
            toberandom.add(val);
          }
        }
        if(toberandom.isEmpty)
        {
          print('start to remove ${randomValue}');
          maxIndex.indices.remove(randomValue);
          print('removed');
        }
      }
      else if(secondMaxIndex.indices.isEmpty)
      {
        print('2nd if');
        int secondLargestIndex = random.nextInt(secondMaxIndex.indices.length);
        int randomValue = secondMaxIndex.indices[secondLargestIndex]; // the value is respented as set
        for(int val in listOWinningSets[randomValue])
        {
          if(displayX0[val] == 'images/transparent.png')
          {
            toberandom.add(val);
          }
        }
        if(toberandom.isEmpty)
        {
          secondMaxIndex.indices.remove(randomValue);
        }

      }
      else{
        break;
      }
    }


    print(toberandom.length);
    if(toberandom.length == 0 || toberandom.isEmpty)
    {
      print('enter');
      while(toberandom.isEmpty)
      {
        bool isEmpty = false;
        int randomIndex = random.nextInt(secondMaxIndex.indices.length);
        int randomValue = secondMaxIndex.indices[randomIndex]; // the value is respented as set
        for(int val in listOWinningSets[randomValue])
        {
          if(displayX0[val] == 'images/transparent.png')
          {
            toberandom.add(val);
          }
        }
        if(toberandom.isEmpty)
        {
          secondMaxIndex.indices.remove(randomValue);
        }
        print('${toberandom} The highest value is ${secondMaxIndex.value} at index/indices: ${secondMaxIndex.indices}');

      }
    }

    print('======================');

    setState(() {
      int ranInd = random.nextInt(toberandom.length);

      displayX0[toberandom[ranInd]] = 'images/white_x.png';//Image.asset('images/white_x.png');
      filledBoxes++;

      oTurn = !oTurn;
      _checkWinner();
    }
    );
  }

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
        displayX0[0] == 'images/white_x.png'?
        'Player X Wins!' : 'Player O Wins!';
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
        displayX0[3] == 'images/white_x.png'?
        'Player X Wins!' : 'Player O Wins!';
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
        displayX0[6] == 'images/white_x.png'?
        'Player X Wins!' : 'Player O Wins!';
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
        displayX0[0] == 'images/white_x.png'?
        'Player X Wins!' : 'Player O Wins!';
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
        displayX0[1] == 'images/white_x.png'?
        'Player X Wins!' : 'Player O Wins!';
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
        displayX0[2] == 'images/white_x.png'?
        'Player X Wins!' : 'Player O Wins!';
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
        displayX0[0] == 'images/white_x.png'?
        'Player X Wins!' : 'Player O Wins!';
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
        displayX0[2] == 'images/white_x.png'?
        'Player X Wins!' : 'Player O Wins!';
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

  void showMyDialog(BuildContext context, bool isDraw) {
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
            title: Text('Result'),
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
                  _clearBoard();
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
                  _clearBoard();
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
      for (int i = 0; i < 9; i++) {
        displayX0[i] ='images/transparent.png';
      }
      matchIndexes.clear();
      resultDeclartion = '';
    });
    filledBoxes = 0;
    oTurn = true;
  }


}

