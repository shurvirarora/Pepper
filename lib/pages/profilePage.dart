import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/commons/additional_details_card.dart';

import 'package:myapp/commons/my_info.dart';
import 'package:myapp/commons/profile_info_big_card.dart';
import 'package:myapp/commons/profile_info_small_card.dart';
import 'package:myapp/pages/customisePage.dart';
import 'package:myapp/pages/editProfilePage.dart';
import 'package:myapp/styleguide/textstyle.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:myapp/blocs/auth_bloc.dart';
import 'loginPage.dart';
import 'package:myapp/styleguide/colors.dart';
import 'settingsPage.dart';
import '../models/User.dart';

//Gets user id
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final User user = firebaseAuth.currentUser;
final String uid = user.uid.toString();

class profilePage extends StatefulWidget {
  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  StreamSubscription<User> editStateSubscription;
  UserModel user;

  @override
  void initState() {
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

  // @override
  // Widget build(BuildContext context) {
  //   var authBloc = Provider.of<AuthBloc>(context);
  //   return Center(
  //     child: OutlineButton(
  //       padding: EdgeInsets.symmetric(horizontal: 118),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //       onPressed: () => authBloc.logout(),
  //       child: Text("SIGN OUT",
  //           style: TextStyle(
  //               fontSize: 16, letterSpacing: 2.2, color: Colors.black)),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('User')
            .where("User", isEqualTo: uid.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            List docs = snapshot.data.docs; //fetches list of documents
            QueryDocumentSnapshot temp = docs[0]; //extracts user document
            String name = temp["Name"];
            String aboutMe = temp["About Me"];
            String gender = temp["Gender"];
            String education = temp["Education"];
            String work = temp["Work"];
            int height = temp["Height"];
            int age = temp["Age"];
            String imageLink = temp["DownloadUrl"];
            user = UserModel(
                age, height, aboutMe, education, imageLink, gender, name, work);
            // if(snapshot.hasData){s
            return ListView(children: [
              Container(
                decoration: BoxDecoration(gradient: colorGradient),
                //color: primaryColor,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(20, 20, 10, 0),
                child: Text(
                  "My Profile",
                  style: whiteNameTextStyle,
                ),
              ),
              Container(
                decoration: BoxDecoration(gradient: colorGradient),
                //color: primaryColor,
                child: Padding(
                  child: imageLink != null
                      ? MyInfo(user)
                      : CircularProgressIndicator(),
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 5),
                ),
              ),
              Container(
                  decoration: BoxDecoration(gradient: colorGradient),
                  //color: secondaryColor,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      // Table(children: [
                      //   TableRow(children: [
                      //     ProfileInfoBigCard(
                      //         firstText: "13",
                      //         secondText: "New Matches",
                      //         icon: Icon(
                      //           FontAwesomeIcons.heart,
                      //           color: primaryColor,
                      //         )),
                      //     ProfileInfoBigCard(
                      //         firstText: "2",
                      //         secondText: "Groups",
                      //         icon: Icon(
                      //           FontAwesomeIcons.users,
                      //           color: primaryColor,
                      //         )),
                      //   ]),
                      // ]),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(color: secondaryColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Table(children: [
                        TableRow(children: [
                          ProfileInfoSmallCard(
                              iconPadding: EdgeInsets.fromLTRB(200, 10, 0, 10),
                              text: "Preferences",
                              icon: Icon(
                                FontAwesomeIcons.slidersH,
                                color: primaryColor,
                                size: 20,
                              )),
                        ]),
                        TableRow(children: [
                          ProfileInfoSmallCard(
                              iconPadding: EdgeInsets.fromLTRB(170, 10, 0, 10),
                              text: "Curated for you",
                              icon: Icon(
                                FontAwesomeIcons.lightbulb,
                                color: primaryColor,
                                size: 20,
                              )),
                        ]),

                        TableRow(children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => settingsPage(),
                                ),
                              );
                            },
                            child: ProfileInfoSmallCard(
                              iconPadding: EdgeInsets.fromLTRB(225, 10, 0, 10),
                              text: "Settings",
                              icon: Icon(
                                FontAwesomeIcons.cog,
                                color: primaryColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ]),

                        // TableRow(children: [
                        //   ProfileInfoSmallCard(
                        //       text: aboutMe,
                        //       icon: Icon(
                        //         FontAwesomeIcons.genderless,
                        //         color: secondaryColor,
                        //         size: 20,
                        //       )),
                        // ]),
                      ]),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ))
            ]);
          }
        });
  }
}
