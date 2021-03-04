import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_and_doctor_appointment/mainPage.dart';
import 'package:health_and_doctor_appointment/signIn.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _displayName = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSuccess;
  String _userEmail;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.fromLTRB(26, 135, 26, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50.0,
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  controller: _displayName,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                    focusedBorder: new UnderlineInputBorder(
                      borderSide:
                          new BorderSide(color: Colors.black, width: 1.5),
                    ),
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                    focusedBorder: new UnderlineInputBorder(
                      borderSide:
                          new BorderSide(color: Colors.black, width: 1.5),
                    ),
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                    focusedBorder: new UnderlineInputBorder(
                      borderSide:
                          new BorderSide(color: Colors.black, width: 1.5),
                    ),
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  alignment: Alignment.center,
                  child: ButtonTheme(
                    minWidth: double.infinity,
                    height: 55.0,
                    child: RaisedButton(
                      elevation: 7.0,
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Text("SIGNUP"),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _registerAccount();
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(35.0)),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  alignment: Alignment.center,
                  child: ButtonTheme(
                    minWidth: double.infinity,
                    height: 50.0,
                    child: OutlineButton(
                      //elevation: 7.0,
                      color: Colors.black,
                      textColor: Colors.black,
                      child: Text("LOGIN"),
                      onPressed: () => _pushPage(context, SignIn()),
                      borderSide: BorderSide(width: 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(35.0)),
                      highlightedBorderColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  void _registerAccount() async {
    final User user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;

    if (user != null) {
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
      await user.updateProfile(displayName: _displayName.text);
      final user1 = _auth.currentUser;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MainPage(
                user: user1,
              )));
    } else {
      _isSuccess = false;
    }
  }

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}
