import 'package:flutter/material.dart';

/*
 * Home page for the instructors.
 */
class InstructorHome extends StatefulWidget {
  @override
  _InstructorHomeState createState() => _InstructorHomeState();
}

class _InstructorHomeState extends State<InstructorHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Instructor Home"),),
    );
  }
}