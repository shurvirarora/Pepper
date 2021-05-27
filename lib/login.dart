import 'package:flutter/material.dart';
import 'package:myapp/ForgotPassword.dart';
import 'package:myapp/Home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import com.facebook.FacebookSdk;
// import com.facebook.appevents.AppEventsLogger;
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class Login extends StatelessWidget {
  static Text myText(
      String text,
      double size,
      double spacing,
      Color color, //method to generate text
      String fontFamily) {
    return Text(text,
        style: TextStyle(
          color: color,
          fontFamily: fontFamily,
          fontSize: size,
          letterSpacing: spacing,
          fontWeight: FontWeight.bold,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff44d083),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.cen,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 260, 0, 10),
              child: Icon(
                FontAwesomeIcons.pepperHot,
                size: 70,
                color: Color(0xfffe3c72),
              ),
            ),
            // Icon(Icons.people_sharp),
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: myText('pepper', 36, 1.5, Colors.white, 'Righteous'),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 130),
              child: myText('Spice up your life', 21, 0, Color(0xfffe3c72),
                  'DancingScript'),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                child: Center(
                    child: LoginButton(
                        "LOG IN WITH PHONE", FontAwesomeIcons.mobileAlt))),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Center(child: LoginButton('')),
            // ),
            Center(
                child: LoginButton(
                    'LOG IN WITH FACEBOOK', FontAwesomeIcons.facebook)),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPassword()),
                  );
                },
                child: Text(
                  'Trouble Logging in?',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ))
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatefulWidget {
  final String name;
  final IconData myIcon;

  LoginButton(this.name, this.myIcon);

  @override
  LoginButtonState createState() {
    return LoginButtonState();
  }
}

class LoginButtonState extends State<LoginButton> {
  bool hasBeenPressed = true;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
        onPressed: () {
          print(hasBeenPressed);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
          setState(() {
            hasBeenPressed = !hasBeenPressed;
          });
        },
        icon: Icon(
          this.widget.myIcon, semanticLabel: "rvervtbtrbtrr",
          // FontAwesomeIcons.facebook,
          textDirection: TextDirection.rtl,
          size: 15,
        ),
        label: Text(
          this.widget.name,
          style: TextStyle(letterSpacing: 2),
          // textAlign: TextAlign.justify,
        ),
        style: OutlinedButton.styleFrom(
          minimumSize: Size(310, 40),
          // shadowColor: Colors.red,
          // elevation: 1,
          // tapTargetSize: MaterialTapTargetSize.padded,
          primary: Colors.white,
          onSurface: Colors.white,
          side: BorderSide(
            width: 2,
            color: hasBeenPressed ? Colors.white : Color(0xfffe3c72),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ));
  }
}
