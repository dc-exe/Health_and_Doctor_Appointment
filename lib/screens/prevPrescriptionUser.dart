import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PrevPrescriptionUser extends StatefulWidget {
  @override
  _PrevPrescriptionUserState createState() => _PrevPrescriptionUserState();
}

class _PrevPrescriptionUserState extends State<PrevPrescriptionUser> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  String _documentID;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    String _dateFormatter(String _timestamp) {
      String formattedDate =
          DateFormat('dd-MM-yyyy kk:mm').format(DateTime.parse(_timestamp));
      return formattedDate;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Previous Prescriptions",
            style: GoogleFonts.lato(
                color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('appointments')
                .doc(user.email)
                .collection('prescriptions')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              return ListView.builder(
                scrollDirection: Axis.vertical,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.size,
                itemBuilder: (context, index) {
                  DocumentSnapshot pres = snapshot.data.docs[index];
                  return Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    color: Colors.grey[200],
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Dcotor:",
                              style: GoogleFonts.lato(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              pres['doctor'],
                              style: GoogleFonts.lato(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            Text(
                              "Prescription:",
                              style: GoogleFonts.lato(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              pres['prescription'],
                              style: GoogleFonts.lato(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              "Time:",
                              style: GoogleFonts.lato(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                                _dateFormatter(
                                    pres['time'].toDate().toString()),
                                style: GoogleFonts.lato(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              "Fees:",
                              style: GoogleFonts.lato(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(pres['fees'],
                                style: GoogleFonts.lato(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
