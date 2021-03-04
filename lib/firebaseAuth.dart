import 'package:flutter/material.dart';
import 'package:health_and_doctor_appointment/register.dart';
import 'package:health_and_doctor_appointment/signIn.dart';

class FireBaseAuth extends StatefulWidget {
  @override
  _FireBaseAuthState createState() => _FireBaseAuthState();

  // void out2(BuildContext context) {
  //   Navigator.pop(context);
  // }
}

class _FireBaseAuthState extends State<FireBaseAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Firebase Auth"),
      // ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 110.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Text(
                  'Welcome!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                  ),
                ),
              ),
              SizedBox(
                height: 160.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: ButtonTheme(
                      minWidth: double.infinity,
                      height: 50.0,
                      child: RaisedButton(
                        color: Colors.white,
                        child: Text(
                          "Sign in",
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () => _pushPage(context, SignIn()),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25),
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                  ),
                  Container(
                    child: ButtonTheme(
                      minWidth: double.infinity,
                      height: 50.0,
                      child: RaisedButton(
                        color: Colors.greenAccent,
                        child: Text(
                          "Create an account",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        onPressed: () => _pushPage(context, Register()),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(25),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ), //<--
    );
  }

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}
