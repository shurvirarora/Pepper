import 'package:flutter/material.dart';
// import 'package:myapp/orange.dart';

class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        backgroundColor: Color(0xff44d083),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text("Forgot Page"),
            Center(
              child: Container(
                width: 350,
                child: TextField(
                  cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black, height: 1),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Email',
                    labelStyle: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        textBaseline: TextBaseline.alphabetic),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    alignLabelWithHint: true,
                    hintText: 'yours@email.com',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () => print('IT WORKS!'),
              child: Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xfffe3c72),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
