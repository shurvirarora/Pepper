import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../styleguide/colors.dart';
import '../styleguide/textstyle.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'customisePage.dart';
import '../models/User.dart';

//Gets user id
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final User user = firebaseAuth.currentUser;
final String uid = user.uid.toString();

class editProfile extends StatefulWidget {
  UserModel user;
  @override
  _editProfileState createState() => _editProfileState();

  editProfile(this.user);
}

class _editProfileState extends State<editProfile> {
  Map data;
//All the data collected from user
  String name;
  int age;
  String gender;
  String aboutMe;
  String education;
  String work;
  int height;

  TextEditingController nameController;
  TextEditingController ageController;
  TextEditingController aboutMeController;
  TextEditingController educationController;
  TextEditingController workController;
  TextEditingController heightController;

  fetchData() {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('User');

    collectionReference
        .where("User", isEqualTo: uid.toString())
        .snapshots()
        .listen((snapshot) {
      setState(() {
        data = snapshot.docs[1].data();
        print(data.toString());
      });
    });
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: customisePage.user.name);
    ageController =
        TextEditingController(text: customisePage.user.age.toString());
    workController = TextEditingController(text: customisePage.user.work);
    educationController =
        TextEditingController(text: customisePage.user.education);
    heightController =
        TextEditingController(text: customisePage.user.height.toString());
    aboutMeController = TextEditingController(text: customisePage.user.aboutMe);
    gender = customisePage.user.gender;
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
                value: widget.user.gender,
                decoration: InputDecoration(border: OutlineInputBorder()),
                hint: Text('Gender'),
                onChanged: (input) {
                  setState(() {
                    gender = input;
                    customisePage.user.setGender = input;
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
            // FloatingActionButton(onPressed: addUser),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 30),
            //   child: LoginButton('Update', Icons.update, addUser,
            //       Color(0xfffe3c72), Colors.black),
            // ),

            // BackButton(
            //   onPressed: fetchData,
            // ),
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
              onChanged: (text) {
                // setState(() {
                //Stores input into respective variables
                if (label == "Age") {
                  age = int.parse(text);
                  customisePage.user.setAge = int.parse(text);
                }
                if (label == "Name") {
                  name = text;
                  customisePage.user.setName = text;
                }
                if (label == "About Me") {
                  aboutMe = text;
                  customisePage.user.setAboutMe = text;
                }
                if (label == "Education") {
                  education = text;
                  customisePage.user.setEducation = text;
                }
                if (label == "Work") {
                  work = text;
                  customisePage.user.setWork = text;
                }
                if (label == "Height") {
                  height = int.parse(text);
                  customisePage.user.setHeight = int.parse(text);
                }
                // });
              },
              // maxLines: lines,
              style: TextStyle(), cursorColor: Color(0xfffe3c72),
              obscureText: false,
              decoration: deco(size, placeholder),
            ),
          ),
        ],
      ),
    );
  }
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

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File imageFile;

  Future getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    customisePage.file = File(pickedFile.path);
    customisePage.imgAdded = true;
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
        // IconButton(
        //     icon: Icon(Icons.photo_camera),
        //     onPressed: () => getImage(ImageSource.camera)),
        // IconButton(
        //     icon: Icon(Icons.photo_library),
        //     onPressed: () => getImage(ImageSource.gallery)),
        // Row(
        //   children: [
        //     // TextButton(onPressed: cropImage, child: Icon(Icons.crop)),
        //     TextButton(onPressed: clearImage, child: Icon(Icons.refresh))
        //   ],
        // ),
        // Uploader(imageFile),
      ],
    );
  }
}

// Future<String> downloadUrl;

// class Uploader extends StatefulWidget {
//   // const Uploader({ Key? key }) : super(key: key);
//   final File file;

//   Uploader(this.file);

//   @override
//   _UploaderState createState() => _UploaderState();
// }



// class _UploaderState extends State<Uploader> {
//   final FirebaseStorage storage =
//       FirebaseStorage.instanceFor(bucket: 'gs://pepper-e9a17.appspot.com');
//   // FirebaseStorage(storageBucket: 'gs://pepper-e9a17.appspot.com');

//   // final String filePath = 'images/image1.png';

//   startUpload() async {
//     filePath = 'images/${DateTime.now()}.png';
//     // Reference ref = storage.ref().child("/photo.jpg");
//     setState(() {
//       uploadTask = storage.ref().child(filePath).putFile(widget.file);
//     });
//     customisePage.file = widget.file;
//     var dowurl =
//         await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
//     url = dowurl.toString(); //address where image stored
//     customisePage.user.setUrl = url;
//     print("URL GOES HERE");
//     print(url);
//   }

//   // uploadImage(var imageFile) async {
//   //   Reference ref = storage.ref().child("/photo.jpg");
//   //   UploadTask uploadTask = ref.putFile(widget.file);
//   //   var dowurl =
//   //       await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
//   //   String url = dowurl.toString();
//   //   print(url);
//   // }

//   // printUrl() async {
//   //   print("GOES HERE");
//   //   // String filePath = 'images/${DateTime.now()}.png';
//   //   Reference ref = FirebaseStorage.instance.ref().child(filePath);
//   //   String url = (await ref.getDownloadURL()).toString();
//   //   print(url);
//   // }

//   @override
//   Widget build(BuildContext context) {
//     //Upload to firebase button TODELETE
//     if (uploadTask != null) {
//       return StreamBuilder<TaskSnapshot>(
//           stream: uploadTask.snapshotEvents,
//           builder: (context, snapshot) {
//             var event = snapshot.data;

//             double progress =
//                 event != null ? event.bytesTransferred / event.totalBytes : 0;

//             return Text(progress.toString());
//           });
//     } else {
//       return TextButton.icon(
//           onPressed: startUpload,
//           icon: Icon(Icons.cloud_upload),
//           label: Text('Upload to Firebase'));
//     }
//   }
// }

// BASIC INFO
// Name
// Age
// Gender
// About Me

// MY WORK & EDUCATION
// Education
// Work

// MY INTEREST
// interest ==> textbox

// ADDITIONAL INFO
// Height
// Lookingfor ==> Is a drop down
//Excercise ==> Drop down
//Drinking smoking

// PROFILE PROMPTS
// Add 3 prompt buttons
