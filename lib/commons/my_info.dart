import 'package:flutter/material.dart';
import 'package:myapp/commons/radial_progress.dart';
import 'package:myapp/pages/customisePage.dart';
import 'package:myapp/styleguide/colors.dart';
import 'package:myapp/styleguide/textstyle.dart';
import 'package:myapp/commons/rounded_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/User.dart';

class MyInfo extends StatelessWidget {
  // const MyInfo({
  //   Key key,
  // }) : super(key: key);
  UserModel user;

  MyInfo(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: colorGradient),
      //color: primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RadialProgress(
            width: 6,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => customisePage(user),
                  ),
                );
              },
              child: RoundedImage(
                imagePath: user.url,
                size: Size.fromWidth(220.0),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                user.name,
                style: whiteNameTextStyle,
              ),
              Text(
                ", " + user.age.toString(),
                style: whiteNameTextStyle,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 2),
                child: Icon(
                  FontAwesomeIcons.mapMarkerAlt,
                  size: 14.0,
                  color: Colors.white,
                ),
              ),
              Text(
                " Singapore",
                style: whiteSubHeadingTextStyle,
              )
            ],
          ),
        ],
      ),
    );
  }
}
