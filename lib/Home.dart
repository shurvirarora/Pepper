import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:ff_navigation_bar/ff_navigation_bar.dart';
// import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';

Widget homePage = Column(children: [
  Expanded(
    child: MyRow(),
  ),
  Expanded(
    child: MyRow(),
  )
]);

Widget editPage = Container(color: Colors.black);

Widget chatPage = Container(color: Colors.black);

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // var _selectedTab = _SelectedTab.home;
  int _selectedTab = 1;

  final List<Widget> _children = [editPage, homePage, chatPage];

  void _handleIndexChanged(int i) {
    setState(() {
      // _selectedTab = _SelectedTab.values[i];
      _selectedTab = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Login.myText('pepper', 36, 3, Color(0xfffe3c72), 'PoiretOne'),
          centerTitle: true,
          actions: [
            Icon(
              FontAwesomeIcons.pepperHot,
              size: 25,
              color: Color(0xfffe3c72),
            ),
          ],
        ),
        body: _children[_selectedTab], //renders the page based on the icon
        bottomNavigationBar: DotNavigationBar(
          itemPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          curve: Curves.easeOutQuint,
          currentIndex: _selectedTab,
          onTap: _handleIndexChanged,
          // dotIndicatorColor: Colors.black,
          items: [
            DotNavigationBarItem(
              icon: Icon(Icons.person),
              selectedColor: Color(0xfffe3c72),
            ),

            /// Home
            DotNavigationBarItem(
                icon: Icon(Icons.home), selectedColor: Color(0xfffe3c72)),

            /// Search
            DotNavigationBarItem(
              icon: Icon(Icons.message_outlined),
              selectedColor: Color(0xfffe3c72),
            ),

            /// Profile
          ],
        ),
      ),
    );
  }
}

// enum _SelectedTab { person, home, message_outlined }

class MyRow extends StatelessWidget {
  const MyRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            child: CircleAvatar(
              backgroundImage: AssetImage('images/profilePic.jpg'),
              radius: 115,
            ),
            margin: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffff9b90),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: CircleAvatar(
              backgroundImage: AssetImage('images/profilePic.jpg'),
              radius: 115,
            ),
            margin: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffff9b85),
            ),
          ),
        )
      ],
    );
  }
}
