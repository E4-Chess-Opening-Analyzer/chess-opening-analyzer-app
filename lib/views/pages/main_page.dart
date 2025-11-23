import 'package:app/services/get_moves_service.dart';
import 'package:app/states/gameboard/gameboard_cubit.dart';
import 'package:app/states/gameboard/gameboard_state.dart';
import 'package:app/states/moves/moves_cubit.dart';
import 'package:app/states/moves/moves_state.dart';
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
        actions: <Widget>[
          BlocBuilder<GameboardCubit, GameboardState>(
            builder: (BuildContext context, GameboardState state) {
              if (state.pgn.isEmpty) {
                return IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.white),
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('About Chess Opening Analyzer'),
                          content: const Text(
                            'This application helps you analyze chess openings by providing move probabilities based on a large database of games. Use the refresh button to reset the game and fetch new move data.'
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              } else {
                return IconButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(const Color(0xFF1E1A4D)),
                    iconColor: WidgetStateProperty.all(Colors.white)
                  ),
                  onPressed: () {
                    context.read<GameboardCubit>().resetGame();
                    MovesCubit movesCubit = context.read<MovesCubit>();
                    movesCubit.setLoadingState();
                    GetMovesService.getMoves(<String>[]).then((Map<String, Map<String, int>> movesData) {
                      movesCubit.loadMovesData(movesData);
                    }).catchError((Object error) {
                      movesCubit.setErrorState();
                    });
                  },
                  icon: const Icon(Icons.refresh)
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child:Column(
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
            BlocBuilder<MovesCubit, MovesState>(
              builder: (BuildContext context, MovesState state) {
                if(state is MovesInitial) {
                  MovesCubit movesCubit = context.read<MovesCubit>();
                  movesCubit.setLoadingState();
                  GetMovesService.getMoves(<String>[]).then((Map<String, Map<String, int>> movesData) {
                    movesCubit.loadMovesData(movesData);
                  }).catchError((Object error) {
                    movesCubit.setErrorState();
                  });
                  return const CircularProgressIndicator();
                }else if (state is MovesLoading) {
                  return const CircularProgressIndicator();
                } else if (state is MovesError) {
                  return const Text('This moves is not available in the database.');
                } else {
                  return Column(
                    children: <Widget>[
                      for (MapEntry<String, Map<String, int>> entry in state.movesData.entries)
                        GameTripleBoxes(
                          move: entry.key,
                          whiteProb: entry.value['1']!.toDouble() / (entry.value['1']! + entry.value['0']! + entry.value['-1']!).toDouble(),
                          drawProb: entry.value['0']!.toDouble() / (entry.value['1']! + entry.value['0']! + entry.value['-1']!).toDouble(),
                          blackProb: entry.value['-1']!.toDouble() / (entry.value['1']! + entry.value['0']! + entry.value['-1']!).toDouble(),
                        ),
                    ],
                  );
                }
              },
            ),        
          ],
        ),
      ),
    );
  }
}
