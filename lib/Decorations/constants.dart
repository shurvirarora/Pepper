import 'package:flutter/material.dart';

InputDecoration textFieldDeco(String label, String hint) {
  return InputDecoration(
    prefixIcon: Icon(Icons.email),
    labelText: label,
    labelStyle: TextStyle(
        fontSize: 22,
        color: Colors.black,
        textBaseline: TextBaseline.alphabetic),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    alignLabelWithHint: true,
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
    ),
  );
}

String GK = 'General Knowledge';
String EB = 'Entertainment: Books';
String EF = 'Entertainment: Film';
String EM = 'Entertainment: Music';
String EMT = 'Entertainment: Musicals & Theatres';
String ET = 'Entertainment: Television';
String EVG = 'Entertainment: Video Games';
String EBG = 'Entertainment: Board Games';
String SN = 'Science & Nature';
String SC = 'Science: Computers';
String SM = 'Science: Math';
String MYTH = 'Mythology';
String SPORTS = 'Sports';
String GEO = 'Geography';
String HISTORY = 'History';
String POL = 'Politics';
String ART = 'Art';
String CELEB = 'Celebrity';
String ANIMAL = 'Animal';
String VEHICLES = 'Vehicles';
String ECOMICS = 'Entertainment: Comics';
String SG = 'Sience: Gadgets';
String EJ = 'Entertainment: Japanese Anime & Manga';
String ECARTOON = 'Entertainment: Cartoon & Animations';
Size screenSize(BuildContext context) => MediaQuery.of(context).size;
double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
