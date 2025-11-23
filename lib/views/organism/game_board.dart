import 'package:app/models/pieces/piece.dart';
import 'package:app/services/get_moves_service.dart';
import 'package:app/states/gameboard/gameboard_cubit.dart';
import 'package:app/states/gameboard/gameboard_state.dart';
import 'package:app/states/moves/moves_cubit.dart';
import 'package:app/views/atoms/case.dart';
import 'package:app/views/atoms/chessboard.dart';
import 'package:app/views/molecules/positionned_piece.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameboardCubit, GameboardState>(
      builder: (BuildContext context, GameboardState state) {
        return Stack(
          children: <Widget>[
            const Chessboard(),
            for (int i = 0; i < Chessboard.nbCasesRows; i++)
              for (int j = 0; j < Chessboard.nbCasesColumns; j++) ...<Widget>{
                Case(
                  row: i,
                  column: j,
                  isAPossibleMove: state is GameboardSelectedPieceState
                      ? state.gameBoard
                          .getPossibleMoves(state.piece)
                          .any(((int, int) move) => move == (i, j))
                      : false,
                  onPressed: () {
                    if (state is GameboardSelectedPieceState) {
                      String pgn = context.read<GameboardCubit>().moveSelectedPieceTo(i, j);

                      MovesCubit movesCubit = context.read<MovesCubit>();
                      List<String> movesList = pgn.split(' ');
                      movesList.removeWhere((String move) => move.isEmpty || move[move.length - 1] == '.');
                      GetMovesService.getMoves(movesList).then((Map<String, Map<String, int>> movesData) {
                        movesCubit.loadMovesData(movesData);
                      }).catchError((Object error) {
                        movesCubit.setErrorState();
                      });
                    }
                  },
                ),
              },
            for (Piece piece in state.gameBoard.pieces)
              PositionnedPiece(
                piece: piece,
                row: piece.row.toDouble(),
                column: piece.column.toDouble(),
                onPressed: () {
                  if (state is GameboardSelectedPieceState &&
                      state.piece == piece) {
                    context.read<GameboardCubit>().unselectPiece();
                  } else if (state is GameboardSelectedPieceState &&
                      state.piece != piece) {
                        if (state.gameBoard
                            .getPossibleMoves(state.piece)
                            .any(((int, int) move) =>
                                move == (piece.row, piece.column))) {
                          String pgn = context.read<GameboardCubit>().moveSelectedPieceTo(
                            piece.row,
                            piece.column,
                          );
                          MovesCubit movesCubit = context.read<MovesCubit>();
                          List<String> movesList = pgn.split(' ');
                          movesList.removeWhere((String move) => move.isEmpty || move[move.length - 1] == '.');
                          GetMovesService.getMoves(movesList).then((Map<String, Map<String, int>> movesData) {
                            movesCubit.loadMovesData(movesData);
                          }).catchError((Object error) {
                            movesCubit.setErrorState();
                          });
                        } else {
                          if (state.gameBoard.isLightPieceTurn() == piece.isLight()) {
                            context.read<GameboardCubit>().selectPiece(piece);
                          }
                        }
                  } else {
                    if (state.gameBoard.isLightPieceTurn() == piece.isLight()) {
                      context.read<GameboardCubit>().selectPiece(piece);
                    }
                  }
                },
              ),
          ],
        );
      },
    );
  }
}
