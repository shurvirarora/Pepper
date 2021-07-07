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

class chatPage extends StatefulWidget {
  String userID;
  String imgUrl;
  chatPage(this.userID, this.imgUrl);
  @override
  _chatPageState createState() => _chatPageState();
}

class _chatPageState extends State<chatPage> {
  TextEditingController messageController = TextEditingController();
  // String messageText;
  @override
  Widget build(BuildContext context) {
    var messageSnaps = Provider.of<DocumentSnapshot>(context, listen: false);
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Row(children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.imgUrl),
                ),
                SizedBox(width: 10),
                Text(
                  'Name',
                ),
              ]),
              centerTitle: true,
              leading: IconButton(
                  icon: Icon(FontAwesomeIcons.angleLeft),
                  onPressed: () => Navigator.pop(context)),
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
                    // List<String> messages = List.from(messageJson.map((e) =>
                    //     e['Text'])); //Stores a list of messages as strings
                    List<Text> text = List.from(messageJson.map((e) {
                      if (e != null) {
                        Text(e['Text']);
                      }
                    })); //Stores a list of text widgets
                    // print(text);
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
                            List fullListOfMessages =
                                messageJson + messageJson2;
                            List<String> listOfMessages = List.from(
                                fullListOfMessages.map((e) => e['Text']));

                            fullListOfMessages.sort((a, b) {
                              return a['Timestamp'].compareTo(b['Timestamp']);
                            });

                            // //Stores a list of messages as strings
                            // print(messages2);
                            // List<Widget> text2 = List.from(
                            //     fullListOfMessages.map((e) => Text(e['Text'])));
                            List<Widget> text2 = List.from(
                                fullListOfMessages.map((e) => ChatCard(
                                      widget.imgUrl,
                                      e['Text'],
                                      e['Timestamp'],
                                    )));
                            //Stores a list of text widgets
                            return Container(
                              color: Colors.white,
                              child: Center(
                                  child: Column(children: [
                                Expanded(
                                  child: ListView(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    children: text2,
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
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: messageController, keyboardType: TextInputType.text,
              // textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
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
    this.imageUrl,
    this.message,
    this.timeStamp,
    // this.press,
  );

  // final Chat chat;
  // final VoidCallback press;
  String imageUrl;
  var timeStamp;
  String message;

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
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10 * 0.75),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(imageUrl),
                ),
                // if (chat.isActive)
                // Positioned(
                //   right: 0,
                //   bottom: 0,
                //   child: Container(
                //     height: 16,
                //     width: 16,
                //     decoration: BoxDecoration(
                //       color: secondaryColor,
                //       shape: BoxShape.circle,
                //       border: Border.all(
                //           color: Theme.of(context).scaffoldBackgroundColor,
                //           width: 3),
                //     ),
                //   ),
                // )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   chat.name,
                    //   style:
                    //       TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    // ),
                    SizedBox(height: 8),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.64,
              child: Text(DateFormat.yMd().add_jm().format(date)),
            ),
          ],
        ),
      ),
    );
  }
}
