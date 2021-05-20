import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:health_and_doctor_appointment/screens/videoCall.dart';

class GetPrescription extends StatefulWidget {
  final docID, patientName;
  const GetPrescription({Key key, this.docID, this.patientName})
      : super(key: key);

  @override
  _GetPrescriptionState createState() => _GetPrescriptionState();
}

class _GetPrescriptionState extends State<GetPrescription> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  String docID;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  Future<List<DocumentSnapshot>> getMyPrescription(String docID) =>
      FirebaseFirestore.instance
          .collection('appointments')
          .doc(user.email)
          .collection('prescriptions')
          .orderBy('docID')
          .startAt([docID])
          .endAt([docID + '\uf8ff'])
          .get()
          .then((snapshot) {
            return snapshot.docs;
          });

  @override
  void initState() {
    super.initState();
    _getUser();
    docID = widget.docID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Prescription",
            style: GoogleFonts.lato(
                color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('appointments')
              .doc(user.email)
              .collection('prescriptions')
              .orderBy('docID')
              .startAt([docID]).endAt([docID + '\uf8ff']).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            return snapshot.data.size == 0
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 25),
                          child: Center(
                              child: Text(
                            "No Prescription is Added.",
                            style: GoogleFonts.lato(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          )),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0)),
                            onPressed: () {
                              var patientName = widget.patientName
                                  .replaceAll(RegExp('\\s+'), '_');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Meeting(
                                          roomID: patientName,
                                        )),
                              );
                            },
                            color: Colors.indigo[800],
                            child: Text(
                              "Connect Video Call",
                              style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.size,
                    itemBuilder: (context, index) {
                      DocumentSnapshot pres = snapshot.data.docs[index];
                      return Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Prescription",
                              style: GoogleFonts.lato(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(10),
                              color: Colors.grey[200],
                              child: Text(
                                pres['prescription'],
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              "Fees",
                              style: GoogleFonts.lato(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(10),
                              color: Colors.grey[200],
                              child: Text(
                                "₹ " + pres['fees'],
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              "Pay via",
                              style: GoogleFonts.lato(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Material(
                                  elevation: 01.0,
                                  shape: CircleBorder(),
                                  clipBehavior: Clip.hardEdge,
                                  color: Colors.transparent,
                                  child: Ink.image(
                                    image: AssetImage('assets/gpay.png'),
                                    fit: BoxFit.cover,
                                    width: 60.0,
                                    height: 60.0,
                                    child: InkWell(
                                      onTap: () async {
                                        await LaunchApp.openApp(
                                            androidPackageName:
                                                'com.google.android.apps.nbu.paisa.user',
                                            appStoreLink:
                                                'https://play.google.com/store/apps/details?id=com.google.android.apps.nbu.paisa.user',
                                            openStore: true);
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Material(
                                  elevation: 01.0,
                                  shape: CircleBorder(),
                                  clipBehavior: Clip.hardEdge,
                                  color: Colors.white,
                                  child: Ink.image(
                                    image: AssetImage("assets/paytm.webp"),
                                    fit: BoxFit.cover,
                                    width: 60.0,
                                    height: 60.0,
                                    child: InkWell(
                                      onTap: () async {
                                        await LaunchApp.openApp(
                                            androidPackageName:
                                                'net.one97.paytm',
                                            appStoreLink:
                                                'https://play.google.com/store/apps/details?id=net.one97.paytm',
                                            openStore: true);
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Material(
                                  elevation: 01.0,
                                  shape: CircleBorder(),
                                  clipBehavior: Clip.hardEdge,
                                  color: Colors.transparent,
                                  child: Ink.image(
                                    image: AssetImage("assets/phonepe.webp"),
                                    fit: BoxFit.cover,
                                    width: 60.0,
                                    height: 60.0,
                                    child: InkWell(
                                      onTap: () async {
                                        await LaunchApp.openApp(
                                            androidPackageName:
                                                'com.phonepe.app',
                                            appStoreLink:
                                                'https://play.google.com/store/apps/details?id=com.phonepe.app',
                                            openStore: true);
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 45,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Divider(
                                    color: Colors.grey[800],
                                  )),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(
                                      'Consult online',
                                      style: GoogleFonts.lato(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Divider(
                                    color: Colors.grey[800],
                                  )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0)),
                                onPressed: () {
                                  var patientName = widget.patientName
                                      .replaceAll(RegExp('\\s+'), '_');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Meeting(
                                              roomID: patientName,
                                            )),
                                  );
                                },
                                color: Colors.indigo[800],
                                child: Text(
                                  "Connect Video Call",
                                  style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
