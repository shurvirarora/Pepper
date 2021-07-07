import 'package:flutter/material.dart';
import 'package:myapp/pages/editProfilePage.dart';
import 'package:myapp/pages/viewProfilePage.dart';
import 'package:myapp/styleguide/colors.dart';
import 'package:myapp/styleguide/textstyle.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// RESPONSIBLE FOR NAVIGATION BETWEEN THE 3 MAIN TABS
final List<Widget> customiseChildren = [editProfile(), viewProfile()];

class customisePage extends StatefulWidget {
  @override
  _customisePageState createState() => _customisePageState();
}

class _customisePageState extends State<customisePage> {
  bool _messagesHasBeenPressed = true;
  bool _gamesHasBeenPressed = false;

  int _selectedTab = 0;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110.0),
          child: customiseNav(),
        ),
        body: customiseChildren[_selectedTab],
      ),
    );
  }

  Widget customiseNav() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: Container(
        color: Colors.white,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            FontAwesomeIcons.times,
            size: 22,
            color: primaryColor,
          ),
        ),
      ),
      title: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Text(
          "Rehman",
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(10),
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: Text("Edit",
                    style: TextStyle(
                      fontSize: 16,
                      color: _messagesHasBeenPressed
                          ? primaryColor
                          : Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: () => {
                  _handleIndexChanged(0),
                  setState(() {
                    _messagesHasBeenPressed = true;
                    _gamesHasBeenPressed = false;
                  })
                },
              ),
              SizedBox(
                width: 30,
              ),
              Container(
                height: 20,
                width: 1,
                decoration:
                    BoxDecoration(color: Colors.black.withOpacity(0.15)),
              ),
              SizedBox(
                width: 30,
              ),
              TextButton(
                child: Text("View",
                    style: TextStyle(
                      fontSize: 16,
                      color: _gamesHasBeenPressed
                          ? primaryColor
                          : Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: () => {
                  _handleIndexChanged(1),
                  setState(() {
                    _messagesHasBeenPressed = false;
                    _gamesHasBeenPressed = true;
                  })
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        Container(
          color: Colors.white,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              FontAwesomeIcons.check,
              size: 22,
              color: primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
