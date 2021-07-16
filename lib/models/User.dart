import 'package:flutter/material.dart';

class UserModel {
  int _age;
  int _height;
  String _gender;
  String _aboutMe;
  String _education;
  String _work;
  String _name;
  String _downloadUrl;

  UserModel(this._age, this._height, this._aboutMe, this._education,
      this._downloadUrl, this._gender, this._name, this._work);

  get age => _age;

  get height => _height;

  get gender => _gender;

  get work => _work;

  get education => _education;

  get name => _name;

  get aboutMe => _aboutMe;

  get url => _downloadUrl;

  set setAge(int age) {
    this._age = age;
  }

  set setHeight(int height) {
    this._height = height;
  }

  set setGender(String gender) {
    this._gender = gender;
  }

  set setWork(String work) {
    this._work = work;
  }

  set setEducation(String education) {
    this._education = education;
  }

  set setName(String name) {
    this._name = name;
  }

  set setAboutMe(String aboutMe) {
    this._aboutMe = aboutMe;
  }

  set setUrl(String url) {
    this._downloadUrl = url;
  }
}
