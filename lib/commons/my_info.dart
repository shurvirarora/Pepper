import 'package:flutter/material.dart';
import 'package:myapp/commons/radial_progress.dart';
import 'package:myapp/styleguide/colors.dart';
import 'package:myapp/styleguide/textstyle.dart';
import 'package:myapp/commons/rounded_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyInfo extends StatelessWidget {
  // const MyInfo({
  //   Key key,
  // }) : super(key: key);

  String name;
  String age;

  MyInfo(this.name, this.age);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RadialProgress(
            width: 6,
            child: RoundedImage(
              imagePath: "assets/images/charli.jpg",
              size: Size.fromWidth(120.0),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                name,
                style: whiteNameTextStyle,
              ),
              Text(
                ", " + age,
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
              Icon(
                FontAwesomeIcons.mapMarkerAlt,
                size: 15.0,
                color: Colors.white,
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
