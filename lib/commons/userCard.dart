import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/services/FirebaseServices.dart';
import 'package:myapp/styleguide/colors.dart';
import 'about_me_card.dart';
import 'additional_details_card.dart';

final User user = firebaseAuth.currentUser;

class UserCard extends StatefulWidget {
  String img1;
  String name;
  String age;
  String gender;
  String height;
  String education;
  String aboutMe;
  String work;
  String id;
  UserCard(String img1,
      {String name,
      String age,
      String gender,
      String height,
      String education,
      String aboutMe,
      String work,
      String id}) {
    this.img1 = img1;
    this.name = name;
    this.age = age;
    this.gender = gender;
    this.height = height;
    this.education = education;
    this.aboutMe = aboutMe;
    this.work = work;
    this.id = id;
    // if (!UserIds.contains(id)) {
    //   UserIds.add(id);
    // }
    // print(UserIds);
  }

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  // Container bottomProfile = Container(

  //     //Contains like and pass buttons
  //     child: Column(children: [
  //   Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Padding(padding: EdgeInsets.all(20.0), child: CrossButton),
  //       Padding(padding: EdgeInsets.all(20.0), child: HeartButton())
  //     ],
  //   )
  // ]));

  List<Widget> newData() {
    List<String> userText = [widget.aboutMe];
    List<Widget> newList = [
      Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(widget.img1),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 0.5),
            ],
            gradient: LinearGradient(
              colors: [Colors.black12, Colors.black87],
              begin: Alignment.center,
              stops: [0.4, 1],
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 10,
                left: 10,
                bottom: 10,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    basicUserInfo(user: user),
                  ],
                ),
              ),
              //if (isUserInFocus) buildLikeBadge(swipingDirection)
            ],
          ),
        ),
      ),
    ];
    for (String text in userText) {
      if (text != 'null') {
        if (text == widget.aboutMe) {
          newList.add(
            AboutMeCard(
              firstText: 'About Me',
              secondText: widget.aboutMe,
              icon: Icon(
                Icons.info,
                color: primaryColor,
              ),
            ),
          );
          //continue;
        }
        // newList.add(Card(
        //   color: Color(0xffdee2ff),
        //   // shadowColor: Colors.pink[500],
        //   child: Text(
        //     text,
        //     style: SwipingProfileText,
        //   ),
        //   elevation: 3,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(30),
        //   ),
        //   margin: EdgeInsets.all(10),
        // ));
      }
    }
    if (widget.age != 'null') {
      newList.add(
        AdditionalDetailsCard(
          age: widget.age.toString(),
          ageIcon: Icon(
            FontAwesomeIcons.birthdayCake,
            color: secondaryColor,
            size: 18,
          ),
          gender: widget.gender,
          genderIcon: Icon(
            FontAwesomeIcons.genderless,
            color: secondaryColor,
            size: 18,
          ),
          height: widget.height.toString(),
          heightIcon: Icon(
            FontAwesomeIcons.rulerVertical,
            color: secondaryColor,
            size: 18,
          ),
          lookingFor: null,
          lookingForIcon: Icon(
            FontAwesomeIcons.search,
            color: secondaryColor,
            size: 18,
          ),
          location: widget.work,
          locationIcon: Icon(
            FontAwesomeIcons.mapMarkerAlt,
            color: secondaryColor,
            size: 18,
          ),
          education: widget.education,
          educationIcon: Icon(
            FontAwesomeIcons.graduationCap,
            color: secondaryColor,
            size: 18,
          ),
          work: widget.work,
          workIcon: Icon(
            FontAwesomeIcons.briefcase,
            color: secondaryColor,
            size: 18,
          ),
        ),
      );
    }
    // newList.add(bottomProfile);
    return newList;
  }

  Widget basicUserInfo({@required User user}) => Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${widget.name}, ${widget.age}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(FontAwesomeIcons.graduationCap,
                    size: 12, color: Colors.white),
                Padding(padding: EdgeInsets.all(5)),
                Text(
                  '${widget.education}',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(FontAwesomeIcons.briefcase, size: 12, color: Colors.white),
                Padding(padding: EdgeInsets.all(5)),
                Text(
                  '${widget.work} ',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // child: Swipable(
      // Set the swipable widget
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        // padding: EdgeInsets.all(20),
        child: ListView(
          // child: Column(
          children: newData(),
        ),
      ),
    );
  }
}
