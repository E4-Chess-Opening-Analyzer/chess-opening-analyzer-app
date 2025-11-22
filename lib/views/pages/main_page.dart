import 'package:app/states/gameboard/gameboard_cubit.dart';
import 'package:app/states/gameboard/gameboard_state.dart';
import 'package:app/views/organism/game_scrollview.dart';
import 'package:app/views/organism/game_triple_boxes.dart';
import 'package:app/views/atoms/app_icon.dart';
import 'package:app/views/organism/game_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1A4D),
        leading: const AppIcon(),
        title: const Text(
          'Chess Opening Analyzer',
          style: TextStyle(
            fontFamily: 'Ibarra Real Nova',
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        spacing: 4.0,
        children: <Widget>[
          Padding(
            padding: const EdgeInsetsGeometry.only(top: 8.0, left: 8.0, right: 8.0),
            child: BlocBuilder<GameboardCubit, GameboardState>(
              builder: (BuildContext context, GameboardState state) =>  GameScrollview(text: state.pgn),
            ),
          ),
          const Center(
            child: GameBoard(),
          ),
          const GameTripleBoxes(move: 'e4',whiteProb: 45,drawProb: 30,blackProb: 25),
          const GameTripleBoxes(move: 'e3',whiteProb: 40,drawProb: 30,blackProb: 30),
          const GameTripleBoxes(move: 'd4',whiteProb: 80,drawProb: 14,blackProb: 6),
        ],
      ),
    );
  }
}
