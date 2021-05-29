import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:myapp/blocs/auth_bloc.dart';
import 'login.dart';

class editPage extends StatefulWidget {
  @override
  _editPageState createState() => _editPageState();
}

class _editPageState extends State<editPage> {
  StreamSubscription<User> editStateSubscription;

  @override
  void initState() {
    // TODO: implement initState
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    editStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser == null) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    editStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);
    return Container(
      child: OutlinedButton(
          child: Text('Facebook'), onPressed: () => authBloc.logout()),
    );
  }
}
