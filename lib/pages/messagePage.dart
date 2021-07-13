import 'package:flutter/material.dart';
import 'package:myapp/pages/chatPage.dart';
import 'package:myapp/pages/chats_json.dart';
import 'package:myapp/pages/gamesPage.dart';
import 'package:provider/provider.dart';
import '../Decorations/constants.dart';
import 'package:myapp/styleguide/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chatPage.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final User user = firebaseAuth.currentUser;
final String uid = user.uid.toString();

CollectionReference collectionReference =
    FirebaseFirestore.instance.collection('Messages');
CollectionReference userReference =
    FirebaseFirestore.instance.collection('User');

class messagePage extends StatefulWidget {
  @override
  _messagePageState createState() => _messagePageState();
}

class _messagePageState extends State<messagePage> {
  bool _messagesHasBeenPressed = true;
  bool _gamesHasBeenPressed = false;
  List userList = [];
  List matchList = [];
  Map lastMessages = Map();

  @override
  Widget build(BuildContext context) {
    // var userSnaps = Provider.of<DocumentSnapshot>(context, listen: false);
    messageCollection.doc(uid).get().then((doc) {
      if (!doc.exists) {
        messageCollection.doc(uid).set({
          'Users': [],
        });
      }
    });
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: topTab(),
        body: _messagesHasBeenPressed ? messageScreen() : gamesPage());
  }

  Widget messageScreen() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // topTab(),
          SizedBox(
            height: 5,
          ),
          Divider(
            thickness: 0.8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 0, right: 8),
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5)),
              child: TextField(
                cursorColor: Colors.black.withOpacity(0.5),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    hintText: "Search ${matchList.length} Matches"),
              ),
            ),
          ),
          Divider(
            thickness: 0.8,
          ),
          SizedBox(
            height: 10,
          ), //Horizontal list of matches
          myMatches(),
          FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('Messages')
                  .doc(uid)
                  .get(),
              // ignore: missing_return
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                // List users = data['Users']; //fetches array if userIDs

                if (snapshot.hasData) {
                  userList = snapshot.data.get('Users');
                  print("TESTINGGGGGG");
                  print(userList);
                  return Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return messagesFuture(userList)[index];
                      },
                      itemCount: userList.length,
                    ),
                  );
                } else {
                  return CircularProgressIndicator(
                    backgroundColor: Colors.pink,
                  );
                }
              }),
        ]);
  }

  //Whole message row
  List messagesFuture(List userIds) {
    List myList = [];
    for (String id in userIds) {
      myList.add(FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('User')
              .doc(id.trim())
              .get(),
          builder: (BuildContext context, AsyncSnapshot secondSnapshot) {
            if (secondSnapshot.hasData) {
              var data = secondSnapshot.data.get('DownloadUrl');
              var name = secondSnapshot.data.get('Name');
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => chatPage(id, data, name)),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 5), //Spacing between messages
                  child: Row(children: [
                    Stack(
                      children: [
                        CircleAvatar(
                            radius: 30, backgroundImage: NetworkImage(data)),
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      //For name and last message
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name, //Name needs to be here
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                            //last message
                            width: MediaQuery.of(context).size.width - 135,
                            child: lastMessageFuture(id))
                      ],
                    )
                  ]),
                ),
              );
            } else {
              return CircularProgressIndicator(
                backgroundColor: Colors.pink,
              );
            }
          }));
    }
    return myList;
  }

  Widget lastMessageFuture(String user) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('Messages')
            .doc(uid)
            .collection(user)
            .orderBy('Timestamp', descending: true)
            .limit(1)
            .get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            // print('Error comes here');

            // print(snapshot.data.docs.length);
            List firstLastMessage =
                snapshot.data.docs.length == 0 ? [] : [snapshot.data.docs[0]];

            return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('Messages')
                    .doc(user)
                    .collection(uid)
                    .orderBy('Timestamp', descending: true)
                    .limit(1)
                    .get(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List secondLastMessage = snapshot.data.docs.length == 0
                        ? []
                        : [snapshot.data.docs[0]];
                    List combinedList = firstLastMessage + secondLastMessage;
                    combinedList.sort((a, b) {
                      return b['Timestamp'].compareTo(a['Timestamp']);
                    });

                    if (combinedList.isEmpty) {
                      return SizedBox();
                    } else {
                      lastMessages[user] = combinedList[0].data()['Text'];
                      return Text(
                        lastMessages[user],
                        style: TextStyle(
                            fontSize: 15, color: Colors.black.withOpacity(0.8)),
                        overflow: TextOverflow.ellipsis,
                      );
                    }
                  } else {
                    return CircularProgressIndicator(
                      backgroundColor: Colors.pink,
                    );
                  }
                });
          } else {
            return CircularProgressIndicator(
              backgroundColor: Colors.pink,
            );
          }
        });
  }

  Widget topTab() {
    return PreferredSize(
      preferredSize: Size.fromHeight(75),
      child: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                child: Text("Messages",
                    style: TextStyle(
                      fontSize: 18,
                      color: _messagesHasBeenPressed
                          ? primaryColor
                          : Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: () => {
                  setState(() {
                    _messagesHasBeenPressed = true;
                    _gamesHasBeenPressed = false;
                  })
                },
              ),
              Container(
                height: 25,
                width: 1,
                decoration:
                    BoxDecoration(color: Colors.black.withOpacity(0.15)),
              ),
              TextButton(
                child: Text("Games",
                    style: TextStyle(
                      fontSize: 18,
                      color: _gamesHasBeenPressed
                          ? primaryColor
                          : Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: () => {
                  setState(() {
                    _messagesHasBeenPressed = false;
                    _gamesHasBeenPressed = true;
                  })
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        // actions:
      ),
    );
  }

  Widget myMatches() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          "New Matches",
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w500, color: primaryColor),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      FutureBuilder(
          future:
              FirebaseFirestore.instance.collection('Swipes').doc(uid).get(),
          // ignore: missing_return
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // List users = data['Users']; //fetches array if userIDs
            if (snapshot.hasData) {
              matchList = snapshot.data.get('Matches');
              print("MATCCHESS!!");
              print(matchList);
              return Container(
                height: 50,
                // child: Expanded(
                child: ListView.builder(
                  scrollDirection:
                      Axis.horizontal, //causes Problem when horizontal
                  itemBuilder: (context, index) {
                    return listOfMatches(matchList)[index];
                  },
                  shrinkWrap: true,
                  itemCount: listOfMatches(matchList).length,
                ),
                // ),
              );
              // child: Padding(
              //     padding: const EdgeInsets.only(left: 15),
              //     child: Row(children: listOfMatches(matchList))));
            } else {
              return CircularProgressIndicator(
                backgroundColor: Colors.pink,
              );
            }
          }),
      SizedBox(
        height: 30,
      )
    ]);
  }

  List listOfMatches(List userIds) {
    List myList = [];
    // print(userIds.length);
    for (String id in userIds) {
      print(id);
      myList.add(FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('User')
              .doc(id.trim())
              .get(),
          builder: (BuildContext context, AsyncSnapshot secondSnapshot) {
            if (secondSnapshot.hasData) {
              var data = secondSnapshot.data.get('DownloadUrl');
              var name = secondSnapshot.data.get('Name');
              print(data);
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => chatPage(id, data, name)),
                ),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: NetworkImage(
                          //Add network Image here
                          data), fit: BoxFit.fitWidth)),
                ),
              );
            } else {
              return CircularProgressIndicator(
                backgroundColor: Colors.pink,
              );
            }
          }));
    }
    //Testing Horizontal ListViewScroll
    // testingImage(myList);
    // testingImage(myList);
    // testingImage(myList);
    // testingImage(myList);
    // testingImage(myList);
    // testingImage(myList);
    // testingImage(myList);
    // testingImage(myList);
    // testingImage(myList);
    print(myList.length);
    return myList;
  }

  Widget tempWidget() {
    return Row(
      children: <Widget>[
        Container(
          width: 70,
          height: 70,
          child: Stack(
            children: <Widget>[
              userMessages[1]['story']
                  ? Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: primaryColor, width: 3)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage(userMessages[1]['img']),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    )
                  : Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage(userMessages[1]['img']),
                              fit: BoxFit.cover)),
                    ),
              userMessages[1]['online']
                  ? Positioned(
                      top: 48,
                      left: 52,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3)),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              userMessages[1]['name'],
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 135,
              child: Text(
                userMessages[1]['message'] +
                    " - " +
                    userMessages[1]['created_at'],
                style: TextStyle(
                    fontSize: 15, color: Colors.black.withOpacity(0.8)),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget getBody() {
//Can use a convo ID instead , concatanate the userids tgt
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                child: Text("Messages",
                    style: TextStyle(
                      fontSize: 18,
                      color: _messagesHasBeenPressed
                          ? primaryColor
                          : Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: () => {
                  setState(() {
                    _messagesHasBeenPressed = true;
                    _gamesHasBeenPressed = false;
                  })
                },
              ),
              Container(
                height: 25,
                width: 1,
                decoration:
                    BoxDecoration(color: Colors.black.withOpacity(0.15)),
              ),
              TextButton(
                child: Text("Games",
                    style: TextStyle(
                      fontSize: 18,
                      color: _gamesHasBeenPressed
                          ? primaryColor
                          : Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: () => {
                  setState(() {
                    _messagesHasBeenPressed = false;
                    _gamesHasBeenPressed = true;
                  })
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 0.8,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 0, right: 8),
          child: Container(
            height: 38,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5)),
            child: TextField(
              cursorColor: Colors.black.withOpacity(0.5),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  hintText: "Search 0 Matches"),
            ),
          ),
        ),
        Divider(
          thickness: 0.8,
        ),
        SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                "New Matches",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: primaryColor),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                    children: List.generate(chats_json.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 70,
                          height: 70,
                          child: Stack(
                            children: <Widget>[
                              chats_json[index]['story']
                                  ? Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: primaryColor, width: 3)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Container(
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: AssetImage(chats_json[
                                                          index] //Add network Image here
                                                      ['img']),
                                                  fit: BoxFit.cover)),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 65,
                                      height: 65,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  chats_json[index]['img']),
                                              fit: BoxFit.cover)),
                                    ),
                              chats_json[index]['online']
                                  ? Positioned(
                                      top: 48,
                                      left: 52,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 3)),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 70,
                          child: Align(
                              child: Text(
                            chats_json[index]['name'],
                            overflow: TextOverflow.ellipsis,
                          )),
                        )
                      ],
                    ),
                  );
                })),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                children: List.generate(userMessages.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 70,
                          height: 70,
                          child: Stack(
                            children: <Widget>[
                              userMessages[index]['story']
                                  ? Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: primaryColor, width: 3)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Container(
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      userMessages[index]
                                                          ['img']),
                                                  fit: BoxFit.cover)),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 65,
                                      height: 65,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  userMessages[index]['img']),
                                              fit: BoxFit.cover)),
                                    ),
                              userMessages[index]['online']
                                  ? Positioned(
                                      top: 48,
                                      left: 52,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 3)),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              userMessages[index]['name'],
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 135,
                              child: Text(
                                userMessages[index]['message'] +
                                    " - " +
                                    userMessages[index]['created_at'],
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black.withOpacity(0.8)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }),
              ),
            )
          ],
        )
      ],
    );
  }
}

Widget testingImage(List myList) {
  myList.add(Container(
    width: 70,
    height: 70,
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: NetworkImage(
                //Add network Image here
                'https://images.unsplash.com/photo-1517841905240-472988babdf9?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8cGVvcGxlfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'),
            fit: BoxFit.fitWidth)),
  ));
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
