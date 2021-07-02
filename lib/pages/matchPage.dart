import 'package:flutter/material.dart';
import 'package:myapp/commons/my_info.dart';
import 'package:myapp/commons/rounded_image.dart';
import 'package:myapp/main.dart';
import 'loginPage.dart';
import 'package:myapp/styleguide/colors.dart';
import 'package:myapp/styleguide/textstyle.dart';

class matchPage extends StatefulWidget {
  @override
  _matchPageState createState() => _matchPageState();
}

class _matchPageState extends State<matchPage> {
  goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var url;
    return SafeArea(
        child: Scaffold(
      backgroundColor: primaryColor.withOpacity(0.8),
      body: Center(
          child: Container(
              /*decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.red[100],
                Colors.red[200],
                Colors.red[300]
              ])),*/
              child: Column(children: [
        Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.1,
                horizontal: 30.0)),
        Text("SPICY", style: pepperHeaderStyle),
        SizedBox(
          height: 10,
        ),
        /*RoundedImage(
          imagePath: ,
          size: Size.fromWidth(120),
        ),*/
        SizedBox(
          height: 5,
        ),
        Text(
          "What are you waiting for?",
          style: pepperNormalStyle,
        ),
        SizedBox(
          height: 5,
        ),
        LoginButton("Start a convo now", Icons.message, goBack,
            Color(0xfffe3c72), Colors.black),
        SizedBox(
          height: 5,
        ),
        LoginButton("Continue Swiping", Icons.message, goBack,
            Color(0xfffe3c72), Colors.black),
      ]))),
    ));
  }
}
