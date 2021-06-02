import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/blocs/auth_bloc.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
// Responsible for logging in/out of account
import 'login.dart';
// Navigate through the different tabs
import 'editPage.dart';
import 'chatPage.dart';
import 'homePage.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:ff_navigation_bar/ff_navigation_bar.dart';
// import 'package:custom_navigation_bar/custom_navigation_bar.dart';

final List<Widget> _children = [editPage(), homePage(), chatPage];
// Widget homePage = Column(children: [
//   Expanded(
//     child: MyRow(),
//   ),
//   Expanded(
//     child: MyRow(),
//   )
// ]);

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StreamSubscription<User> homeStateSubscription;

  final _auth = FirebaseAuth.instance;
  User loggedInUser; //Firebase user
  @override
  void initState() {
    // TODO: implement initState
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    homeStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser == null) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    homeStateSubscription.cancel();
    super.dispose();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  int _selectedTab = 1;

  void _handleIndexChanged(int i) {
    setState(() {
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
        body: _children[_selectedTab],

        //renders the page based on the icon
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
