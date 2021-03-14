import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:health_and_doctor_appointment/bannerModel.dart';
import 'package:health_and_doctor_appointment/cardModel.dart';
import 'package:health_and_doctor_appointment/doctorProfile.dart';
import 'package:health_and_doctor_appointment/exploreList.dart';
import 'package:health_and_doctor_appointment/firebaseAuth.dart';
import 'package:health_and_doctor_appointment/mainPage.dart';
import 'package:health_and_doctor_appointment/userProfile.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _doctorName = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  User user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  Future _signOut() async {
    await _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    String _message;
    DateTime now = DateTime.now();
    String _currentHour = DateFormat('kk').format(now);
    int hour = int.parse(_currentHour);

    setState(
      () {
        if (hour >= 5 && hour < 12) {
          _message = 'Good Morning';
        } else if (hour >= 12 && hour <= 17) {
          _message = 'Good Afternoon';
        } else {
          _message = 'Good Evening';
        }
      },
    );
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[Container()],
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          padding: EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                //width: MediaQuery.of(context).size.width/1.3,
                alignment: Alignment.center,
                child: Text(
                  _message,
                  style: GoogleFonts.lato(
                    color: Colors.black54,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                width: 55,
              ),
              IconButton(
                splashRadius: 20,
                icon: Icon(Icons.notifications_active),
                onPressed: () {},
              ),
            ],
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowGlow();
            return;
          },
          child: ListView(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20, bottom: 10),
                    child: Text(
                      "Hello " + user.displayName,
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20, bottom: 25),
                    child: Text(
                      "Let's Find Your\nDoctor",
                      style: GoogleFonts.lato(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 25),
                    child: TextFormField(
                      controller: _doctorName,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 20, top: 10, bottom: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: 'Search doctor',
                        hintStyle: GoogleFonts.lato(
                          color: Colors.black26,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        suffixIcon: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[900].withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            iconSize: 20,
                            splashRadius: 20,
                            color: Colors.white,
                            icon: Icon(FlutterIcons.search1_ant),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    height: 150,
                    child: ListView.builder(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(left: 20.0),
                      itemCount: bannerCards.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width-40,
                          height: 140,
                          margin:
                              EdgeInsets.only(left: 0, right: 20, bottom: 20),
                          padding: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              stops: [0, 1],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: bannerCards[index].cardBackground,
                            ),
                          ),
                          child: TextButton(
                            style: ButtonStyle(
                                overlayColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.transparent)),
                            onPressed: () {},
                            child: Stack(
                              children: [
                                Image.asset(
                                  bannerCards[index].image,
                                  //'assets/414.jpg',
                                  fit: BoxFit.fitHeight,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 7, right: 5),
                                  alignment: Alignment.topRight,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        bannerCards[index].text,
                                        //'Check Disease',
                                        style: GoogleFonts.lato(
                                          color: Colors.lightBlue[900],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: Colors.lightBlue[900],
                                        size: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Explore",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  Container(
                    height: 150,
                    padding: EdgeInsets.only(top: 14),
                    child: ListView.builder(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        //print("images path: ${cards[index].cardImage.toString()}");
                        return Container(
                          margin: EdgeInsets.only(right: 14),
                          height: 150,
                          width: 140,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(cards[index].cardBackground),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[400],
                                  blurRadius: 4.0,
                                  spreadRadius: 0.0,
                                  offset: Offset(3, 3),
                                ),
                              ]
                              // image: DecorationImage(
                              //   image: AssetImage(cards[index].cardImage),
                              //   fit: BoxFit.fill,
                              // ),
                              ),
                          // ignore: deprecated_member_use
                          child: FlatButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExploreList(
                                          type: cards[index].doctor,
                                        )),
                              );
                            },
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 16,
                                ),
                                Container(
                                  child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 29,
                                      child: Icon(
                                        cards[index].cardIcon,
                                        size: 26,
                                        color:
                                            Color(cards[index].cardBackground),
                                      )),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    cards[index].doctor,
                                    style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Nearby doctors",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('doctors')
                        .orderBy('city')
                        .startAt(['Rajkot']).endAt(
                            ['Rajkot' + '\uf8ff']).snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView(
                        padding: EdgeInsets.only(top: 10, left: 18, right: 18),
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: snapshot.data.docs.map(
                          (document) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Card(
                                color: Colors.blue[50],
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 0),
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 9,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DoctorProfile(
                                                  doctor: document['name'],
                                                )),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.blue,
                                          radius: 25,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              document['name'],
                                              style: GoogleFonts.lato(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Text(
                                              document['type'],
                                              style: GoogleFonts.lato(
                                                  fontSize: 16,
                                                  color: Colors.black54),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Flexible(
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              ':',
                                              style: GoogleFonts.lato(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                color: Colors.black38,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      );
                    },
                  ),
                  SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
