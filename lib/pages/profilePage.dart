import 'dart:async';
// import 'dart:js';
// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:myapp/commons/my_info.dart';
import 'package:myapp/commons/profile_info_big_card.dart';
import 'package:myapp/commons/profile_info_small_card.dart';
// import 'package:myapp/commons/radial_progress.dart';
// import 'package:myapp/commons/rounded_image.dart';
import 'package:myapp/pages/editProfilePage.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:myapp/blocs/auth_bloc.dart';
import 'loginPage.dart';
import 'package:myapp/styleguide/colors.dart';
// import 'package:myapp/styleguide/textstyle.dart';
// import 'package:myapp/commons/opaque_image.dart';
// import 'package:myapp/pages/editProfilePage.dart';

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
  // Map data;
  // String gender;
  // String aboutMe;
  // String education;
  // String work;
  // int height;
  // int age;

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

  // fetchData() {
  //   CollectionReference collectionReference =
  //       FirebaseFirestore.instance.collection('User');

  //   collectionReference
  //       .where("User", isEqualTo: uid.toString())
  //       .snapshots()
  //       .listen((snapshot) {
  //     setState(() {
  //       data = snapshot.docs[0].data();
  //       //Assigns data to local variables
  //       gender = data['Gender'];
  //       aboutMe = data['About Me'];
  //       education = data['Education'];
  //       work = data['Work'];
  //       height = data["Height"];
  //       age = data['Age'];
  //       // print(gender);
  //       // print(data.toString());
  //     });
  //   });
  // }

  // Stream<QuerySnapshot> dataStream() async*{
  //   CollectionReference collectionReference =
  //       FirebaseFirestore.instance.collection('User');

  //   return collectionReference
  //       .where("User", isEqualTo: uid.toString())
  //       .snapshots();
  // }

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);

    return ListView(
      children: [
        Container(
          color: primaryColor,
          child: Padding(
            child: MyInfo("Charlie Amelio", "12"),
            padding: EdgeInsets.fromLTRB(30, 30, 30, 5),
          ),
        ),
        Container(
          color: primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: primaryColor,
                    minimumSize: Size(1, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(width: 1.25, color: Colors.blue))),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => editProfile()),
                  );
                },
                child: Text('Edit Profile',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ],
          ),
        ),
        Container(
          color: primaryColor,
          child: myStream(),
        ),

        // FloatingActionButton(onPressed: fetchData),
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

  Widget myStream() {
    return StreamBuilder<QuerySnapshot>(
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
          String aboutMe = temp["About Me"];
          String gender = temp["Gender"];
          String education = temp["Education"];
          String work = temp["Work"];
          int height = temp["Height"];
          int age = temp["Age"];
          // if(snapshot.hasData){
          return Column(
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
                      firstText: aboutMe,
                      secondText: "About Me",
                      icon: Icon(
                        FontAwesomeIcons.info,
                        color: secondaryColor,
                      )),
                ]),
                TableRow(children: [
                  ProfileInfoSmallCard(
                      text: gender,
                      icon: Icon(
                        FontAwesomeIcons.genderless,
                        color: secondaryColor,
                        size: 20,
                      )),
                ]),
                TableRow(children: [
                  ProfileInfoSmallCard(
                      text: work,
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
                      text: height.toString(),
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
                      text: gender,
                      icon: Icon(
                        FontAwesomeIcons.genderless,
                        color: secondaryColor,
                        size: 20,
                      )),
                ]),
                TableRow(children: [
                  ProfileInfoSmallCard(
                      text: age.toString(),
                      icon: Icon(
                        FontAwesomeIcons.genderless,
                        color: secondaryColor,
                        size: 20,
                      )),
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
                TableRow(children: [
                  ProfileInfoSmallCard(
                      text: work,
                      icon: Icon(
                        FontAwesomeIcons.genderless,
                        color: secondaryColor,
                        size: 20,
                      )),
                ]),
              ]),
            ],
          );
        }
      },
    );
  }
}

