import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class gamesPage extends StatefulWidget {
  @override
  _gamesPageState createState() => _gamesPageState();
}

class _gamesPageState extends State<gamesPage> {
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  String numOfQns = '1'; //Give users 1 qn at a time
  List<String> qnDifficulty = ['easy', 'medium', 'hard'];
  List<String> qnType = ['boolean', 'multiple'];
  Map<String, String> category = {
    'GK': '9',
    'E:B': '10',
    'E:F': '11',
    'E:M': '12',
    'E:M&T': '13',
    'E:T': '14',
    'E:VG': '15',
    'E:BG': '16',
    'ScienceN': '17',
    'S:C': '18',
    'S:M': '19',
    'MYTH': '20',
    'SPORTS': '21',
    'GEO': '22',
    'HISTORY': '23',
    'POL': '24',
    'ART': '25',
    'CELEB': '26',
    'ANIMAL': '27',
    'VEHICLES': '28',
    'E:COMICS': '29',
    'S:G': '30',
    'E:J': '31',
    'E:CARTOON': '32'
  };

  // String apiKeyTourismBoard = 'ACibWVaXV9Tak3Ivslvbw1efl2BjNQah';
  // String weatherApi =
  //     'http://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=f76235aa829afcf8bfd9790c4249fab8';
  // String tourism =
  //     'https://tih-api.stb.gov.sg/content/v1/tag?language=en&apikey=ACibWVaXV9Tak3Ivslvbw1efl2BjNQah';

  Future getData() async {
    http.Response response = await http.get(Uri.parse(
        'https://opentdb.com/api.php?amount=' +
            numOfQns +
            '&category=9&difficulty=easy&type=multiple'));
    if (response.statusCode == 200) {
      print(jsonDecode(response.body)['results'][1]);
    } else {
      print('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Games Here'),
      ),
    );
  }
}
