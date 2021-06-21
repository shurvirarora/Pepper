import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/pages/profilePage.dart';
import 'package:myapp/styleguide/colors.dart';
import 'package:myapp/styleguide/textstyle.dart';
import 'package:provider/provider.dart';
import 'package:myapp/blocs/auth_bloc.dart';

class settingsPage extends StatefulWidget {
  @override
  _settingsPageState createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              color: Colors.white,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: primaryColor,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, top: 0, right: 16),
              child: Column(
                children: [
                  Text(
                    "Settings",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.caretDown,
                        color: primaryColor,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Swipe Mode",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Divider(
                    height: 15,
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  buildNotificationOptionRow("Pepper Group ", true),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.pin_drop,
                        color: primaryColor,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Location",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Divider(
                    height: 15,
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  buildAccountOptionRow(context, "Serangoon, Singapore"),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: primaryColor,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Account",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Divider(
                    height: 15,
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  buildAccountOptionRow(context, "Change password"),
                  buildAccountOptionRow(context, "Notification settings"),
                  buildAccountOptionRow(context, "Privacy & Security"),
                  SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: OutlineButton(
                      padding: EdgeInsets.symmetric(horizontal: 118),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () => authBloc.logout(),
                      child: Text("SIGN OUT",
                          style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 2.2,
                              color: Colors.black)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: OutlineButton(
                      padding: EdgeInsets.symmetric(horizontal: 80),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () {},
                      child: Text("DELETE ACCOUNT",
                          style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 2.2,
                              color: secondaryColor)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isActive,
              onChanged: (bool val) {},
            ))
      ],
    );
  }

  GestureDetector buildAccountOptionRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Option 1"),
                    Text("Option 2"),
                    Text("Option 3"),
                  ],
                ),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Close")),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
