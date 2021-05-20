import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SeeMedicalRecord extends StatefulWidget {
  final email;

  const SeeMedicalRecord({Key key, this.email}) : super(key: key);
  @override
  _SeeMedicalRecordState createState() => _SeeMedicalRecordState();
}

class _SeeMedicalRecordState extends State<SeeMedicalRecord> {
  String email;
  int _count = 3;
  Timer _timer;
  bool _isLoading = true;

  Future<String> checkImage() async {
    var data1 = (await FirebaseFirestore.instance
            .collection('medicalRecords')
            .doc(widget.email)
            .collection('records')
            .doc()
            .get())
        .data()['url']
        .toString();
    return data1;
  }

  void _startTimer() {
    _count = 3;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_count > 0) {
          _count--;
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
    email = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medical Record",
            style: GoogleFonts.lato(
                color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('medicalRecords')
            .doc(widget.email)
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
                  DocumentSnapshot document = snapshot.data.docs[index];

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
    );
  }
}
