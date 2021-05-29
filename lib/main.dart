import 'package:flutter/material.dart';
import 'package:myapp/login.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/Home.dart';
import 'Home.dart';
import 'login.dart';
import 'PhoneLogin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'EmailLogin.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pepper',
      theme: themeData,
      //Defines home
      initialRoute: '/Email',
      routes: {
        '/main': (context) => Home(),
        '/login': (context) => Login(),
        '/Phone': (context) => PhoneLogin(),
        '/Email': (context) => EmailLogin(),
      },
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
            backgroundImage: AssetImage('images/profilePic.jpg'),
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

// home: MyHomePage(title: 'Flutter Home Pages'), //calling a stateful widget
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter = _counter + 1;
      reSet();
    });
  }

  void reSet() {
    if (_counter > 5) {
      _counter = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have clicked my button this many times:',
            ),
            Text(
              '$_counter',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
              // style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ), // This trailing comma makes auto-formatting nicer for build methods.
      // bottomNavigationBar: BottomNavigationBar(fixedColor: Colors.amber,),
    );
  }
}
