import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/commons/about_me_card.dart';
import 'package:myapp/commons/profile_info_big_card.dart';
import 'package:myapp/styleguide/colors.dart';
import '../styleguide/textstyle.dart';
// import 'package:flutter_swipable/flutter_swipable.dart';
import '../Decorations/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'matchPage.dart';

ElevatedButton CrossButton = ElevatedButton(
  onPressed: () => swipePage.passed(true),
  child: Icon(
    FontAwesomeIcons.times,
    size: 30,
  ),
  style: ElevatedButton.styleFrom(
    onPrimary: Color(0xfffe3c72),
    primary: Colors.white,
    shape: CircleBorder(),
    padding: EdgeInsets.all(20),
  ),
);
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final User user = firebaseAuth.currentUser;
final String uid = user.uid.toString();
CollectionReference collectionReference =
    FirebaseFirestore.instance.collection('User');
CollectionReference swipeCollection =
    FirebaseFirestore.instance.collection('Swipes');

CardController controller;

class swipePage extends StatefulWidget {
  // const homePage({ Key? key }) : super(key: key);
  static String currID;
  static int currIndex = 0;
  @override
  _swipePageState createState() => _swipePageState();

  static void liked(bool swipe, BuildContext context) {
    print('Liked');
    if (swipe) {
      controller.triggerRight();
    }
    bool isMatched = false;
    final String currPersonId = UserIds[swipePage.currIndex];
    Future<DocumentSnapshot> otherdocument =
        swipeCollection.doc(currPersonId).get();
    Future<DocumentSnapshot> document = swipeCollection.doc(user.uid).get();
    document.then((doc) {
      //Swiping User's doc exists
      if (doc.exists) {
        swipeCollection.doc(currPersonId).get().then((doc) {
          //Other User's doc exists
          if (doc.exists) {
            if (List.from(doc['Likes']).contains(uid)) {
              //Other user like you
              print("ITS A MATCH!!!!!");
              isMatched = true;
              swipeCollection.doc(currPersonId).update({
                "Matches": FieldValue.arrayUnion([uid])
              });
              swipeCollection.doc(user.uid).update({
                "Matches": FieldValue.arrayUnion([currPersonId])
              }).then((value) {
                // swipePage.currIndex += 1;
                print(currPersonId);
                Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (_, __, ___) => matchPage(),
                  ),
                );
                //Still doesnt stop the function from continuing
              });
            }
          }
        });
      }
    });
    print(isMatched);
    if (isMatched) {
      print("GoesHere");
      return;
    }
    document.then((doc) {
      if (doc.exists) {
        swipeCollection.doc(user.uid).update({
          "Likes": FieldValue.arrayUnion([currPersonId])
        }).then((value) {
          swipePage.currIndex += 1;
          print(currPersonId);
        });
      } else {
        //Userid doesnt exits so create a doc and add to likes
        print("Doesnt Exists");
        swipeCollection.doc(user.uid).set({
          'Likes': [currPersonId],
          'Dislikes': [],
          'Matches': []
        });
        swipeCollection.doc(currPersonId).get().then((doc) {
          //Check if Other User likes you
          if (doc.exists) {
            if (List.from(doc['Likes']).contains(uid)) {
              print("ITS A MATCH!!!!!");
              //Add your userid in other persons matches list
              swipeCollection.doc(currPersonId).update({
                "Matches": FieldValue.arrayUnion([uid])
              });
              swipeCollection.doc(user.uid).update({
                "Matches": FieldValue.arrayUnion([currPersonId])
              }).then((value) {
                swipePage.currIndex += 1;
                print(currPersonId);
                Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: false, // set to false
                    pageBuilder: (_, __, ___) => matchPage(),
                  ),
                );
                //Still doesnt stop the function from continuing
              });
            }
          }
        });
      }
    });
  }

  static void passed(bool swipe) {
    print('Rejected');
    if (swipe) {
      controller.triggerLeft();
    }
    CollectionReference swipeCollection =
        FirebaseFirestore.instance.collection('Swipes');
    Future<DocumentSnapshot> document = swipeCollection.doc(user.uid).get();
    document.then((doc) {
      if (doc.exists) {
        print(UserIds[swipePage.currIndex]);
        swipeCollection.doc(user.uid).update({
          "Dislikes": FieldValue.arrayUnion([UserIds[swipePage.currIndex]])
        }).then((value) => swipePage.currIndex += 1);
      } else {
        //Userid doesnt exits so create a doc
        print("Doesnt Exists");
        swipeCollection.doc(user.uid).set({
          'Likes': [],
          'Dislikes': [UserIds[swipePage.currIndex]],
          'Matches': []
        }).then((value) => swipePage.currIndex += 1);
      }
    });
  }
}

List<dynamic> allData;

class _swipePageState extends State<swipePage> {
  @override
  Widget build(BuildContext context) {
    return myfuture();
  }

