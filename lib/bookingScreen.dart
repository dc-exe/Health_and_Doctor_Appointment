import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_and_doctor_appointment/myAppointments.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final String doctor;

  const BookingScreen({Key key, this.doctor}) : super(key: key);
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _doctorController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  String timeText = 'Select Time';
  String dateUTC;
  String _year, _month, _date;
  String date_Time;

  FirebaseAuth _auth = FirebaseAuth.instance;
  User user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  Future<void> selectTime(BuildContext context) async {
    TimeOfDay selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );

    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    String formattedTime = localizations.formatTimeOfDay(selectedTime,
        alwaysUse24HourFormat: false);

    if (formattedTime != null) {
      setState(() {
        timeText = formattedTime;
        _timeController.text = timeText;
      });
    }
    date_Time = selectedTime.toString().substring(10, 15);
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(
        "OK",
        style: GoogleFonts.lato(fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyAppointments(),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(
        children: [
          Icon(Icons.check_circle),
          SizedBox(width: 10),
          Text(
            "Done!",
            style: GoogleFonts.lato(
              color: Colors.green[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Text(
        "Appointment registered.",
        style: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    selectTime(context);
    _doctorController.text = widget.doctor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              'Appointment booking',
              style: GoogleFonts.lato(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.only(top: 16),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Enter Patient Details',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value.isEmpty) return 'Please Enter Patient Name';
                      return null;
                    },
                    style: GoogleFonts.lato(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      labelText: "Patient Name*",
                      labelStyle: GoogleFonts.lato(color: Colors.black38),
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.black45,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    validator: (value) {
                      if (value.isEmpty) return 'Please Enter Phone number';
                      return null;
                    },
                    style: GoogleFonts.lato(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      labelText: "Mobile*",
                      labelStyle: GoogleFonts.lato(color: Colors.black38),
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.black45,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: GoogleFonts.lato(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10.0),
                      labelText: "Description(optional)",
                      labelStyle: GoogleFonts.lato(color: Colors.black38),
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.black45,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _doctorController,
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter Doctor name';
                      return null;
                    },
                    style: GoogleFonts.lato(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      labelText: "Doctor Name*",
                      labelStyle: GoogleFonts.lato(color: Colors.black38),
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.black45,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 60,
                    padding: EdgeInsets.only(right: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black87),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Select Date',
                              hintStyle: GoogleFonts.lato(
                                color: Colors.black38,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            controller: _dateController,
                            validator: (value) {
                              if (value.isEmpty) return 'Please Enter the date';
                              return null;
                            },
                            style: GoogleFonts.lato(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ClipOval(
                          child: Material(
                            color: Colors.indigo, // button color
                            child: InkWell(
                              // inkwell color
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Icon(
                                  Icons.date_range_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2021),
                                  lastDate: DateTime(2025),
                                ).then(
                                  (date) {
                                    setState(() {
                                      selectedDate = date;
                                      String formattedDate =
                                          DateFormat('dd-MM-yyyy')
                                              .format(selectedDate);
                                      _dateController.text = formattedDate;
                                      dateUTC = DateFormat('yyyy-MM-dd')
                                          .format(selectedDate);
                                      _year = DateFormat('yyyy')
                                          .format(selectedDate);
                                      _month = DateFormat('MM')
                                          .format(selectedDate);
                                      _date = DateFormat('dd')
                                          .format(selectedDate);
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 60,
                    padding: EdgeInsets.only(right: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black87),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Select Time',
                              hintStyle: GoogleFonts.lato(
                                color: Colors.black38,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            controller: _timeController,
                            validator: (value) {
                              if (value.isEmpty) return 'Please Enter the Time';
                              return null;
                            },
                            style: GoogleFonts.lato(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ClipOval(
                          child: Material(
                            color: Colors.indigo, // button color
                            child: InkWell(
                              // inkwell color
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Icon(
                                  Icons.timer_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                selectTime(context);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        primary: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          print(_nameController.text);
                          print(_dateController.text);
                          print(widget.doctor);
                          showAlertDialog(context);
                          _createAppointment();
                        }
                      },
                      child: Text(
                        "Book Appointment",
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createAppointment() async {
    // CollectionReference reference =
    //     FirebaseFirestore.instance.collection('appointments').doc().add({
    // 'name': _nameController.text,
    // 'phone': _phoneController.text,
    // 'description': _descriptionController.text,
    // 'doctor': _doctorController.text,
    // 'date': _dateController.text,
    // 'time': _timeController.text
    // });
    print(dateUTC+' '+date_Time+':00');
    FirebaseFirestore.instance
        .collection('appointments')
        .doc(user.email)
        .collection('appointments')
        .doc()
        .set({
      'name': _nameController.text,
      'phone': _phoneController.text,
      'description': _descriptionController.text,
      'doctor': _doctorController.text,
      'date': DateTime.parse(dateUTC+' '+date_Time+':00'),
    }, SetOptions(merge: true));
  }
}
