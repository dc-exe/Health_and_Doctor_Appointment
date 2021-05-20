import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

//0import 'package:cleanbin/HomePage.dart';
//import 'package:cleanbin/SignUp.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _passwordController = TextEditingController();

  String _email, _password, user;

  FocusNode f1 = new FocusNode();
  FocusNode f2 = new FocusNode();

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, "/Doctorpage");
      }
    });
  }

// mydoc123 doc1234
  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
  }

  bool emailValidate(String email) {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return true;
    } else {
      return false;
    }
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

  login() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

      Navigator.of(context).pushNamedAndRemoveUntil(
          '/Doctorpage', (Route<dynamic> route) => false);
    } catch (e) {
      final snackBar = SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            Text(" There was a problem signing you in"),
          ],
        ),
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR SOMTHING WENT WRONG WITH ID AND PASS'),
            content: Text(errormessage),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login as Doctor",
              style: GoogleFonts.lato(
                  color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 400,
                    child: Image(
                      image: AssetImage("assets/vector-doc2.jpg"),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: TextFormField(
                              focusNode: f1,
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 20, top: 10, bottom: 10),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(90.0)),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey[350],
                                hintText: 'Email',
                                hintStyle: GoogleFonts.lato(
                                  color: Colors.black26,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              onFieldSubmitted: (value) {
                                f1.unfocus();
                                FocusScope.of(context).requestFocus(f2);
                              },
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter the Email';
                                } else if (!emailValidate(value)) {
                                  return 'Please enter correct Email';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Container(
                            child: TextFormField(
                              focusNode: f2,
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                              //keyboardType: TextInputType.visiblePassword,
                              controller: _passwordController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 20, top: 10, bottom: 10),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(90.0)),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey[350],
                                hintText: 'Password',
                                hintStyle: GoogleFonts.lato(
                                  color: Colors.black26,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Please enter the Password';
                                return null;
                              },
                              obscureText: true,
                            ),
                          ),
                          SizedBox(height: 20),
                          // ignore: deprecated_member_use
                          Container(
                            padding: const EdgeInsets.only(top: 25.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                child: Text(
                                  "Sign In",
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    showLoaderDialog(context);
                                    login();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 2,
                                  primary: Colors.indigo[900],
                                  onPrimary: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