//  return
//        ListView(
//         children: [
//           Container(
//             color: primaryColor,
//             child: Padding(
//               child: MyInfo(),
//               padding: EdgeInsets.all(30),
//             ),
//           ),
//           Container(
//             color: primaryColor,
//             child: Column(
//               children: [
//                 Table(children: [
//                   TableRow(children: [
//                     ProfileInfoBigCard(
//                         firstText: "13",
//                         secondText: "New Matches",
//                         icon: Icon(
//                           FontAwesomeIcons.heart,
//                           color: secondaryColor,
//                         )),
//                     ProfileInfoBigCard(
//                         firstText: "2",
//                         secondText: "Groups",
//                         icon: Icon(
//                           FontAwesomeIcons.users,
//                           color: secondaryColor,
//                         )),
//                   ]),
//                 ]),
//                 Table(children: [
//                   TableRow(children: [
//                     ProfileInfoBigCard(
//                         firstText: "Hellooooo",
//                         secondText: "About Me",
//                         icon: Icon(
//                           FontAwesomeIcons.info,
//                           color: secondaryColor,
//                         )),
//                   ]),
//                   TableRow(children: [
//                     ProfileInfoSmallCard(
//                         text: gender,
//                         icon: Icon(
//                           FontAwesomeIcons.genderless,
//                           color: secondaryColor,
//                           size: 20,
//                         )),
//                   ]),
//                   TableRow(children: [
//                     ProfileInfoSmallCard(
//                         text: work,
//                         icon: Icon(
//                           FontAwesomeIcons.graduationCap,
//                           color: secondaryColor,
//                           size: 20,
//                         )),
//                   ]),
//                   TableRow(children: [
//                     ProfileInfoBigCard(
//                         firstText: "Football, Tiktok Dances, Computer Science",
//                         secondText: "My Interests",
//                         icon: Icon(
//                           FontAwesomeIcons.info,
//                           color: secondaryColor,
//                         )),
//                   ]),
//                   TableRow(children: [
//                     ProfileInfoSmallCard(
//                         text: height.toString(),
//                         icon: Icon(
//                           FontAwesomeIcons.rulerVertical,
//                           color: secondaryColor,
//                           size: 20,
//                         )),
//                   ]),
//                   TableRow(children: [
//                     ProfileInfoSmallCard(
//                         text: "Looking for: Clout",
//                         icon: Icon(
//                           FontAwesomeIcons.search,
//                           color: secondaryColor,
//                           size: 20,
//                         )),
//                   ]),
//                   TableRow(children: [
//                     ProfileInfoSmallCard(
//                         text: gender,
//                         icon: Icon(
//                           FontAwesomeIcons.genderless,
//                           color: secondaryColor,
//                           size: 20,
//                         )),
//                   ]),
//                   TableRow(children: [
//                     ProfileInfoSmallCard(
//                         text: age.toString(),
//                         icon: Icon(
//                           FontAwesomeIcons.genderless,
//                           color: secondaryColor,
//                           size: 20,
//                         )),
//                   ]),
//                   TableRow(children: [
//                     ProfileInfoSmallCard(
//                         text: height.toString(),
//                         icon: Icon(
//                           FontAwesomeIcons.genderless,
//                           color: secondaryColor,
//                           size: 20,
//                         )),
//                   ]),
//                   TableRow(children: [
//                     ProfileInfoSmallCard(
//                         text: work,
//                         icon: Icon(
//                           FontAwesomeIcons.genderless,
//                           color: secondaryColor,
//                           size: 20,
//                         )),
//                   ]),
//                 ]),
//               ],
//             ),
//           ),
//           FloatingActionButton(onPressed: fetchData),
//           // ),
//           Column(children: [
//             Container(
//               child: OutlinedButton(
//                   child: Text('Log Out'), onPressed: () => authBloc.logout()),
//             ),
//           ]),
//         ],
//       )
//     ;
