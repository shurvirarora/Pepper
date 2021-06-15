import 'package:myapp/styleguide/textstyle.dart';
import 'package:flutter/material.dart';

class ProfileInfoSmallCard extends StatelessWidget {
  final String text;
  final Widget icon;

  const ProfileInfoSmallCard(
      {Key key, @required this.text, @required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              top: 10,
              bottom: 10,
              right: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Text(text, style: titleStyle),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: icon,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
