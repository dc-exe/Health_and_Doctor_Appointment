import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_and_doctor_appointment/cardModel.dart';
import 'package:health_and_doctor_appointment/doctorProfile.dart';
import 'package:health_and_doctor_appointment/exploreList.dart';
import 'package:health_and_doctor_appointment/firebaseAuth.dart';
import 'package:health_and_doctor_appointment/homePage.dart';
import 'package:health_and_doctor_appointment/myAppointments.dart';
import 'package:health_and_doctor_appointment/nearbyModel.dart';
import 'package:health_and_doctor_appointment/userProfile.dart';
import 'package:health_and_doctor_appointment/doctorsList.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  List<Widget> _pages = [
    HomePage(),
    DoctorsList(),
    //Center(child: Text('New Appointment')),
    MyAppointments(),
    UserProfile(),
  ];

  FirebaseAuth _auth = FirebaseAuth.instance;
  User user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String _message;
    DateTime now = DateTime.now();
    String _currentHour = DateFormat('kk').format(now);
    int hour = int.parse(_currentHour);

    setState(() {
      if (hour >= 5 && hour < 12) {
        _message = 'Good Morning';
      } else if (hour >= 12 && hour <= 17) {
        _message = 'Good Afternoon';
      } else if ((hour > 17 && hour <= 23) || (hour >= 0 && hour < 5)) {
        _message = 'Good Evening';
      }
    });

    return Container(
      color: Colors.white,
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     begin: Alignment.topCenter,
      //     end: Alignment.bottomCenter,
      //     stops: [0.1, 0.7],
      //     colors: [
      //       Colors.lightBlue[50],
      //       Colors.lightBlue[100],
      //     ],
      //   ),
      // ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        body: _pages[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
              child: GNav(
                curve: Curves.easeOutExpo,
                rippleColor: Colors.grey[300],
                hoverColor: Colors.grey[100],
                haptic: true,
                tabBorderRadius: 20,
                gap: 8,
                activeColor: Colors.white,
                iconSize: 25,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.blue.withOpacity(0.7),
                textStyle: GoogleFonts.lato(
                  color: Colors.white,
                ),
                tabs: [
                  GButton(
                    icon: FlutterIcons.home_fou,
                    text: 'Home',
                  ),
                  GButton(
                    icon: FlutterIcons.search1_ant,
                    text: 'Search',
                  ),
                  GButton(
                    icon: FlutterIcons.calendar_clock_mco,
                    text: 'Schedule',
                  ),
                  GButton(
                    icon: FlutterIcons.user_ant,
                    text: 'Profile',
                  ),
                ],
                // items: <BottomNavigationBarItem>[
                //   BottomNavigationBarItem(
                //     icon: _selectedIndex == 0
                //         ? Icon(
                //             Icons.home,
                //             size: 30,
                //           )
                //         : Icon(
                //             Icons.home_outlined,
                //             size: 30,
                //           ),
                //     label: 'Home',
                //     backgroundColor: Colors.blue[100],
                //   ),
                //   BottomNavigationBarItem(
                //     icon: _selectedIndex == 1
                //         ? Icon(
                //             FlutterIcons.search_faw,
                //             size: 26,
                //           )
                //         : Icon(
                //             FlutterIcons.search1_ant,
                //             size: 26,
                //           ),
                //     label: 'Find',
                //     backgroundColor: Colors.blue[100],
                //   ),
                //   BottomNavigationBarItem(
                //     icon: Icon(
                //       Icons.add_circle_sharp,
                //       size: 32,
                //     ),
                //     label: 'Add',
                //     backgroundColor: Colors.blue[100],
                //   ),
                //   BottomNavigationBarItem(
                //     icon: Icon(
                //       FlutterIcons.calendar_clock_mco,
                //       size: 28,
                //     ),
                //     label: 'My Appointments',
                //     backgroundColor: Colors.blue[100],
                //   ),
                //   BottomNavigationBarItem(
                //     icon: _selectedIndex == 4
                //         ? Icon(
                //             Icons.account_circle_rounded,
                //             size: 30,
                //           )
                //         : Icon(
                //             Icons.account_circle_outlined,
                //             size: 30,
                //           ),
                //     label: 'Account',
                //     backgroundColor: Colors.blue[100],
                //   ),
                // ],
                selectedIndex: _selectedIndex,
                onTabChange: _onItemTapped,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
