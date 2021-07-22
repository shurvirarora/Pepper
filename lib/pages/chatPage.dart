import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  void onBack() {
    print('Here');
    print(numberOfMessages);
    if (numberOfMessages != 0) {
      messageCollection.doc(uid).update({
        "Users": FieldValue.arrayUnion([widget.userID])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // var userSnaps = Provider.of<DocumentSnapshot>(context, listen: false);
    // Map data = userSnaps.data();
    // myImageUrl = data['DownloadUrl'];
    // print(userSnaps);
    return SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.0),
              child: AppBar(
                leading: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.angleLeft,
                        size: 30,
                      ),
                      onPressed: () {
                        onBack();
                        Navigator.pop(context);
                      }),
                ),
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.imgUrl),
                    ),
                    SizedBox(width: 10),
                    Text(
                      widget.name,
                    ),
                  ]),
                ),
              ),
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
                            widget.imgUrl, e['Text'], e['Timestamp'], true)));
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
                                messageJson2.map((e) => ChatCard(widget.imgUrl,
                                    e['Text'], e['Timestamp'], false)));

                            List<ChatCard> fullListOfMessages =
                                chatCardsMe + chatCardsTo;
                            numberOfMessages = fullListOfMessages.length;
                            fullListOfMessages.sort((a, b) {
                              return a.time.compareTo(b.time);
                            });
                            return Container(
                              color: Colors.white,
                              child: Center(
                                  child: Column(children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: ListView(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    children: fullListOfMessages,
                                  ),
                                ),
                                messageComposer(),
                                SizedBox(
                                  height: 5,
                                )
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
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
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
  ChatCard(this.imageUrl, this.message, this.timeStamp, this.isMe);

  String imageUrl;
  var timeStamp;
  String message;
  bool isMe;

  get time {
    return this.timeStamp;
  }

  @override
  Widget build(BuildContext context) {
    var date = timeStamp.toDate();
    // print(DateFormat.jm().format(date));
//     int timeInMillis = 1586348737122;
// var date = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
// var formattedDate = DateFormat.yMMMd().format(date); // Apr 8, 2020
    return InkWell(
      onTap: null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10 * 0.5),
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isMe)
              //CircleAvatar(radius: 20, backgroundImage: NetworkImage(imageUrl)),
              SizedBox(width: 5),
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
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  // crossAxisAlignment:
                  //     isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  children: [
                    // Text(
                    //   'Name',
                    //   style:
                    //       TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    // ),
                    // SizedBox(height: 8),

                    Text(
                      message,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            // Opacity(
            //   opacity: 0.64,
            //   child: Text(DateFormat.yMd().add_jm().format(date)),
            // ),
          ],
        ),
      ),
    );
  }
}
