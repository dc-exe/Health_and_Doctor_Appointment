import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_and_doctor_appointment/screens/diseasedetail.dart';

class Disease extends StatefulWidget {
  @override
  _DiseaseState createState() => _DiseaseState();
}

class _DiseaseState extends State<Disease> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Disease',
            style: GoogleFonts.lato(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('disease')
                .orderBy('Name')
                .startAt(['']).endAt(['' + '\uf8ff']).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                physics: BouncingScrollPhysics(),
                children: snapshot.data.docs.map((document) {
                  return Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 10,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: Colors.black87,
                        width: 0.2,
                      ))),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DiseaseDetail(
                                      disease: document['Name'],
                                    )),
                          );
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  document['Name'],
                                  style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  document['Symtomps'],
                                  style: GoogleFonts.lato(
                                      fontSize: 14, color: Colors.black54),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ));
                }).toList(),
              );
            }));
  }
}
