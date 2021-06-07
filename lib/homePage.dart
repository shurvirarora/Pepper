import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
// import 'package:flutter_swipable/flutter_swipable.dart';
import 'Decorations/constants.dart';

class swipePage extends StatefulWidget {
  // const homePage({ Key? key }) : super(key: key);

  @override
  _swipePageState createState() => _swipePageState();
}

class _swipePageState extends State<swipePage> {
  List<ScrollableCard> welcomeImages = [
    ScrollableCard([Image.asset("images/sample2.jpg")]),
    ScrollableCard(
        [Image.asset("images/image2.jpg"), Image.asset("images/selena.jpg")]),
    ScrollableCard(
        [Image.asset("images/sample1.jpg"), Image.asset("images/image2.jpg")]),
    ScrollableCard(
        [Image.asset("images/selena.jpg"), Image.asset("images/sample3.jpg")]),
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
  // final Image image1;
  // final Image image2;
  List<Widget> items;

  Container bottomProfile = Container(
      child: Column(children: [
    ElevatedButton.icon(
        onPressed: null, icon: Icon(Icons.ac_unit), label: Text('Like')),
  ]));

  // ScrollableCard(this.image1, {this.image2});
  ScrollableCard(List<Widget> items) {
    this.items = items;
    this.items.add(bottomProfile);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // child: Swipable(
      // Set the swipable widget
      child: Container(
        // color: Colors.red[100],
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(10),
        ),
        // padding: EdgeInsets.all(20),
        child: ListView(
          // child: Column(
          children: items,
        ),
      ),
      // ),

      //       child: Container(
      // child: DraggableScrollableSheet(
      //     expand: true,
      //     initialChildSize: 0.3,
      //     minChildSize: 0.1,
      //     maxChildSize: 0.8,
      //     builder: (context, scrollController) {
      //       return Container(
      //         color: Colors.red[100],
      //         child: ListView(
      //           controller: scrollController,
      //           children: [
      //             image1,
      //             image2,
      //           ],
      // ),
    );
    //       }),
    // )));
  }
}
