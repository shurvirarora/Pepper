import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/styleguide/colors.dart';
import 'package:provider/provider.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final User user = firebaseAuth.currentUser;
final String uid = user.uid.toString();

class chatPage extends StatefulWidget {
  String userID;
  String imgUrl;
  chatPage(this.userID, this.imgUrl);
  @override
  _chatPageState createState() => _chatPageState();
}

class _chatPageState extends State<chatPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Messages')
                .doc(uid)
                .collection(widget.userID)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                List messageJson = List.of(snapshot.data.docs);
                List<String> messages = List.from(messageJson.map(
                    (e) => e['Text'])); //Stores a list of messages as strings
                List<Text> text = List.from(messageJson.map(
                    (e) => Text(e['Text']))); //Stores a list of text widgets
                print(text);
                return Container(
                  color: Colors.white,
                  child: Center(
                      child: Column(
                    children: text,
                  )),
                );
                ;
              }
            }),
      ),
    );
  }
}
