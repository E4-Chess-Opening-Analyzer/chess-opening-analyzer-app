import 'dart:convert';

import 'package:app/services/api_routes.dart';
import 'package:http/http.dart' as http;

class GetMovesService {
  static Future<Map<String, Map<String, int>>> getMoves(List<String> moves) async {
    http.Client client = http.Client();
    try {
      Uri uri = Uri.parse(GET_MOVES_API);
      List<String> body = moves;
      http.Response response = await client.post(uri, body: jsonEncode(body), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> decoded = jsonDecode(response.body) as Map<String, dynamic>;
        Map<String, Map<String, int>> movesData = <String, Map<String, int>>{};
        // ignore: always_specify_types
        decoded.forEach((String key, value) {
          // ignore: always_specify_types
          movesData[key] = (value as Map<String, dynamic>).map((String k, v) => MapEntry<String, int>(k, v as int));
        });
        
        List<String> sortedKeys = movesData.keys.toList(growable:false)
          ..sort((String k1, String k2) => (movesData[k2]!['-1']! + movesData[k2]!['0']! + movesData[k2]!['1']!).compareTo(movesData[k1]!['-1']! + movesData[k1]!['0']! + movesData[k1]!['1']!));
        Map<String, Map<String, int>> sortedMap = <String, Map<String, int>>{ for (String k in sortedKeys) k : movesData[k]! };
                
        return sortedMap;
      } else {
        throw Exception('Failed to load moves');
      }
    } finally {
      client.close();
    }
  }
}
