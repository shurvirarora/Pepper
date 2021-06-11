// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  Map data;
  String myBio;

  Future<void> addUser() {
    //Adds data to firestore
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('User');
    return collectionReference.add({'Age': '19'});
  }

  fetchData() {
    //Fetches first document
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('User');

    collectionReference.snapshots().listen((snapshot) {
      setState(() {
        data = snapshot.docs[1].data();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ListView(
      children: [
        buildTextField('About Me', 'Tell us about yourself...', 70),
        buildTextField('Age', '', 30),
        buildTextField('Work', '', 30),
        FloatingActionButton(onPressed: fetchData)
      ],
    ));
  }

  Widget buildTextField(String label, String placeholder, double size) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Color(0xfffe3c72)),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            // height: size,
            child: TextField(
              onChanged: (text) {
                addUser();
              },
              // maxLines: lines,
              style: TextStyle(), cursorColor: Color(0xfffe3c72),
              obscureText: false,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(15.0),
                      )),
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 0, size),
                  // labelText: labelText,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: placeholder,
                  hintStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  )),
            ),
          ),
          // BackButton(
          //   onPressed: fetchData,
          // ),
          Text(data == null ? "" : data['Bio']),
        ],
      ),
    );
  }
}


// BASIC INFO
// Name
// Age
// Gender
// About Me

// MY WORK & EDUCATION
// Education
// Work

// MY INTEREST
// interest ==> textbox

// ADDITIONAL INFO
// Height
// Lookingfor ==> Is a drop down
//Excercise ==> Drop down
//Drinking smoking



// PROFILE PROMPTS
// Add 3 prompt buttons