import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'Decorations/constants.dart';

class EmailLogin extends StatefulWidget {
  @override
  _EmailLoginState createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  String email;
  String password;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Form(
              child: Column(
            children: [
              Text('Login'),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: textFieldDeco('Email', 'Enter your email'),
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: textFieldDeco('Password', 'Enter your password'),
              ),
              Container(
                  // child: TextButton(
                  //   child: Text('LOGIN'),
                  //   onPressed: () {},
                  //   style: ButtonStyle(
                  //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  //           RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(18.0),
                  //               side: BorderSide(color: Colors.red)))),
                  // ),
                  ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      Navigator.pushNamed(context, '/main');
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text('Login'),
                style: ElevatedButton.styleFrom(shape: StadiumBorder()),
              )
            ],
          )),
        ),
      ),
    );
  }
}
