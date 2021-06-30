import 'package:flutter/material.dart';
import 'loginPage.dart';

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
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Center(
          child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.red[100],
                Colors.red[200],
                Colors.red[300]
              ])),
              child: Column(children: [
                Text("YOU FOUD A MATCH!!"),
                LoginButton('Message them?', Icons.message, goBack,
                    Color(0xfffe3c72), Colors.black),
              ]))),
    ));
  }
}
