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

ElevatedButton Heartbutton = ElevatedButton(
  onPressed: () => liked(),
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

ElevatedButton CrossButton = ElevatedButton(
  onPressed: () => passed(),
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

void liked() {
  //Add liked user to likes
  print('Liked');
  controller.triggerRight();
  // collectionReference.doc(user.uid).set(data)
}

void passed() {
  print('Rejected');
  controller.triggerLeft();
}

CardController controller;

class swipePage extends StatefulWidget {
  // const homePage({ Key? key }) : super(key: key);

  @override
  _swipePageState createState() => _swipePageState();
}

List<dynamic> allData;

// List<DocumentReference> users = collectionReference.get().

// Future<void> getData() async {
//   // Get docs from collection reference
//   QuerySnapshot querySnapshot = await collectionReference.get();

//   // Get data from docs and convert map to List
//   allData = querySnapshot.docs.map((doc) => doc['DownloadUrl']).toList();

//   print(allData);
// }

Future<void> getData() async {
  // Get docs from collection reference
  QuerySnapshot querySnapshot = await collectionReference.get();

  // Get data from docs and convert map to List
  allData = querySnapshot.docs.map((doc) => doc.data()).toList();

  print(allData);
}

class _swipePageState extends State<swipePage> {
  // List<UserCard> welcomeImages = [
  //   //Images passed
  //   UserCard(Image.asset("assets/images/sample2.jpg")),
  //   UserCard(Image.asset("assets/images/image2.jpg"),
  //       userBio: 'lol', img2: Image.asset("assets/images/selena.jpg")),
  //   UserCard(Image.asset("assets/images/sample1.jpg"),
  //       img2: Image.asset("assets/images/image2.jpg"), userBio: 'hello'),
  //   UserCard(Image.asset("assets/images/selena.jpg"),
  //       userBio: 'asdfghjkl', img2: Image.asset("assets/images/sample3.jpg")),
  // ];

  @override
  Widget build(BuildContext context) {
    return myfuture();
  }

  List<UserCard> userCards(List<DocumentSnapshot> users) {
    List<UserCard> cards = [];
    for (DocumentSnapshot user in users) {
      // print(user['Age']);
      UserCard card = UserCard(
        (user['DownloadUrl']),
        age: user['Age'].toString(),
        education: user['Education'].toString(),
        gender: user['Gender'].toString(),
        work: user['Work'].toString(),
        aboutMe: user['About Me'].toString(),
        height: user['Height'].toString(),
      );
      // print(card.toString());
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
                      //Logic for swiping executed here
                      //Card is LEFT swiping
                      passed();
                    } else if (align.x > 10) {
                      //Card is RIGHT swiping
                      liked();
                    }
                  },
                  swipeCompleteCallback:
                      (CardSwipeOrientation orientation, int index) {
                    /// Get orientation & index of swiped card!
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

class UserCard extends StatefulWidget {
  // List<Widget> items;
  String img1;
  String age;
  String gender;
  String height;
  String education;
  String aboutMe;
  String work;

  UserCard(String img1,
      {String age,
      String gender,
      String height,
      String education,
      String aboutMe,
      String work}) {
    this.img1 = img1;
    this.age = age;
    this.gender = gender;
    this.height = height;
    this.education = education;
    this.aboutMe = aboutMe;
    this.work = work;
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
        Padding(padding: EdgeInsets.all(20.0), child: Heartbutton)
      ],
    )
  ]));
  // List<Widget> userData() {
  //   List<Widget> userData = [
  //     Text(widget.age),
  //     widget.img1,
  //     Text(widget.gender),
  //     Text(widget.height),
  //     Text(widget.aboutMe),
  //     Text(widget.education),
  //     Text(widget.work),
  //     TextButton(onPressed: () => getData(), child: Text("Retrieve user data"))
  //   ];
  //   return userData;
  // }

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
              secondText: 'Carefree',
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
