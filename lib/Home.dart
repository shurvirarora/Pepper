import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/blocs/auth_bloc.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/services/FirebaseServices.dart';
import 'package:myapp/styleguide/colors.dart';
import 'package:provider/provider.dart';
// Responsible for logging in/out of account
import 'pages/loginPage.dart';
// Navigate through the different
import 'pages/profilePage.dart';
import 'pages/messagePage.dart';
import 'pages/swipePage.dart';

// RESPONSIBLE FOR NAVIGATION BETWEEN THE 3 MAIN TABS
final List<Widget> _children = [profilePage(), swipePage(), messagePage()];

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

  AppBar myNav(int index) {
    if (index == 1) {
      return AppBar(
        leading: Container(
          margin: EdgeInsets.only(left: 6),
          padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
          child: Icon(FontAwesomeIcons.heart, size: 22.5, color: Colors.white),
        ),
        title: Login.myText('pepper', 30, 1.5, Colors.white, 'Righteous'),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 6),
            padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
            child: Icon(
              FontAwesomeIcons.slidersH,
              size: 22.5,
              color: Colors.white,
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: myNav(_selectedTab),
        body: _children[_selectedTab],

        //renders the page based on the icon
        bottomNavigationBar: DotNavigationBar(
          itemPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 17),
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
          curve: Curves.easeOutQuint,
          currentIndex: _selectedTab,
          onTap: _handleIndexChanged,
          // dotIndicatorColor: Colors.black,
          items: [
            DotNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 25,
              ),
              selectedColor: Color(0xfffe3c72),
            ),

            /// Home
            DotNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 25,
                ),
                selectedColor: Color(0xfffe3c72)),

            /// Search
            DotNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.comment,
                size: 25,
              ),
              selectedColor: Color(0xfffe3c72),
            ),

            /// Profile
          ],
        ),
      ),
    );
  }
}

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
              backgroundImage: AssetImage('assets/images/profilePic.jpg'),
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
              backgroundImage: AssetImage('assets/images/profilePic.jpg'),
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
