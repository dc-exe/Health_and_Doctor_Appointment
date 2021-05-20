import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SearchList extends StatefulWidget {
  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  String imageUrl;
  FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  String email;
  bool _isLoading = true;

  int _count = 2;
  Timer _timer;

  Future<void> _getUser() async {
    user = _auth.currentUser;
    email = user.email;
  }

  void _startTimer() {
    _count = 2;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_count > 0) {
          _count = _count - 1;
        } else {
          setState(() {
            _isLoading = false;
          });
          _timer.cancel();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    checkImage();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'My Medical Record',
          style: GoogleFonts.lato(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('medicalRecords')
                      .doc(user.email)
                      .collection('records')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : (Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Image.asset('assets/placeHolder.png'),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    'Upload your Medical Record Here.',
                                    style: GoogleFonts.lato(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ));
                    } else {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.size,
                          itemBuilder: (context, index) {
                            DocumentSnapshot document =
                                snapshot.data.docs[index];

                            return (Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  Image(
                                    image: NetworkImage(document['url']),
                                  ),
                                  Divider(
                                    color: Colors.black,
                                    thickness: 1,
                                  )
                                ],
                              ),
                            ));
                          });
                    }
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                MaterialButton(
                  color: Colors.lightBlue,
                  child: Text(
                    'Upload an Image',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => uploadImage(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  checkImage() async {
    var ref = FirebaseStorage.instance.ref('MedicalRecords/$email');
    try {
      await ref.getDownloadURL();
      return ref.getDownloadURL();
    } catch (err) {
      return ref.getDownloadURL();
    }
  }

  Future<void> addtoFirestore(String downloadURL) async {
    FirebaseFirestore.instance
        .collection('medicalRecords')
        .doc(user.email)
        .collection('records')
        .doc()
        .set({'url': downloadURL}, SetOptions(merge: true));
  }

  uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);

      String fileName = file.path.split('/').last;
      if (image != null) {
        //Upload to Firebase

        var snapshot = await _storage
            .ref()
            .child('MedicalRecords/$email/' + fileName)
            .putFile(file);

        var downloadUrl = await snapshot.ref.getDownloadURL();
        //checkImage();
        addtoFirestore(downloadUrl);

        setState(() {
          imageUrl = downloadUrl;
        });
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }
}
