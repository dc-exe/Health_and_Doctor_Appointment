import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorProfile extends StatefulWidget {
  final String doctor;

  const DoctorProfile({Key key, this.doctor}) : super(key: key);
  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('doctors')
              .orderBy('name')
              .startAt([widget.doctor]).endAt(
                  [widget.doctor + '\uf8ff']).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: snapshot.data.docs.map((document) {
                return Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.amber,
                        radius: 90,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Dr. ' + document['name'],
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        document['type'],
                        style: GoogleFonts.lato(
                          //fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 12,
                        child: Card(
                          color: Colors.white,
                          margin: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.place_outlined),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                document['address'],
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          for (var i = 0; i < document['rating']; i++)
                            Icon(
                              Icons.star_rate_sharp,
                              color: Colors.amber,
                            ),
                        ],
                      )
                    ],
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}
