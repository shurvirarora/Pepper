import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/Decorations/constants.dart';
import 'package:myapp/services/triviaApi.dart';
import 'package:myapp/styleguide/colors.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// import '../Decorations/constants.dart';
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final User user = firebaseAuth.currentUser;
final String uid = user.uid.toString();

final messageCollection = FirebaseFirestore.instance.collection('Messages');
// String myImageUrl;
int numberOfMessages;
String otherPersonId;
Map qnIdTracker = Map();

class chatPage extends StatefulWidget {
  String userID;
  String imgUrl; //Person talking to
  String name;
  chatPage(this.userID, this.imgUrl, this.name);
  @override
  _chatPageState createState() => _chatPageState();
}

class _chatPageState extends State<chatPage> {
  TextEditingController messageController = TextEditingController();
  List<ChatCard> fullListOfMessages;
  @override
  void initState() {
    // TODO: implement initState
    otherPersonId = widget.userID;
    super.initState();
  }

  void onBack() {
    print(numberOfMessages);
    if (numberOfMessages != 0) {
      messageCollection.doc(uid).update({
        "Users": FieldValue.arrayUnion([widget.userID])
      });
    }
  }

  void handleClick(String category, BuildContext context) {
    Future<String> qnData = triviaApi.generateTrivia(category);

    qnData.then((data) {
      Future docRef = messageCollection.doc(uid).collection(widget.userID).add({
        'Text': data,
        'Trivia': true,
        'Timestamp': DateTime.now(),
        'Answer': 'none'
      });
      String qn = jsonDecode(data)['question'];
      docRef.then((value) => qnIdTracker[qn] = value.id);
      // print(docRef.id);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // var userSnaps = Provider.of<DocumentSnapshot>(context, listen: false);
    // Map data = userSnaps.data();
    // myImageUrl = data['DownloadUrl'];
    // print(userSnaps);
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor,
              title: Row(children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.imgUrl),
                ),
                SizedBox(width: 10),
                Text(
                  widget.name,
                ),
              ]),
              centerTitle: true,
              leading: IconButton(
                  icon: Icon(FontAwesomeIcons.angleLeft),
                  onPressed: () {
                    onBack();
                    print(fullListOfMessages.last.text);
                    Navigator.pop(context, fullListOfMessages.last.text);
                  }),
            ),
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

                    List<ChatCard> chatCardsMe = List.from(messageJson.map(
                        (e) => ChatCard(widget.imgUrl, e['Text'],
                            e['Timestamp'], true, e['Trivia'])));
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Messages')
                            .doc(widget.userID)
                            .collection(uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          } else {
                            List messageJson2 = List.of(snapshot.data.docs);

                            List<ChatCard> chatCardsTo = List.from(
                                messageJson2.map((e) => ChatCard(
                                    widget.imgUrl,
                                    e['Text'],
                                    e['Timestamp'],
                                    false,
                                    e['Trivia'])));

                            fullListOfMessages = chatCardsMe + chatCardsTo;
                            numberOfMessages = fullListOfMessages.length;
                            fullListOfMessages.sort((a, b) {
                              return a.time.compareTo(b.time);
                            });
                            return Container(
                              color: Colors.white,
                              child: Center(
                                  child: Column(children: [
                                Expanded(
                                  child: ListView(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    children: fullListOfMessages,
                                  ),
                                ),
                                messageComposer()
                              ])),
                            );
                          }
                        });
                  }
                })));
  }

  messageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.questionCircle),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Trivia category'),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListTile(
                              title: Text(GK),
                              onTap: () {
                                handleClick(GK, context);
                              }),
                          ListTile(
                              title: Text(EB),
                              onTap: () {
                                handleClick(EB, context);
                              }),
                          ListTile(
                              title: Text(EF),
                              onTap: () {
                                handleClick(EF, context);
                              }),
                          ListTile(
                              title: Text(EM),
                              onTap: () {
                                handleClick(EM, context);
                              }),
                          ListTile(
                              title: Text(EMT),
                              onTap: () {
                                handleClick(EMT, context);
                              }),
                          ListTile(
                              title: Text(ET),
                              onTap: () {
                                handleClick(ET, context);
                              }),
                          ListTile(
                              title: Text(EVG),
                              onTap: () {
                                handleClick(EVG, context);
                              }),
                          ListTile(
                              title: Text(EBG),
                              onTap: () {
                                handleClick(EBG, context);
                              }),
                          ListTile(
                              title: Text(SN),
                              onTap: () {
                                handleClick(SN, context);
                              }),
                          ListTile(
                              title: Text(SC),
                              onTap: () {
                                handleClick(SC, context);
                              }),
                          ListTile(
                              title: Text(SM),
                              onTap: () {
                                handleClick(GK, context);
                                ;
                              }),
                          ListTile(
                              title: Text(MYTH),
                              onTap: () {
                                handleClick(MYTH, context);
                              }),
                          ListTile(
                              title: Text(SPORTS),
                              onTap: () {
                                handleClick(SPORTS, context);
                              }),
                          ListTile(
                              title: Text(GEO),
                              onTap: () {
                                handleClick(GEO, context);
                              }),
                          ListTile(
                              title: Text(HISTORY),
                              onTap: () {
                                handleClick(HISTORY, context);
                              }),
                          ListTile(
                              title: Text(POL),
                              onTap: () {
                                handleClick(POL, context);
                              }),
                          ListTile(
                              title: Text(ART),
                              onTap: () {
                                handleClick(ART, context);
                              }),
                          ListTile(
                              title: Text(CELEB),
                              onTap: () {
                                handleClick(CELEB, context);
                              }),
                          ListTile(
                              title: Text(ANIMAL),
                              onTap: () {
                                handleClick(ANIMAL, context);
                              }),
                          ListTile(
                            title: Text(VEHICLES),
                            onTap: () => handleClick(VEHICLES, context),
                          ),
                          ListTile(
                              title: Text(ECOMICS),
                              onTap: () {
                                handleClick(ECOMICS, context);
                              }),
                          ListTile(
                              title: Text(SG),
                              onTap: () {
                                handleClick(SG, context);
                              }),
                          ListTile(
                              title: Text(EJ),
                              onTap: () {
                                handleClick(EJ, context);
                              }),
                          ListTile(
                              title: Text(ECARTOON),
                              onTap: () {
                                handleClick(ECARTOON, context);
                              }),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          Expanded(
            child: TextField(
              controller: messageController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: InputDecoration(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              // print("HEREREREERE");
              // print(DateTime.now());
              messageCollection.doc(uid).collection(widget.userID).add({
                'Text': messageController.text,
                'Trivia': false,
                'Timestamp': DateTime.now()
              });
              messageCollection.doc(widget.userID).update({
                "Users": FieldValue.arrayUnion([uid])
              });
              messageController.clear();
            },
          ),
        ],
      ),
    );
  }
}

