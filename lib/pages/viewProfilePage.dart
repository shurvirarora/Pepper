import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/chatPage.dart';
import 'package:myapp/pages/chats_json.dart';
import 'package:myapp/styleguide/textstyle.dart';
import 'package:provider/provider.dart';
import '../Decorations/constants.dart';
import 'package:myapp/styleguide/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chatPage.dart';

class viewProfile extends StatefulWidget {
  @override
  _viewProfileState createState() => _viewProfileState();
}

class _viewProfileState extends State<viewProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Text(
        "View Page",
        style: titleStyle,
      ),
    ));
  }
}
