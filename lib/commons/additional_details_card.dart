import 'package:myapp/styleguide/colors.dart';
import 'package:myapp/styleguide/textstyle.dart';
import 'package:flutter/material.dart';

class AdditionalDetailsCard extends StatelessWidget {
  final String gender;
  final String age;
  final String height;
  final String lookingFor;
  final String location;
  final String work;
  final String education;

  final Widget genderIcon;
  final Widget ageIcon;
  final Widget heightIcon;
  final Widget lookingForIcon;
  final Widget locationIcon;
  final Widget workIcon;
  final Widget educationIcon;

  const AdditionalDetailsCard(
      {Key key,
      this.gender,
      this.genderIcon,
      @required this.age,
      @required this.ageIcon,
      this.height,
      this.heightIcon,
      this.lookingFor,
      this.lookingForIcon,
      this.location,
      this.locationIcon,
      this.education,
      this.educationIcon,
      this.work,
      this.workIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (age != null && age != "null") {
      return Card(
          shadowColor: primaryColor,
          margin: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 10),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                top: 20,
                bottom: 20,
                right: 10,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                        child: Align(
                          alignment: Alignment.center,
                          child: ageIcon,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                        child: Text(age, style: titleStyle),
                      ),
                      Container(
                        height: 25,
                        width: 1,
                        decoration:
                            BoxDecoration(color: Colors.black.withOpacity(0.5)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Align(
                          alignment: Alignment.center,
                          child: genderIcon,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                        child: Text(gender, style: titleStyle),
                      ),
                      Container(
                        height: 25,
                        width: 1,
                        decoration:
                            BoxDecoration(color: Colors.black.withOpacity(0.5)),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                        child: Align(
                          alignment: Alignment.center,
                          child: heightIcon,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                        child: Text(height + "cm", style: titleStyle),
                      ),
                      // Container(
                      //   height: 25,
                      //   width: 1,
                      //   decoration:
                      //       BoxDecoration(color: Colors.black.withOpacity(0.5)),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(7.5, 0, 5, 5),
                      //   child: Align(
                      //     alignment: Alignment.center,
                      //     child: lookingForIcon,
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(2.5, 0, 5, 0),
                      //   child: Text(lookingFor, style: titleStyle),
                      // ),
                      // Container(
                      //   height: 25,
                      //   width: 1,
                      //   decoration:
                      //       BoxDecoration(color: Colors.black.withOpacity(0.5)),
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.25)),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
                        child: Align(
                          alignment: Alignment.center,
                          child: locationIcon,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                        child: Text(location, style: titleStyle),
                      ),
                    ],
                  ),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.25)),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
                        child: Align(
                          alignment: Alignment.center,
                          child: educationIcon,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Text(education, style: titleStyle),
                      ),
                    ],
                  ),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.25)),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
                        child: Align(
                          alignment: Alignment.center,
                          child: workIcon,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Text(work, style: titleStyle),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
    } else {
      return SizedBox();
    }
  }
}
