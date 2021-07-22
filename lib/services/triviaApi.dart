import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Decorations/constants.dart';

Map<String, String> all = {
  GK: '9',
  EB: '10',
  EF: '11',
  EM: '12',
  EMT: '13',
  ET: '14',
  EVG: '15',
  EBG: '16',
  SN: '17',
  SC: '18',
  SM: '19',
  MYTH: '20',
  SPORTS: '21',
  GEO: '22',
  HISTORY: '23',
  POL: '24',
  ART: '25',
  CELEB: '26',
  ANIMAL: '27',
  VEHICLES: '28',
  ECOMICS: '29',
  SG: '30',
  EJ: '31',
  ECARTOON: '32'
};

class triviaApi {
  static Future<String> generateTrivia(String category) async {
    print(category);
    String qn;
    String qnData;
    http.Response response = await http.get(Uri.parse(
        'https://opentdb.com/api.php?amount=' +
            '1' +
            '&category=' +
            all[category] +
            '&difficulty=easy&type=boolean'));
    if (response.statusCode == 200) {
      qnData = jsonEncode(jsonDecode(response.body)['results'][0]);
      qn = jsonDecode(response.body)['results'][0]['question'];

      if (qn.contains('&')) {
        print('ISSUEEE');
        return generateTrivia(category); //Call function again
      }
      return qnData;
    } else {
      print('Error');
    }
  }
}
