import 'package:chess/chess.dart';

class MoveToPgnService {
  final Chess chess = Chess();
  String getPgnFromMove(int fromRow, int fromColumn, int toRow, int toColumn) {
    if (chess.move(<String, String>{
      'from': squareToString(fromRow, fromColumn),
      'to': squareToString(toRow, toColumn),
    })){
      return chess.pgn();
    }
    
    throw Exception('Invalid move');
  }

  Map<int, String> rowToRank = <int, String>{
    0: '1',
    1: '2',
    2: '3',
    3: '4',
    4: '5',
    5: '6',
    6: '7',
    7: '8',
  };

  Map<int, String> columnToFile = <int, String>{
    0: 'a',
    1: 'b',
    2: 'c',
    3: 'd',
    4: 'e',
    5: 'f',
    6: 'g',
    7: 'h',
  };

  String squareToString(int row, int column) {
    return columnToFile[column]! + rowToRank[row]!;
  }
}
