import 'package:flutter/material.dart';
import 'package:myapp/blocs/auth_bloc.dart';
import 'package:myapp/loginPage.dart';
import 'package:myapp/home.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'loginPage.dart';
import 'phoneLogin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'emailLogin.dart';

// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var themeData = ThemeData(
      // primarySwatch: Color(0xffD8F1A0),
      primaryColor: Color(0xff44d083),
      scaffoldBackgroundColor: Color(0xff44d083),
    );
    return Provider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pepper',
        theme: themeData,
        //Defines home
        initialRoute: '/main',
        routes: {
          '/main': (context) => Home(),
          '/login': (context) => Login(),
          '/Phone': (context) => PhoneLogin(),
          '/Email': (context) => EmailLogin(),
        },
      ),
    );
  }
}

class Apple extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Layout Demo')),
      body: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/profilePic.jpg'),
          ),
          Container(
            width: double.infinity,
            color: Colors.red.shade400,
            margin: EdgeInsets.only(left: 100, right: 100),
            padding: EdgeInsets.only(left: 15),
            child: Text(
              'Pepper',
              style: TextStyle(
                color: Colors.red[100],
                fontFamily: 'PoiretOne-Regular',
                fontSize: 36,
                letterSpacing: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 10,
            width: 150,
            child: Divider(
              color: Colors.teal.shade100,
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: ListTile(
              leading: Icon(
                Icons.account_circle_sharp,
                size: 30,
                color: Colors.green[500],
              ),
              title: Text("Spice up your life"),
            ),
          )
        ]),
      ),
    );
  }
}
