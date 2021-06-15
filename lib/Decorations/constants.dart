import 'package:flutter/material.dart';

InputDecoration textFieldDeco(String label, String hint) {
  return InputDecoration(
    prefixIcon: Icon(Icons.email),
    labelText: label,
    labelStyle: TextStyle(
        fontSize: 22,
        color: Colors.black,
        textBaseline: TextBaseline.alphabetic),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    alignLabelWithHint: true,
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
    ),
  );
}
