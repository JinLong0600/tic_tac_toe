import 'package:flutter/material.dart';
import 'screen/main_menu.dart';

void main() => runApp(TicTacToe());

class TicTacToe extends StatelessWidget {
  const TicTacToe({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      // theme: ThemeData.dark().copyWith(
      //       dialogTheme: DialogTheme(
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(16),
      //         ),
      //         backgroundColor: Colors.white,
      //         contentTextStyle: TextStyle(fontSize: 12),
      //         titleTextStyle:  TextStyle(fontSize: 18),
      //       ),
      //
      //     scaffoldBackgroundColor: Color(0xFF0C112D),
      // ),
          home: MainMenu(),
    );
  }
}