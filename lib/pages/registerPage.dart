import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/styleguide/colors.dart';
import 'package:myapp/styleguide/textstyle.dart';
import '../Home.dart';
import 'loginPage.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final User user = firebaseAuth.currentUser;
final String uid = user.uid.toString();

class registerPage extends StatefulWidget {
  @override
  _registerPageState createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  Map data;
//All the data collected from user
  int age;
  String gender;
  String name;
  String aboutMe;
  String education;
  String work;
  int height;
//Controllers
  TextEditingController nameController;
  TextEditingController ageController;
  TextEditingController aboutMeController;
  TextEditingController educationController;
  TextEditingController workController;
  TextEditingController heightController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    ageController = TextEditingController();
    workController = TextEditingController();
    educationController = TextEditingController();
    heightController = TextEditingController();
    aboutMeController = TextEditingController();
    // gender = customisePage.user.gender;
  }

  startUpload() async {
    if (!imgAdded) {
      return;
    }
    filePath = 'images/${DateTime.now()}.png';
    // Reference ref = storage.ref().child("/photo.jpg");

    setState(() {
      uploadTask = storage.ref().child(filePath).putFile(imageFile);
    });
    // customisePage.user.setFile = widget.file;
    var dowurl =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    url = dowurl.toString(); //address where image stored
    // customisePage.user.setUrl = url;
    print("URL GOES HERE");
    print(url);
  }

  Future<void> addUser() async {
    //Adds data to firestore
    // print(url);
    if (imageFile == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Looks like you forgot something"),
          content: Text("Please add an image"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("Ok"),
            ),
          ],
        ),
      );
    } else {
      print("passes");
      await startUpload();
      DocumentReference collectionReference =
          FirebaseFirestore.instance.collection('User').doc(user.uid);
      // Navigator.pop(context);

      return collectionReference.set({
        'User': uid.toString(), //stores unique user id
        'Name': nameController.text,
        'Age': int.parse(ageController.text),
        'Gender': gender,
        'About Me': aboutMeController.text,
        'Education': educationController.text,
        'Work': workController.text,
        'Height': int.parse(heightController.text),
        'DownloadUrl': url
      }).then((value) => Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Home())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 25),
              child: Center(
                child: Text(
                  'Create Profile',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ImageCapture(),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
              child: Text(
                "Basic Info",
                style: titleStyle,
              ),
            ),
            buildTextField('Name', "Name...", 30, TextInputType.text),
            buildTextField(
                'Age', "It's just a number...", 30, TextInputType.number),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Gender",
                style: TextStyle(color: primaryColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: DropdownButtonFormField(
                // value: widget.user.gender,
                decoration: InputDecoration(border: OutlineInputBorder()),
                hint: Text('Gender'),
                onChanged: (input) {
                  setState(() {
                    gender = input;
                    // customisePage.user.setGender = input;
                  });
                  print(input);
                },
                items: [
                  DropdownMenuItem(
                    value: 'Male',
                    child: Text('Male'),
                  ),
                  DropdownMenuItem(
                    value: 'Female',
                    child: Text('Female'),
                  ),
                ],
              ),
            ),
            buildTextField('About Me', 'Tell us about yourself...', 70,
                TextInputType.text),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 40, 8, 10),
              child: Text(
                "Work & Education",
                style: titleStyle,
              ),
            ),
            buildTextField('Education', '', 30, TextInputType.text),
            buildTextField('Work', '', 30, TextInputType.text),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 40, 8, 10),
              child: Text(
                "Additional Info",
                style: titleStyle,
              ),
            ),
            buildTextField('Height', 'cm', 30, TextInputType.number),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 35),
              child: LoginButton('Sign Up', FontAwesomeIcons.userPlus, addUser,
                  primaryColor, Colors.black),
            ),
          ],
        ),
      )),
    );
  }

  TextEditingController controllerAllocator(String label) {
    if (label == "Age") {
      return ageController;
    }
    if (label == "Name") {
      return nameController;
    }
    if (label == "About Me") {
      return aboutMeController;
    }
    if (label == "Education") {
      return educationController;
    }
    if (label == "Work") {
      return workController;
    }
    if (label == "Height") {
      return heightController;
    }
  }

  Widget buildTextField(
      String label, String placeholder, double size, TextInputType textType) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: primaryColor),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            // height: size,
            child: TextField(
              controller: controllerAllocator(label),
              keyboardType: textType,
              // onChanged: (text) {
              //   // setState(() {
              //   //Stores input into respective variables
              //   if (label == "Age") {
              //     age = int.parse(text);
              //     // customisePage.user.setAge = int.parse(text);
              //   }
              //   if (label == "Name") {
              //     name = text;
              //     // customisePage.user.setName = text;
              //   }
              //   if (label == "About Me") {
              //     aboutMe = text;
              //     // customisePage.user.setAboutMe = text;
              //   }
              //   if (label == "Education") {
              //     education = text;
              //     // customisePage.user.setEducation = text;
              //   }
              //   if (label == "Work") {
              //     work = text;
              //     // customisePage.user.setWork = text;
              //   }
              //   if (label == "Height") {
              //     height = int.parse(text);
              //     // customisePage.user.setHeight = int.parse(text);
              //   }
              //   // });
              // },
              // maxLines: lines,
              style: TextStyle(), cursorColor: primaryColor,
              obscureText: false,
              decoration: deco(size, placeholder),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration deco(size, placeholder) => InputDecoration(
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: const BorderRadius.all(
            const Radius.circular(15.0),
          )),
      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, size),
      // labelText: labelText,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      hintText: placeholder,
      hintStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        color: Colors.grey[500],
      ));
}

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

