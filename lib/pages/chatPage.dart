import 'dart:collection';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/Decorations/constants.dart';
import 'package:myapp/pages/loginPage.dart';
import 'package:myapp/services/triviaApi.dart';
import 'package:myapp/styleguide/colors.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final User user = firebaseAuth.currentUser;
final String uid = user.uid.toString();

final messageCollection = FirebaseFirestore.instance.collection('Messages');
// String myImageUrl;
int numberOfMessages;
String otherPersonId;
Map<String, String> imageLinks = Map();

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
    imageLinks[widget.userID] = widget.imgUrl;
    userCollection.doc(uid).get().then((doc) {
      Map userData = doc.data();
      // print('HERERER');
      // print(userData['DownloadUrl']);
      imageLinks[uid] = userData['DownloadUrl'];
    });
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

//Fetches trivia qn
  void handleClick(String category, BuildContext context) {
    Future<String> qnData = triviaApi.generateTrivia(category);

    qnData.then((data) {
      Future docRef = messageCollection.doc(uid).collection(widget.userID).add({
        'Text': data,
        'Trivia': true,
        'Timestamp': DateTime.now(),
        'True': [],
        'False': []
      });
    });
    Navigator.pop(context);
  }

  List helper(var a) {
    try {
      return List.of(a['True']);
    } catch (e) {
      return [];
    }
  }

  List helper2(var a) {
    try {
      return List.of(a['False']);
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // var userSnaps = Provider.of<DocumentSnapshot>(context, listen: false);
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
                    // print(fullListOfMessages.last.text);
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
                        (e) => ChatCard(
                            widget.imgUrl,
                            e.id,
                            e['Text'],
                            e['Timestamp'],
                            true,
                            e['Trivia'],
                            helper(e),
                            helper2(e))));
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
                                    e.id,
                                    e['Text'],
                                    e['Timestamp'],
                                    false,
                                    e['Trivia'],
                                    helper(e),
                                    helper2(e))));

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

Future<String> fetchImageUrl(String id) {
  userCollection.doc(id).get().then((doc) {
    if (doc.exists) {
      Map userData = doc.data();
      // print(userData['DownloadUrl']);
      return userData['DownloadUrl'];
    } else {
      print('Document doesnt exist!');
    }
  });
}

class ChatCard extends StatefulWidget {
  ChatCard(this.imageUrl, this.docId, this.message, this.timeStamp, this.isMe,
      this.isTrivia, this.selectedTrue, this.selectedFalse);
  bool isTrivia;
  String imageUrl;
  String docId;
  var timeStamp;
  String message;
  bool isMe;
  List selectedTrue;
  List selectedFalse;
  @override
  State<ChatCard> createState() => _ChatCardState();
  get text => this.message;
  get time {
    return this.timeStamp;
  }
}

class _ChatCardState extends State<ChatCard> {
  String qn;
  String category;
  String answer;
  bool falseCorrect;
  bool trueCorrect;
  bool falseChosenCorrectly = false;
  bool trueChosenCorrectly = false;

  void clickTick() {
    messageCollection
        .doc(uid)
        .collection(otherPersonId)
        .doc(widget.docId)
        .update({
      'True': FieldValue.arrayUnion([uid])
    });

    messageCollection
        .doc(otherPersonId)
        .collection(uid)
        .doc(widget.docId)
        .update({
      'True': FieldValue.arrayUnion([uid])
    });
    if (trueCorrect) {
      setState(() {
        trueChosenCorrectly = true;
      });
    }
  }

  void clickCross() {
    messageCollection
        .doc(uid)
        .collection(otherPersonId)
        .doc(widget.docId)
        .update({
      'False': FieldValue.arrayUnion([uid])
    });
    messageCollection
        .doc(otherPersonId)
        .collection(uid)
        .doc(widget.docId)
        .update({
      'False': FieldValue.arrayUnion([uid])
    });
    if (falseCorrect) {
      setState(() {
        falseChosenCorrectly = true;
      });
    }
  }

  @override
  void initState() {
    // print(widget.selectedTrue);
    if (widget.isTrivia) {
      qn = jsonDecode(widget.message)['question'];
      category = jsonDecode(widget.message)['category'];
      answer = jsonDecode(widget.message)['correct_answer'];
      if (answer == 'True') {
        trueCorrect = true;
        falseCorrect = false;
        if (widget.selectedTrue.length != 0) {
          trueChosenCorrectly = true;
        }
      } else {
        if (widget.selectedFalse.length != 0) {
          falseChosenCorrectly = true;
        }
        trueCorrect = false;
        falseCorrect = true;
      }
    }
    super.initState();
  }

  List<Widget> avatars(List uids) {
    // print(uids);
    // if (uids.isEmpty) {
    //   return [SizedBox()];
    // }
    List<Widget> avatars = [];
    for (String id in uids) {
      // print(id);
      // print(imageLinks[id]);

      avatars.add(Padding(
        padding: const EdgeInsets.only(left: 10),
        child: CircleAvatar(backgroundImage: NetworkImage(imageLinks[id])),
      ));
    }
    return avatars;
  }

  @override
  Widget build(BuildContext context) {
    var date = widget.timeStamp.toDate();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10 * 0.75),
      child: !widget.isTrivia
          ? Align(
              alignment:
                  widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
              child:
                  // if (!isMe)
                  //   CircleAvatar(radius: 20, backgroundImage: NetworkImage(imageUrl)),
                  // SizedBox(width: 8),
                  Container(
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(widget.isMe ? 1 : 0.2),
                  borderRadius: widget.isMe
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
                        widget.message,
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
                      style: triviaOptionsStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      qn,
                      style: triviaOptionsStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: clickTick,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        elevation: 2,
                        shadowColor: Colors.grey,
                        color: trueChosenCorrectly
                            ? Colors.green[400].withOpacity(0.9)
                            : Colors.white,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'True',
                              style: triviaOptionsStyle,
                            ),
                            widget.selectedTrue.length != 0
                                ? SizedBox(
                                    height: 75,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: widget.selectedTrue.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return Row(children: [
                                            avatars(widget.selectedTrue)[index]
                                          ]);
                                        }),
                                  )
                                : SizedBox(
                                    height: 75,
                                  )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: clickCross,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        elevation: 2,
                        shadowColor: Colors.grey,
                        color: falseChosenCorrectly
                            ? Colors.green[400].withOpacity(0.9)
                            : Colors.white,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'False',
                              style: triviaOptionsStyle,
                            ),
                            widget.selectedFalse.length != 0
                                ? SizedBox(
                                    height: 75,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: widget.selectedFalse.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return Row(children: [
                                            avatars(widget.selectedFalse)[index]
                                          ]);
                                        }),
                                  )
                                : SizedBox(
                                    height: 75,
                                  )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  TextStyle triviaOptionsStyle = TextStyle(
      fontWeight: FontWeight.w800, fontSize: 16, fontFamily: 'PoiretOne');
}
