import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_and_doctor_appointment/screens/register.dart';
import 'package:health_and_doctor_appointment/screens/signIn.dart';

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
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/image-medical.jpg",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: 80.0, left: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HELLO',
                      style: GoogleFonts.b612(
                          color: Colors.black,
                          fontSize: 50,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Welcome to Medico!',
                      style: GoogleFonts.b612(
                          color: Colors.indigo[800],
                          fontSize: 17,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.black26.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50.0,
                            child: ElevatedButton(
                              child: Text(
                                "Sign in",
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () => _pushPage(context, SignIn()),
                              style: ElevatedButton.styleFrom(
                                elevation: 2,
                                primary: Colors.indigo[800],
                                onPrimary: Colors.indigo[800],
                                shape: RoundedRectangleBorder(
                                  
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.center,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50.0,
                            child: ElevatedButton(
                              child: Text(
                                "Create an Account",
                                style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () => _pushPage(context, Register()),
                              style: ElevatedButton.styleFrom(
                                elevation: 2,
                                primary: Colors.white,
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.center,
                        ),
                        // Container(
                        //   width: MediaQuery.of(context).size.width / 1.1,
                        //   child: ButtonTheme(
                        //     minWidth: double.infinity,
                        //     height: 50.0,
                        //     child: RaisedButton(
                        //       color: Colors.indigo[800],
                        //       child: Text(
                        //         "Create an account",
                        //         style: GoogleFonts.lato(
                        //           color: Colors.white,
                        //           fontSize: 18.0,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //       onPressed: () => _pushPage(context, Register()),
                        //     ),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: new BorderRadius.circular(25),
                        //     ),
                        //   ),
                        //   padding: const EdgeInsets.all(16),
                        //   alignment: Alignment.center,
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ),
          ),
        ],
      ), //<--
    );
  }

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}
