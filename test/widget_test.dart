// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/Home.dart';
import 'package:myapp/blocs/auth_bloc.dart';

import 'package:myapp/main.dart';
import 'package:myapp/pages/messagePage.dart';
import 'package:myapp/pages/profilePage.dart';
import 'package:myapp/pages/viewProfilePage.dart';

import 'package:provider/provider.dart';

void main() {
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(MyApp());

  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);

  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();

  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });

  testWidgets('View Profile page', (WidgetTester tester) async {
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    // final User user = firebaseAuth.currentUser;
    // final String uid = user.uid.toString();
    FirebaseFirestore firebase = FirebaseFirestore.instance;
    // CollectionReference collectionReference =
    //     FirebaseFirestore.instance.collection('Messages');
    // CollectionReference userReference =
    //     FirebaseFirestore.instance.collection('User');
    runApp(MyApp());

    // final addField = find.byType(Text);
// var authBloc = Provider.of<AuthBloc>(context, listen: false);
    await tester.pumpWidget(profilePage());
    // await tester.pumpWidget(MaterialApp(home: messagePage()));

    // await tester.pump(Duration(seconds: 5));

    expect(find.text('Pepper'), findsNothing);
  });
}
