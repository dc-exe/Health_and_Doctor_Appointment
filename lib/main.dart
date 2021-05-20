import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_and_doctor_appointment/screens/Doctorpage.dart';
import 'package:health_and_doctor_appointment/screens/doctorPrevAppointments.dart';
import 'package:health_and_doctor_appointment/screens/doctorProfile.dart';
import 'package:health_and_doctor_appointment/screens/firebaseAuth.dart';
import 'package:health_and_doctor_appointment/mainPage.dart';
import 'package:health_and_doctor_appointment/screens/myAppointments.dart';
import 'package:health_and_doctor_appointment/screens/skip.dart';
import 'package:health_and_doctor_appointment/screens/userProfile.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  var flag = 0;
  final docList = [
    'jugal.shah@mail.com',
    'kunal.makhija@mail.com',
    'quresh.maskati@mail.com',
    'suhani.talesara@mail.com',
    'darshan.vora@mail.com',
    'manoj.thamke@mail.com',
    'ashwin.mehta@mail.com',
    'shilpa.nayak@mail.com',
    'yajuvendra.gawai@mail.com',
    'kartik@mail.com'
  ];

  Future<void> _getUser() async {
    user = _auth.currentUser;
    if (docList.contains(user.email) && user.email != null) {
      flag = 1;
    }
    print("flag = " + flag.toString());
  }

  @override
  Widget build(BuildContext context) {
    _getUser();
    return MaterialApp(
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => user == null
            ? Skip()
            : flag == 1
                ? Doctorpage()
                : MainPage(),
        '/login': (context) => FireBaseAuth(),
        '/home': (context) => MainPage(),
        '/profile': (context) => UserProfile(),
        '/MyAppointments': (context) => MyAppointments(),
        '/DoctorProfile': (context) => DoctorProfile(),
        '/Doctorpage': (context) => Doctorpage(),
        '/prevDoctor': (context) => DocPrevAppointments(),
      },
      theme: ThemeData(brightness: Brightness.light),
      debugShowCheckedModeBanner: false,
      //home: FirebaseAuthDemo(),
    );
  }
}
