import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/blocs/auth_bloc.dart';
import 'package:myapp/pages/loginPage.dart';
import 'package:myapp/home.dart';
import 'package:myapp/pages/settingsPage.dart';
import 'package:myapp/styleguide/colors.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'pages/loginPage.dart';
import 'phoneLogin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'emailLogin.dart';
import 'services/FirebaseServices.dart';
import 'pages/messagePage.dart';

// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static bool isDarkModeActive = false;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var themeData = ThemeData(
      // primarySwatch: Color(0xffD8F1A0),
      primaryColor: primaryColor,
      scaffoldBackgroundColor: primaryColor,
    );
    return MultiProvider(
      providers: [
        Provider(create: (context) => AuthBloc()),
        // StreamProvider<DocumentSnapshot>(
        //   create: (context) => FirebaseServices().getMessageSnapshots(),
        //   initialData: null,
        // ),
        StreamProvider<DocumentSnapshot>(
          create: (context) => FirebaseServices().getUserSnapshots(),
          initialData: null,
          // initialData: [],
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pepper',
        theme: themeData,
        darkTheme: ThemeData(
            textTheme: Theme.of(context)
                .textTheme
                .apply(displayColor: secondaryColor, bodyColor: secondaryColor),
            backgroundColor: secondaryColor,
            cardColor: Colors.black,
            primaryColor: Colors.black,
            scaffoldBackgroundColor: secondaryColor),

        //themeMode: ThemeMode.light,
        //Defines home
        initialRoute: '/main',
        routes: {
          '/main': (context) => Home(),
          '/login': (context) => Login(),
          '/Phone': (context) => PhoneLogin(),
          '/Email': (context) => EmailLogin(),
          // '/messages': (context) => messagePage(),
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
