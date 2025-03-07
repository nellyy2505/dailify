import 'package:flutter/material.dart';
// import 'package:calendar_view/calendar_view.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body:Center(
        child: Text("calendar"),
      )
    );
  }
}