  List<UserCard> userCards(List<DocumentSnapshot> users) {
    List<UserCard> cards = [];
    for (DocumentSnapshot user in users) {
      UserCard card = UserCard(
        (user['DownloadUrl']),
        age: user['Age'].toString(),
        education: user['Education'].toString(),
        gender: user['Gender'].toString(),
        work: user['Work'].toString(),
        aboutMe: user['About Me'].toString(),
        height: user['Height'].toString(),
        id: user['User'].toString(),
      );
      cards.add(card);
    }
    return cards;
  }

  Widget myfuture() {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('User').get(),
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List users = snapshot.data.docs; //Stores list of users
            List<UserCard> cardList = userCards(users);
            if (snapshot.data != null) {
              return Container(
                padding: EdgeInsets.only(top: 10),
                height: MediaQuery.of(context).size.height * 1,
                child: new TinderSwapCard(
                  allowVerticalMovement: false,
                  swipeUp: false,
                  swipeDown: false,
                  orientation: AmassOrientation.TOP,
                  totalNum: cardList.length,
                  stackNum: 3,
                  swipeEdge: 4.0,
                  maxWidth: MediaQuery.of(context).size.width * 1,
                  maxHeight: MediaQuery.of(context).size.width * 2.2,
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  minHeight: MediaQuery.of(context).size.width * 0.8,
                  cardBuilder: (context, index) => cardList[index],
                  cardController: controller = CardController(),
                  swipeUpdateCallback:
                      (DragUpdateDetails details, Alignment align) {
                    /// Get swiping card's alignment
                    if (align.x < -10) {
                      //Card is LEFT swiping

                    } else if (align.x > 10) {
                      //Card is RIGHT swiping

                    }
                  },
                  swipeCompleteCallback:
                      (CardSwipeOrientation orientation, int index) {
                    /// Get orientation & index of swiped card!

                    // print(orientation.index);
                    if (orientation == CardSwipeOrientation.LEFT) {
                      swipePage.passed(false);
                      print(swipePage.currIndex.toString() + ' in');
                    }
                    if (orientation == CardSwipeOrientation.RIGHT) {
                      swipePage.liked(false, context);
                      print(swipePage.currIndex.toString() + ' in');
                    }

                    ///
                  },
                ),
              );
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

List<String> UserIds = [];

class UserCard extends StatefulWidget {
  String img1;
  String age;
  String gender;
  String height;
  String education;
  String aboutMe;
  String work;
  String id;
  UserCard(String img1,
      {String age,
      String gender,
      String height,
      String education,
      String aboutMe,
      String work,
      String id}) {
    this.img1 = img1;
    this.age = age;
    this.gender = gender;
    this.height = height;
    this.education = education;
    this.aboutMe = aboutMe;
    this.work = work;
    this.id = id;
    if (!UserIds.contains(id)) {
      UserIds.add(id);
    }
    print(UserIds);
  }

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  Container bottomProfile = Container(

      //Contains like and pass buttons
      child: Column(children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(padding: EdgeInsets.all(20.0), child: CrossButton),
        Padding(padding: EdgeInsets.all(20.0), child: HeartButton())
      ],
    )
  ]));

  List<Widget> newData() {
    List<String> userText = [widget.aboutMe];
    List<Widget> newList = [
      Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(widget.img1),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 0.5),
            ],
            gradient: LinearGradient(
              colors: [Colors.black12, Colors.black87],
              begin: Alignment.center,
              stops: [0.4, 1],
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 10,
                left: 10,
                bottom: 10,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    basicUserInfo(user: user),
                  ],
                ),
              ),
              //if (isUserInFocus) buildLikeBadge(swipingDirection)
            ],
          ),
        ),
      ),
    ];
    for (String text in userText) {
      if (text != 'null') {
        if (text == widget.aboutMe) {
          newList.add(
            AboutMeCard(
              firstText: 'About Me',
              secondText: widget.aboutMe,
              icon: Icon(
                Icons.info,
                color: primaryColor,
              ),
            ),
          );
          continue;
        }
        newList.add(Card(
          color: Color(0xffdee2ff),
          // shadowColor: Colors.pink[500],
          child: Text(
            text,
            style: SwipingProfileText,
          ),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          margin: EdgeInsets.all(10),
        ));
      }
    }
    newList.add(bottomProfile);
    return newList;
  }

  Widget basicUserInfo({@required User user}) => Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${widget.gender}, ${widget.age}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(FontAwesomeIcons.graduationCap,
                    size: 12, color: Colors.white),
                Padding(padding: EdgeInsets.all(5)),
                Text(
                  '${widget.education}',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(FontAwesomeIcons.briefcase, size: 12, color: Colors.white),
                Padding(padding: EdgeInsets.all(5)),
                Text(
                  '${widget.work} ',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // child: Swipable(
      // Set the swipable widget
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        // padding: EdgeInsets.all(20),
        child: ListView(
          // child: Column(
          children: newData(),
        ),
      ),
    );
  }
}

class HeartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => swipePage.liked(true, context),
      child: Icon(
        FontAwesomeIcons.heart,
        size: 30,
      ),
      style: ElevatedButton.styleFrom(
        onPrimary: Color(0xff44d083),
        primary: Colors.white,
        shape: CircleBorder(),
        padding: EdgeInsets.all(20),
      ),
    );
  }
}
