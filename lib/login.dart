import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/ForgotPassword.dart';
import 'package:myapp/Home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/blocs/auth_bloc.dart';
import 'package:provider/provider.dart';
import 'Home.dart';
// import com.facebook.FacebookSdk;
// import com.facebook.appevents.AppEventsLogger;
// import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class Login extends StatefulWidget {
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
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  StreamSubscription<User> loginStateSubscription;

  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    loginStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser != null) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    loginStateSubscription.cancel();
    super.dispose();
  }

  void oldButtonFunction() {
    print(hasBeenPressed);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
    setState(() {
      hasBeenPressed = !hasBeenPressed;
    });
  }

  bool hasBeenPressed = true;

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff44d083),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 260, 0, 10),
              child: Icon(
                FontAwesomeIcons.pepperHot,
                size: 70,
                color: Color(0xfffe3c72),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Login.myText('pepper', 36, 1.5, Colors.white, 'Righteous'),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 130),
              child: Login.myText('Spice up your life', 21, 0,
                  Color(0xfffe3c72), 'DancingScript'),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                child: Center(
                    child: LoginButton("LOG IN WITH PHONE",
                        FontAwesomeIcons.mobileAlt, oldButtonFunction))),
            Center(
                child: LoginButton('LOG IN WITH FACEBOOK',
                    FontAwesomeIcons.facebook, () => authBloc.loginFacebook())),
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
  Function onPressed;

  LoginButton(this.name, this.myIcon, this.onPressed);

  @override
  LoginButtonState createState() {
    return LoginButtonState();
  }
}

class LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
        onPressed: () {
          this.widget.onPressed();
        },
        icon: Icon(
          this.widget.myIcon,
          semanticLabel: "rvervtbtrbtrr",
          textDirection: TextDirection.rtl,
          size: 15,
        ),
        label: Text(
          this.widget.name,
          style: TextStyle(letterSpacing: 2),
        ),
        style: OutlinedButton.styleFrom(
          minimumSize: Size(310, 40),
          primary: Colors.white,
          onSurface: Colors.white,
          side: BorderSide(
            width: 2,
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ));
  }
}
