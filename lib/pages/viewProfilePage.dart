import 'package:flutter/material.dart';
import 'package:myapp/models/User.dart';
import 'package:myapp/pages/customisePage.dart';
import '../commons/userCard.dart';
import 'package:myapp/styleguide/textstyle.dart';
import '../Decorations/constants.dart';
import 'package:myapp/styleguide/colors.dart';

class viewProfile extends StatefulWidget {
  UserModel user;

  @override
  _viewProfileState createState() => _viewProfileState();
  viewProfile(this.user);
}

class _viewProfileState extends State<viewProfile> {
  UserModel curr = customisePage.user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
            // padding: EdgeInsets.only(top: 10),
            // height: MediaQuery.of(context).size.height * 1,
            // child: Center(
            child: UserCard(curr.url,
                name: curr.name,
                height: curr.height.toString(),
                age: curr.age.toString(),
                education: curr.education,
                work: curr.work,
                gender: curr.gender,
                aboutMe: curr.aboutMe)),
      ),
    );
  }
}
