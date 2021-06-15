import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:myapp/commons/my_info.dart';
import 'package:myapp/commons/profile_info_big_card.dart';
import 'package:myapp/commons/profile_info_small_card.dart';
import 'package:myapp/commons/radial_progress.dart';
import 'package:myapp/commons/rounded_image.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:myapp/blocs/auth_bloc.dart';
import 'loginPage.dart';
import 'package:myapp/styleguide/colors.dart';
import 'package:myapp/styleguide/textstyle.dart';
import 'package:myapp/commons/opaque_image.dart';

class profilePage extends StatefulWidget {
  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  StreamSubscription<User> editStateSubscription;

  @override
  void initState() {
    // TODO: implement initState
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    editStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser == null) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    editStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);

    return ListView(
      children: [
        Container(
          color: primaryColor,
          child: Padding(
            child: MyInfo(),
            padding: EdgeInsets.all(30),
          ),
        ),
        Container(
          color: primaryColor,
          child: Column(
            children: [
              Table(children: [
                TableRow(children: [
                  ProfileInfoBigCard(
                      firstText: "13",
                      secondText: "New Matches",
                      icon: Icon(
                        FontAwesomeIcons.heart,
                        color: secondaryColor,
                      )),
                  ProfileInfoBigCard(
                      firstText: "2",
                      secondText: "Groups",
                      icon: Icon(
                        FontAwesomeIcons.users,
                        color: secondaryColor,
                      )),
                ]),
              ]),
              Table(children: [
                TableRow(children: [
                  ProfileInfoBigCard(
                      firstText: "Hellooooo",
                      secondText: "About Me",
                      icon: Icon(
                        FontAwesomeIcons.info,
                        color: secondaryColor,
                      )),
                ]),
                TableRow(children: [
                  ProfileInfoSmallCard(
                      text: "Female",
                      icon: Icon(
                        FontAwesomeIcons.genderless,
                        color: secondaryColor,
                        size: 20,
                      )),
                ]),
                TableRow(children: [
                  ProfileInfoSmallCard(
                      text: "NUS",
                      icon: Icon(
                        FontAwesomeIcons.graduationCap,
                        color: secondaryColor,
                        size: 20,
                      )),
                ]),
                TableRow(children: [
                  ProfileInfoBigCard(
                      firstText: "Football, Tiktok Dances, Computer Science",
                      secondText: "My Interests",
                      icon: Icon(
                        FontAwesomeIcons.info,
                        color: secondaryColor,
                      )),
                ]),
                TableRow(children: [
                  ProfileInfoSmallCard(
                      text: "175cm",
                      icon: Icon(
                        FontAwesomeIcons.rulerVertical,
                        color: secondaryColor,
                        size: 20,
                      )),
                ]),
                TableRow(children: [
                  ProfileInfoSmallCard(
                      text: "Looking for: Clout",
                      icon: Icon(
                        FontAwesomeIcons.search,
                        color: secondaryColor,
                        size: 20,
                      )),
                ]),
                TableRow(children: [
                  ProfileInfoSmallCard(
                      text: "Female",
                      icon: Icon(
                        FontAwesomeIcons.genderless,
                        color: secondaryColor,
                        size: 20,
                      )),
                ]),
                TableRow(children: [
                  ProfileInfoSmallCard(
                      text: "Female",
                      icon: Icon(
                        FontAwesomeIcons.genderless,
                        color: secondaryColor,
                        size: 20,
                      )),
                ]),
                TableRow(children: [
                  ProfileInfoSmallCard(
                      text: "Female",
                      icon: Icon(
                        FontAwesomeIcons.genderless,
                        color: secondaryColor,
                        size: 20,
                      )),
                ]),
                TableRow(children: [
                  ProfileInfoSmallCard(
                      text: "Female",
                      icon: Icon(
                        FontAwesomeIcons.genderless,
                        color: secondaryColor,
                        size: 20,
                      )),
                ]),
              ]),
            ],
          ),
        ),
        // ),
        Column(children: [
          Container(
            child: OutlinedButton(
                child: Text('Log Out'), onPressed: () => authBloc.logout()),
          ),
        ]),
      ],
    );
  }
}
