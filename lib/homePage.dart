import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:flutter_swipable/flutter_swipable.dart';

class homePage extends StatefulWidget {
  // const homePage({ Key? key }) : super(key: key);

  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  List<ScrollableCard> welcomeImages = [
    ScrollableCard(
        Image.asset("images/selena.jpg"), Image.asset("images/image2.jpg")),
    ScrollableCard(
        Image.asset("images/image2.jpg"), Image.asset("images/selena.jpg")),
    ScrollableCard(
        Image.asset("images/kpop.png"), Image.asset("images/image2.jpg")),
    ScrollableCard(
        Image.asset("images/selena.jpg"), Image.asset("images/kpop.png")),
  ];

  @override
  Widget build(BuildContext context) {
    CardController controller;
    return Container(
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

class ScrollableCard extends StatelessWidget {
  // Made to distinguish cards
  // Add your own applicable data here
  // final Color color;
  // Card(this.color);
  final Image image1;
  final Image image2;

  ScrollableCard(this.image1, this.image2);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Swipable(
            // Set the swipable widget

            child: DraggableScrollableSheet(
                expand: true,
                initialChildSize: 1.0,
                minChildSize: 0.1,
                maxChildSize: 1.0,
                builder: (context, scrollController) {
                  return ListView(
                    controller: scrollController,
                    children: [
                      image1,
                      image2,
                    ],
                  );
                })));
  }

  // onSwipeRight, left, up, down, cancel, etc...
}
