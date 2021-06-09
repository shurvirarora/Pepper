import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_swipable/flutter_swipable.dart';
import 'Decorations/constants.dart';

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

void liked() {
  print('Liked');
}

void passed() {
  print('Rejected');
}

class swipePage extends StatefulWidget {
  // const homePage({ Key? key }) : super(key: key);

  @override
  _swipePageState createState() => _swipePageState();
}

class _swipePageState extends State<swipePage> {
  List<UserCard> welcomeImages = [
    UserCard(Image.asset("images/sample2.jpg")),
    UserCard(Image.asset("images/image2.jpg"),
        userBio: 'lol', img2: Image.asset("images/selena.jpg")),
    UserCard(Image.asset("images/sample1.jpg"),
        img2: Image.asset("images/image2.jpg"), userBio: 'hello'),
    UserCard(Image.asset("images/selena.jpg"),
        userBio: 'asdfghjkl', img2: Image.asset("images/sample3.jpg")),
  ];

  @override
  Widget build(BuildContext context) {
    CardController controller;
    return Container(
      padding: EdgeInsets.only(top: 10),
      height: MediaQuery.of(context).size.height * 1,
      child: new TinderSwapCard(
        allowVerticalMovement: false,
        swipeUp: false,
        swipeDown: false,
        orientation: AmassOrientation.TOP,
        totalNum: welcomeImages.length,
        stackNum: 3,
        swipeEdge: 4.0,
        maxWidth: MediaQuery.of(context).size.width * 1,
        maxHeight: MediaQuery.of(context).size.width * 2.2,
        minWidth: MediaQuery.of(context).size.width * 0.8,
        minHeight: MediaQuery.of(context).size.width * 0.8,
        cardBuilder: (context, index) => welcomeImages[index],
        cardController: controller = CardController(),
        swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
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
        swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
          /// Get orientation & index of swiped card!
        },
      ),
    );
  }
}

class UserCard extends StatefulWidget {
  // List<Widget> items;
  Image img1;
  Image img2;
  Image img3;
  Image img4;
  String userBio;

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

  UserCard(Image img1, {Image img2, Image img3, Image img4, String userBio}) {
    this.img1 = img1;
    this.userBio = userBio;
    this.img2 = img2;
    this.img3 = img3;
    this.img4 = img4;
  }

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  List<Widget> userData() {
    List<String> userText = [widget.userBio];
    List<Widget> userImages = [
      widget.img1,
      widget.img2,
      widget.img3,
      widget.img4
    ];

    List<Widget> filterImages;
    List<String> filterText;

    // Text name = Text(filterText[0]);
    // Image img1 = filterImages[0];
    List<Widget> userData = [widget.img1];

    // for (Widget w in userImages) {
    //   if (w != null) {
    //     print(w);
    //     filterImages.add(w);
    //   }
    // }

    // for (String w in userText) {
    //   if (w != null) {
    //     filterText.add(w);
    //   }
    // }

    return userData;
  }

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
          children: userData(),
        ),
      ),
    );
  }
}
