import 'package:flutter/material.dart';

class InstructorMatch extends StatefulWidget {
  List<String> studentName = new List<String>();
  List<String> studentPic = new List<String>();
  InstructorMatch(this.studentName, this.studentPic);

  @override
  _InstructorMatchState createState() => _InstructorMatchState(studentName, studentPic);
}

class _InstructorMatchState extends State<InstructorMatch> {
  List<String> studentName = new List<String>();
  List<String> studentPic = new List<String>();
  _InstructorMatchState(this.studentName, this.studentPic);

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}