import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';

class homePage extends StatefulWidget {
  // const homePage({ Key? key }) : super(key: key);

  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> with TickerProviderStateMixin {
  List<String> welcomeImages = [
    "images/image1.jpg",
    "images/image2.jpg",
    "images/kpop.png",
    "images/puppy.png",
    "images/selena.png",
  ];

  @override
  Widget build(BuildContext context) {
    CardController controller;
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      child: new TinderSwapCard(
        allowVerticalMovement: true,
        swipeUp: true,
        swipeDown: false,
        orientation: AmassOrientation.BOTTOM,
        totalNum: welcomeImages.length,
        stackNum: 3,
        swipeEdge: 4.0,
        maxWidth: MediaQuery.of(context).size.width * 1,
        maxHeight: MediaQuery.of(context).size.width * 2.2,
        minWidth: MediaQuery.of(context).size.width * 0.8,
        minHeight: MediaQuery.of(context).size.width * 0.8,
        cardBuilder: (context, index) => Card(
          child: Image.asset('${welcomeImages[index]}'),
        ),
        cardController: controller = CardController(),
        swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
          /// Get swiping card's alignment
          if (align.x < 0) {
            //Card is LEFT swiping
          } else if (align.x > 0) {
            //Card is RIGHT swiping
          }
        },
        swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
          /// Get orientation & index of swiped card!
        },
      ),
    );
  }
}