class ChatCard extends StatelessWidget {
  ChatCard(
      this.imageUrl, this.message, this.timeStamp, this.isMe, this.isTrivia);
  bool isTrivia;
  String imageUrl;
  var timeStamp;
  String message;
  bool isMe; //Determines who is sender
//Trivia details
  String qn;
  String category;
  String answer;
  void clickTick() {
    String docId = qnIdTracker[qn];
    messageCollection
        .doc(uid)
        .collection(otherPersonId)
        .doc(docId)
        .update({'Answer': 'true'});
  }

  void clickCross() {
    String docId = qnIdTracker[qn];
    messageCollection
        .doc(uid)
        .collection(otherPersonId)
        .doc(docId)
        .update({'Answer': 'false'});
  }

  get time {
    return this.timeStamp;
  }

  get text => this.message;

  @override
  Widget build(BuildContext context) {
    print(isTrivia);
    var date = timeStamp.toDate();
    if (isTrivia) {
      qn = jsonDecode(message)['question'];
      category = jsonDecode(message)['category'];
      answer = jsonDecode(message)['correct_answer'];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10 * 0.75),
      child: !isTrivia
          ? Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child:
                  // if (!isMe)
                  //   CircleAvatar(radius: 20, backgroundImage: NetworkImage(imageUrl)),
                  // SizedBox(width: 8),
                  Container(
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(isMe ? 1 : 0.2),
                  borderRadius: isMe
                      ? BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          // bottomRight: Radius.circular(30)
                        )
                      : BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30),
                          // bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    children: [
                      Text(
                        message,
                      ),
                    ],
                  ),
                ),
              ),
              // Opacity(
              //   opacity: 0.64,
              //   child: Text(DateFormat.yMd().add_jm().format(date)),
              // ),
            )
          : Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 2.0,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  children: [
                    Text(
                      category,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      qn,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: clickCross,
                            icon: Icon(
                              FontAwesomeIcons.times,
                              color: Colors.red,
                            )),
                        IconButton(
                            onPressed: clickTick,
                            icon: Icon(
                              FontAwesomeIcons.checkCircle,
                              color: Colors.green,
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
