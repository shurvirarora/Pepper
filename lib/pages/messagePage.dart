import '../styleguide/colors.dart';
import '../styleguide/textstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Gets user id
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final User user = firebaseAuth.currentUser;
final String uid = user.uid.toString();

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  Map data;
//All the data collected from user
  int age;
  String gender;
  String aboutMe;
  String education;
  String work;
  int height;

  Future<void> addUser() {
    //Adds data to firestore
    // print("dsadsadsadas" + uid.toString());
    DocumentReference collectionReference =
        FirebaseFirestore.instance.collection('User').doc(user.uid);
    return collectionReference.set({
      'User': uid.toString(), //stores unique user id
      'Age': age,
      'Gender': gender,
      'About Me': aboutMe,
      'Education': education,
      'Work': work,
      'Height': height
    });
  }

  fetchData() {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('User');

    collectionReference
        .where("User", isEqualTo: uid.toString())
        .snapshots()
        .listen((snapshot) {
      setState(() {
        data = snapshot.docs[1].data();
        print(data.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ListView(
      children: [
        buildTextField('Age', 'Its just a number...', 30, TextInputType.number),
        Text(
          "Gender",
          style: TextStyle(color: Color(0xfffe3c72)),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: DropdownButtonFormField(
            decoration: InputDecoration(border: OutlineInputBorder()),
            hint: Text('Gender'),
            onChanged: (input) {
              setState(() {
                gender = input;
              });
              print(input);
            },
            items: [
              DropdownMenuItem(
                value: 'Male',
                child: Text('Male'),
              ),
              DropdownMenuItem(
                value: 'Female',
                child: Text('Female'),
              ),
            ],
          ),
        ),
        // buildTextField('Gender', '', 30, TextInputType.text),
        buildTextField(
            'About Me', 'Tell us about yourself...', 70, TextInputType.text),
        SizedBox(
          height: 50,
        ),
        buildTextField('Education', '', 30, TextInputType.text),
        buildTextField('Work', '', 30, TextInputType.text),
        buildTextField('Height', 'cm', 30, TextInputType.number),
        // FloatingActionButton(onPressed: addUser),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: LoginButton(
              'Update', Icons.update, addUser, Color(0xfffe3c72), Colors.black),
        ),
        // BackButton(
        //   onPressed: fetchData,
        // ),
      ],
    ));
  }

  Widget buildTextField(
      String label, String placeholder, double size, TextInputType textType) {
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
              keyboardType: textType,
              onChanged: (text) {
                //Stores input into respective variables
                if (label == "Age") {
                  age = int.parse(text);
                }
                if (label == "About Me") {
                  aboutMe = text;
                }
                if (label == "Education") {
                  education = text;
                }
                if (label == "Work") {
                  work = text;
                }
                if (label == "Height") {
                  height = int.parse(text);
                }
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
                    color: Colors.grey[500],
                  )),
            ),
          ),

          // Text(data == null ? "" : data['Bio']),
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
