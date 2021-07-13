import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('User')
            .where("User", isEqualTo: uid.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            List docs = snapshot.data.docs; //fetches list of documents
            QueryDocumentSnapshot temp = docs[0]; //extracts user document
            String name = temp["Name"];
            // String aboutMe = temp["About Me"];
            // String gender = temp["Gender"];
            // String education = temp["Education"];
            // String work = temp["Work"];
            // int height = temp["Height"];
            // int age = temp["Age"];
            String imageLink = temp["DownloadUrl"];
            // if(snapshot.hasData){s SafeArea(
            return SafeArea(
                child: Scaffold(
              backgroundColor: primaryColor.withOpacity(0.9),
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
                Text("damn..", style: pepperHeaderStyle),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedImage(
                      imagePath: imageLink,
                      size: Size.fromWidth(120),
                    ),
                    // RoundedImage(
                    //   imagePath: imageLink,
                    //   size: Size.fromWidth(120),
                    // ),
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
                    onPressed: () {},
                    child: Text("Start a convo",
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                  // child: LoginButton("Start a convo now", Icons.message, goBack,
                  //     Color(0xfffe3c72), Colors.black),
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
}
