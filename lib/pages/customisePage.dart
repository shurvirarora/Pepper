import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/editProfilePage.dart';
import 'package:myapp/pages/viewProfilePage.dart';
import 'package:myapp/styleguide/colors.dart';
import 'package:myapp/styleguide/textstyle.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/User.dart';

// RESPONSIBLE FOR NAVIGATION BETWEEN THE 3 MAIN TABS
final List<Widget> customiseChildren = [
  editProfile(customisePage.user),
  viewProfile(customisePage.user)
];

class customisePage extends StatefulWidget {
  customisePage(UserModel user) {
    customisePage.user = user;
  }
  static File file;
  static UserModel user;
  static bool imgAdded = false;
  @override
  _customisePageState createState() => _customisePageState();
}

class _customisePageState extends State<customisePage> {
  bool _messagesHasBeenPressed = true;
  bool _gamesHasBeenPressed = false;

  int _selectedTab = 0;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = i;
    });
  }

  final FirebaseStorage storage =
      FirebaseStorage.instanceFor(bucket: 'gs://pepper-e9a17.appspot.com');
  UploadTask uploadTask;
  String filePath;
  String url;
  startUpload() async {
    if (!customisePage.imgAdded) {
      return;
    }
    filePath = 'images/${DateTime.now()}.png';
    // Reference ref = storage.ref().child("/photo.jpg");

    setState(() {
      uploadTask = storage.ref().child(filePath).putFile(customisePage.file);
    });
    // customisePage.user.setFile = widget.file;
    var dowurl =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    url = dowurl.toString(); //address where image stored
    customisePage.user.setUrl = url;
    print("URL GOES HERE");
    print(url);
  }

  Future<void> addUser() async {
    //Adds data to firestore
    // startUpload();
    // print(customisePage.user.name);
    // if (customisePage.file == null) {
    //   showDialog(
    //     context: context,
    //     builder: (ctx) => AlertDialog(
    //       title: Text("Looks like you forgot something"),
    //       content: Text("Please add an image"),
    //       actions: <Widget>[
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(ctx).pop();
    //           },
    //           child: Text("Ok"),
    //         ),
    //       ],
    //     ),
    //   );
    // } else {
    print(customisePage.user.name);
    await startUpload();
    DocumentReference collectionReference =
        FirebaseFirestore.instance.collection('User').doc(user.uid);
    // Navigator.pop(context);
    return collectionReference.set({
      'User': uid.toString(),
      'Name': customisePage.user.name, //stores unique user id
      'Age': customisePage.user.age,
      'Gender': customisePage.user.gender,
      'About Me': customisePage.user.aboutMe,
      'Education': customisePage.user.education,
      'Work': customisePage.user.work,
      'Height': customisePage.user.height,
      'DownloadUrl': customisePage.user.url
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110.0),
          child: customiseNav(),
        ),
        body: customiseChildren[_selectedTab],
      ),
    );
  }

  Widget customiseNav() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: Container(
        color: Colors.white,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            FontAwesomeIcons.times,
            size: 22,
            color: primaryColor,
          ),
        ),
      ),
      title: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Text(
          customisePage.user.name,
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(10),
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: Text("Edit",
                    style: TextStyle(
                      fontSize: 16,
                      color: _messagesHasBeenPressed
                          ? primaryColor
                          : Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: () => {
                  _handleIndexChanged(0),
                  setState(() {
                    _messagesHasBeenPressed = true;
                    _gamesHasBeenPressed = false;
                  })
                },
              ),
              SizedBox(
                width: 30,
              ),
              Container(
                height: 20,
                width: 1,
                decoration:
                    BoxDecoration(color: Colors.black.withOpacity(0.15)),
              ),
              SizedBox(
                width: 30,
              ),
              TextButton(
                child: Text("View",
                    style: TextStyle(
                      fontSize: 16,
                      color: _gamesHasBeenPressed
                          ? primaryColor
                          : Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: () => {
                  _handleIndexChanged(1),
                  setState(() {
                    _messagesHasBeenPressed = false;
                    _gamesHasBeenPressed = true;
                  })
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        Container(
          color: Colors.white,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
          child: IconButton(
            onPressed: () async {
              await addUser();
              Navigator.of(context).pop();
            },
            icon: Icon(
              FontAwesomeIcons.check,
              size: 22,
              color: primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
