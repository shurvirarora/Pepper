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

//&quot;
class triviaApi {
  static Future<String> generateTrivia(String category) async {
    print(category);
    String qn;
    var qnData;
    http.Response response = await http.get(Uri.parse(
        'https://opentdb.com/api.php?amount=' +
            '1' +
            '&category=' +
            all[category] +
            '&difficulty=easy&type=boolean'));
    if (response.statusCode == 200) {
      qnData = jsonDecode(response.body)['results'][0];
      qn = jsonDecode(response.body)['results'][0]['question'];

      if (qn.contains('&quot;')) {
        //   print('ISSUEEE');
        print(qn);

        qn = qn.replaceAll('&quot;', '');
        qnData['question'] = qn;
      } else if (qn.contains('&')) {
        return generateTrivia(category); //Call function again
      }
      return jsonEncode(qnData);
    } else {
      print('Error');
    }
  }
}
