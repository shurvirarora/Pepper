import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:myapp/commons/my_info.dart';
import 'package:myapp/commons/profile_info_big_card.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:myapp/blocs/auth_bloc.dart';
import 'login.dart';
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

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Stack(
                  children: <Widget>[
                    OpaqueImage(
                      imageUrl: "assets/images/charli.jpg",
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(35),
                        child: Column(
                          children: [
                            Align(
                              //alignment: Alignment.centerLeft,
                              child: Text(
                                "My Profile",
                                textAlign: TextAlign.center,
                                style: headingTextStyle,
                              ),
                            ),
                            MyInfo(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                    color: primaryColor,
                    child: Table(children: [
                      TableRow(children: [
                        ProfileInfoBigCard(
                            firstText: "13",
                            secondText: "New Matches",
                            icon: Icon(
                              FontAwesomeIcons.heart,
                              color: secondaryColor,
                            )),
                      ]),
                      TableRow(children: [
                        ProfileInfoBigCard(
                            firstText: "2",
                            secondText: "Groups",
                            icon: Icon(
                              FontAwesomeIcons.users,
                              color: secondaryColor,
                            )),
                      ])
                    ])),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  var authBloc = Provider.of<AuthBloc>(context);
  return Column(children: [
    Container(
      child: OutlinedButton(
          child: Text('Log Out'), onPressed: () => authBloc.logout()),
    ),
  ]);
}

Widget buildTextField(String labelText, String placeholder) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 35.0),
    child: TextField(
      obscureText: false,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
            const Radius.circular(15.0),
          )),
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          )),
    ),
  );
}
