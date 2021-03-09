import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_and_doctor_appointment/register.dart';

import 'mainPage.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Builder(builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(10, 135, 10, 10),
                child: withEmailPassword(),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget withEmailPassword() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              child: const Text(
                'Hello\nThere.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50.0,
                ),
              ),
              alignment: Alignment.centerLeft,
            ),
            SizedBox(
              height: 30.0,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
                focusedBorder: new UnderlineInputBorder(
                  borderSide: new BorderSide(color: Colors.black, width: 1.5),
                ),
              ),
              validator: (value) {
                if (value.isEmpty) return 'Please enter some text';
                return null;
              },
            ),
            SizedBox(
              height: 25.0,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
                focusedBorder: new UnderlineInputBorder(
                  borderSide: new BorderSide(color: Colors.black, width: 1.5),
                ),
              ),
              validator: (value) {
                if (value.isEmpty) return 'Please enter some text';
                return null;
              },
              obscureText: true,
            ),
            Container(
              padding: const EdgeInsets.only(top: 50.0),
              alignment: Alignment.center,
              child: ButtonTheme(
                minWidth: double.infinity,
                height: 55.0,
                child: RaisedButton(
                  elevation: 10.0,
                  color: Colors.black,
                  textColor: Colors.white,
                  child: Text(
                    "LOGIN",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      showLoaderDialog(context);
                      _signInWithEmailAndPassword();
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(35.0),
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    FlatButton(
                      onPressed: () => _pushPage(context, Register()),
                      child: Text(
                        "Signup here",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 15), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _signInWithEmailAndPassword() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return MainPage(
          user: user,
        );
      }));
      //Navigator.pop(context);
    } catch (e) {
      print(">>> " + e.toString());
      final snackBar = SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outlined),
            Text(" There was a problem signing you in"),
          ],
        ),
      );
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  void _signOut() async {
    await _auth.signOut();
  }

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}
