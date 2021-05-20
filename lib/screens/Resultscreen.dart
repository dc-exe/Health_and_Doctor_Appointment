import 'package:flutter/material.dart';
//import 'HomePage.dart';
import 'Doctorpage.dart';

import 'package:firebase_auth/firebase_auth.dart';

// ignore: camel_case_types

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  navigateToLogin() async {
    Navigator.pushReplacementNamed(context, "firebaseAuth");
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User user;
  bool isloggedin = false;

//get maxLines => true;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
//Navigator.push(context, MaterialPageRoute(builder: (context)=> Start()));
        Navigator.pushReplacementNamed(context, "Signin2");
      }
    });
  }

  getUser() async {
    User firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isloggedin = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();
  }

  @override
// ignore: must_call_super
  void initState() {
    this.checkAuthentification();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Medico'),
        ),
        body: SingleChildScrollView(
            child: Container(
          child: !isloggedin
              ? CircularProgressIndicator()
              : Column(
                  children: <Widget>[
                    SizedBox(height: 40.0),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Thank You DR. ${user.displayName} See You Soon !! ",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),

// ignore: deprecated_member_use
                    RaisedButton(
                        padding: EdgeInsets.only(left: 35, right: 30),
                        onPressed: signOut,
                        child: Text(
                          'SIGNOUT',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.orange),
                    SizedBox(width: 20.0),

// ignore: deprecated_member_use

/*RaisedButton(
                  padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                  onPressed: signOut,
                  child: Text('Signout',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                  color: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                )*/
                  ],
                ),
        )));
  }
}