bool imgAdded = false;
File imageFile;
final FirebaseStorage storage =
    FirebaseStorage.instanceFor(bucket: 'gs://pepper-e9a17.appspot.com');
UploadTask uploadTask;
String filePath;
String url;

class _ImageCaptureState extends State<ImageCapture> {
  // Future<void> addUser() async {
  //   //Adds data to firestore
  //   // startUpload();
  //   // print(customisePage.user.name);
  //   // if (customisePage.file == null) {
  //   //   showDialog(
  //   //     context: context,
  //   //     builder: (ctx) => AlertDialog(
  //   //       title: Text("Looks like you forgot something"),
  //   //       content: Text("Please add an image"),
  //   //       actions: <Widget>[
  //   //         TextButton(
  //   //           onPressed: () {
  //   //             Navigator.of(ctx).pop();
  //   //           },
  //   //           child: Text("Ok"),
  //   //         ),
  //   //       ],
  //   //     ),
  //   //   );
  //   // } else {
  //   print(customisePage.user.name);
  //   await startUpload();
  //   DocumentReference collectionReference =
  //       FirebaseFirestore.instance.collection('User').doc(user.uid);
  //   // Navigator.pop(context);
  //   return collectionReference.set({
  //     'User': uid.toString(),
  //      //stores unique user id
  //     'Age': customisePage.user.age,
  //     'Gender': customisePage.user.gender,
  //     'About Me': customisePage.user.aboutMe,
  //     'Education': customisePage.user.education,
  //     'Work': customisePage.user.work,
  //     'Height': customisePage.user.height,
  //     'DownloadUrl': customisePage.user.url
  //   });
  //   // }
  // }

  Future getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    imageFile = File(pickedFile.path);
    imgAdded = true;
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void clearImage() {
    setState(() {
      imageFile = null;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        getImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      getImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTap: () {
              _showPicker(context);
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 130, height: 130,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: 2, color: primaryColor)),
                  // radius: 100,

                  child: imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(
                            imageFile,
                            width: 100,
                            height: 100,
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              // color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(100)),
                          width: 100,
                          height: 100,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                          ),
                        ),
                ),
                Positioned(
                  left: 80,
                  top: 97,
                  child: TextButton(
                      onPressed: clearImage,
                      child: Icon(
                        FontAwesomeIcons.minusCircle,
                        color: Colors.red,
                        size: 18,
                      )),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

  // uploadImage(var imageFile) async {
  //   Reference ref = storage.ref().child("/photo.jpg");
  //   UploadTask uploadTask = ref.putFile(widget.file);
  //   var dowurl =
  //       await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
  //   String url = dowurl.toString();
  //   print(url);
  // }

  // printUrl() async {
  //   print("GOES HERE");
  //   // String filePath = 'images/${DateTime.now()}.png';
  //   Reference ref = FirebaseStorage.instance.ref().child(filePath);
  //   String url = (await ref.getDownloadURL()).toString();
  //   print(url);
  // }

  

