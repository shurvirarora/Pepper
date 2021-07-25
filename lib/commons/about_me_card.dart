import 'package:myapp/styleguide/colors.dart';
import 'package:myapp/styleguide/textstyle.dart';
import 'package:flutter/material.dart';

class AboutMeCard extends StatelessWidget {
  final String firstText, secondText;
  final Widget icon;

  const AboutMeCard(
      {Key key,
      @required this.firstText,
      @required this.secondText,
      @required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (firstText != null && firstText != "null") {
      return Card(
        shadowColor: primaryColor,
        margin: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 10),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            top: 5,
            bottom: 20,
            right: 20,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                    child: Text(
                      firstText,
                      style: userCardTitle,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Icon(
                      Icons.info,
                      size: 18,
                      color: secondaryColor,
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      secondText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
