import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:health_and_doctor_appointment/screens/prescription.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: camel_case_types 'assets/vector-doc2.jpg',

class Doctorpage extends StatefulWidget {
  @override
  _DoctorpageState createState() => _DoctorpageState();
}

TextEditingController comment = new TextEditingController();

class _DoctorpageState extends State<Doctorpage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  String _documentID;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  Future _signOut() async {
    await _auth.signOut();
  }

  Future<void> deleteAppointment(String docID) {
    return FirebaseFirestore.instance
        .collection('appointments')
        .doc("test@mail.com")
        .collection('pending')
        .doc(docID)
        .delete();
  }

  Future<void> deleteAppointmentDoc(String docID) {
    return FirebaseFirestore.instance
        .collection("appointments-doc")
        .where("docid", isEqualTo: docID)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("appointments-doc")
            .doc(element.id)
            .delete()
            .then((value) {
          print("Success!");
        });
      });
    });
  }

  String _dateFormatter(String _timestamp) {
    String formattedDate =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(_timestamp));
    return formattedDate;
  }

  String _timeFormatter(String _timestamp) {
    String formattedTime =
        DateFormat('kk:mm').format(DateTime.parse(_timestamp));
    return formattedTime;
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        deleteAppointment(_documentID);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Complete Appointment"),
      content: Text("Are you sure you want to delete this Appointment?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _checkDiff(DateTime _date) {
    var diff = DateTime.now().difference(_date).inHours;
    if (diff > 2) {
      return true;
    } else {
      return false;
    }
  }

  _compareDate(String _date) {
    if (_dateFormatter(DateTime.now().toString())
            .compareTo(_dateFormatter(_date)) ==
        0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            PopupMenuButton(
              itemBuilder: (BuildContext bc) => [
                PopupMenuItem(child: Text("All Appointments"), value: "prev"),
                PopupMenuItem(child: Text("Sign out"), value: "/login"),
              ],
              onSelected: (route) {
                print(route);

                // Note You must create respective pages for navigation
                if (route == '/login') {
                  Navigator.pushNamedAndRemoveUntil(
                      context, route, ModalRoute.withName('/login'));
                  _signOut();
                } else if (route == 'prev') {
                  Navigator.pushNamed(context, '/prevDoctor');
                }
              },
            ),
          ],
          backgroundColor: Colors.white,
          title: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Welcome',
              style: GoogleFonts.lato(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 15,
                  top: 20,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.account_circle_outlined,
                      size: 40,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      user.displayName,
                      style: GoogleFonts.lato(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 20, left: 15),
                child: Text(
                  "Your Appointments,",
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('appointments-doc')
                      .where('email', isEqualTo: user.email)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return snapshot.data.size == 0
                        ? Center(
                            child: Text(
                              'No Appointment Scheduled',
                              style: GoogleFonts.lato(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data.size,
                            itemBuilder: (context, index) {
                              DocumentSnapshot document =
                                  snapshot.data.docs[index];

                              print(_checkDiff(document['date'].toDate()));
                              if (_checkDiff(document['date'].toDate())) {
                                deleteAppointment(document.id);
                                deleteAppointmentDoc(document.id);
                              }
                              return Card(
                                elevation: 2,
                                child: InkWell(
                                  onTap: () {},
                                  child: ExpansionTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            document['name'],
                                            style: GoogleFonts.lato(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          _compareDate(document['date']
                                                  .toDate()
                                                  .toString())
                                              ? "TODAY"
                                              : "",
                                          style: GoogleFonts.lato(
                                              color: Colors.green,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 0,
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        _dateFormatter(document['date']
                                            .toDate()
                                            .toString()),
                                        style: GoogleFonts.lato(),
                                      ),
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 20, right: 10, left: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Description: ",
                                                      style: GoogleFonts.lato(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                      child: Text(
                                                        document['description'] ==
                                                                ""
                                                            ? "Not Available"
                                                            : document[
                                                                'description'],
                                                        style: GoogleFonts.lato(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Time: " +
                                                      _timeFormatter(
                                                        document['date']
                                                            .toDate()
                                                            .toString(),
                                                      ),
                                                  style: GoogleFonts.lato(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                              tooltip: 'Add Prescription',
                                              icon: Icon(
                                                Icons.pending_actions_outlined,
                                                color: Colors.black87,
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Prescription(
                                                            useremail: document[
                                                                'useremail'],
                                                            name: document[
                                                                'name'],
                                                            docName: document[
                                                                'doctor'],
                                                            time: document[
                                                                'date'],
                                                            docID: document[
                                                                'docid'],
                                                          )),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
