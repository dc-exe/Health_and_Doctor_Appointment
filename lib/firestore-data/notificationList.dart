import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationList extends StatefulWidget {
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            splashRadius: 20,
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.indigo,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          'Notifications',
          style: GoogleFonts.lato(
            color: Colors.indigo,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
