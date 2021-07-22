import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  String aboutMe;
  String education;
  String work;
  int height;

  Future<void> addUser() {
    //Adds data to firestore
    print(url);
    if (url == null) {
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
      DocumentReference collectionReference =
          FirebaseFirestore.instance.collection('User').doc(user.uid);
      // Navigator.pop(context);

      return collectionReference.set({
        'User': uid.toString(), //stores unique user id
        'Age': age,
        'Gender': gender,
        'About Me': aboutMe,
        'Education': education,
        'Work': work,
        'Height': height,
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
          child: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          ImageCapture(),
          Padding(
            padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
            child: Text(
              "Basic Info",
              style: titleStyle,
            ),
          ),
          buildTextField(
              'Age', "It's just a number...", 30, TextInputType.number),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Gender",
              style: TextStyle(color: Color(0xfffe3c72)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: DropdownButtonFormField(
              decoration: InputDecoration(border: OutlineInputBorder()),
              hint: Text('Gender'),
              onChanged: (input) {
                setState(() {
                  gender = input;
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
          // buildTextField('Gender', '', 30, TextInputType.text),
          buildTextField(
              'About Me', 'Tell us about yourself...', 70, TextInputType.text),
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
          // FloatingActionButton(onPressed: addUser),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: LoginButton('Update', Icons.update, addUser,
                Color(0xfffe3c72), Colors.black),
          ),

          // BackButton(
          //   onPressed: fetchData,
          // ),
        ],
      )),
    );
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
            style: TextStyle(color: Color(0xfffe3c72)),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            // height: size,
            child: TextField(
              keyboardType: textType,
              onChanged: (text) {
                //Stores input into respective variables
                if (label == "Age") {
                  age = int.parse(text);
                }
                if (label == "About Me") {
                  aboutMe = text;
                }
                if (label == "Education") {
                  education = text;
                }
                if (label == "Work") {
                  work = text;
                }
                if (label == "Height") {
                  height = int.parse(text);
                }
              },
              // maxLines: lines,
              style: TextStyle(), cursorColor: Color(0xfffe3c72),
              obscureText: false,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
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
                  )),
            ),
          ),

          // Text(data == null ? "" : data['Bio']),
        ],
      ),
    );
  }
}

class ImageCapture extends StatefulWidget {
  // const ImageCapture({ Key? key }) : super(key: key);

  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File imageFile;

  Future getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // Future cropImage() async {
  //   File cropped = await ImageCropper.cropImage(
  //       sourcePath: imageFile.path,
  //       androidUiSettings: AndroidUiSettings(
  //         toolbarColor: Colors.purple,
  //         toolbarWidgetColor: Colors.white,
  //         toolbarTitle: "Crop it",
  //       ));

  //   setState(() {
  //     imageFile = cropped ?? imageFile;
  //   });
  // }

  void clearImage() {
    setState(() {
      imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (imageFile != null) ...[
          CircleAvatar(
            child: Image.file(
              imageFile,
              width: 100,
              height: 100,
            ),
            radius: 50,
          )
        ],
        IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: () => getImage(ImageSource.camera)),
        IconButton(
            icon: Icon(Icons.photo_library),
            onPressed: () => getImage(ImageSource.gallery)),
        Row(
          children: [
            // TextButton(onPressed: cropImage, child: Icon(Icons.crop)),
            TextButton(onPressed: clearImage, child: Icon(Icons.refresh))
          ],
        ),
        Uploader(imageFile),
      ],
    );
  }
}

// Future<String> downloadUrl;

class Uploader extends StatefulWidget {
  // const Uploader({ Key? key }) : super(key: key);
  final File file;

  Uploader(this.file);

  @override
  _UploaderState createState() => _UploaderState();
}

UploadTask uploadTask;
String filePath;
String url;

class _UploaderState extends State<Uploader> {
  final FirebaseStorage storage =
      FirebaseStorage.instanceFor(bucket: 'gs://pepper-e9a17.appspot.com');
  // FirebaseStorage(storageBucket: 'gs://pepper-e9a17.appspot.com');

  // final String filePath = 'images/image1.png';

  startUpload() async {
    filePath = 'images/${DateTime.now()}.png';
    // Reference ref = storage.ref().child("/photo.jpg");
    setState(() {
      uploadTask = storage.ref().child(filePath).putFile(widget.file);
    });
    var dowurl =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    url = dowurl.toString(); //address where image stored
    print("URL GOES HERE");
    print(url);
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

  @override
  Widget build(BuildContext context) {
    if (uploadTask != null) {
      return StreamBuilder<TaskSnapshot>(
          stream: uploadTask.snapshotEvents,
          builder: (context, snapshot) {
            var event = snapshot.data;

            double progress =
                event != null ? event.bytesTransferred / event.totalBytes : 0;

            return Text(progress.toString());
          });
    } else {
      return TextButton.icon(
          onPressed: startUpload,
          icon: Icon(Icons.cloud_upload),
          label: Text('Upload to Firebase'));
    }
  }
}
