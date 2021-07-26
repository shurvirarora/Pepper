import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/commons/my_info.dart';
import 'package:myapp/commons/radial_decoration.dart';
import 'package:myapp/commons/rounded_image.dart';
import 'package:myapp/main.dart';
import 'package:myapp/pages/chatPage.dart';
import 'loginPage.dart';
import 'package:myapp/styleguide/colors.dart';
import 'package:myapp/styleguide/textstyle.dart';

CollectionReference userReference =
    FirebaseFirestore.instance.collection('User');
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final User user = firebaseAuth.currentUser;
final String uid = user.uid.toString();

class matchPage extends StatefulWidget {
  String currPersonId;
  matchPage(this.currPersonId);

  @override
  _matchPageState createState() => _matchPageState();
}

class _matchPageState extends State<matchPage> {
  String imageLink;
  String name;
  goBack() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    userReference.doc(uid).get().then((doc) {
      Map userData = doc.data();
      // print('HERERER');
      // print(userData['DownloadUrl']);
      imageLinks[uid] = userData['DownloadUrl'];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('User')
            .where("User", isEqualTo: widget.currPersonId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            List docs = snapshot.data.docs; //fetches list of documents
            QueryDocumentSnapshot temp = docs[0]; //extracts user document
            name = temp["Name"];
            imageLink = temp["DownloadUrl"];

            return SafeArea(
                child: Scaffold(
              backgroundColor: primaryColor.withOpacity(0.92),
              body: Center(
                  child: Container(
                      child: Column(children: [
                Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.1,
                        horizontal: 30.0)),
                Text("damn..", style: pepperHeaderStyle),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RadialDecoration(
                      width: 30,
                      progressColor: Colors.white,
                      child: RoundedImage(
                        imagePath: imageLink,
                        size: Size.fromWidth(120),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  name + " liked you back!",
                  style: pepperNormalStyle,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "What are you waiting for?",
                  style: pepperNormalStyle,
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: FlatButton(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: startConvo,
                    child: Text("Start a convo",
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: FlatButton(
                    color: primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 65),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: goBack,
                    child: Text("Continue swiping",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                  // child: LoginButton("Start a convo now", Icons.message, goBack,
                  //     Color(0xfffe3c72), Colors.black),
                ),
              ]))),
            ));
          }
        });
  }

  void startConvo() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => chatPage(widget.currPersonId, imageLink, name)),
    );
  }
}
