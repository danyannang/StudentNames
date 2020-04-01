import 'package:flutter/material.dart';
import 'dart:io';

class StudentReview extends StatefulWidget {
  List<String> studentName = new List<String>();
  List<String> studentPic = new List<String>();
  StudentReview(this.studentName, this.studentPic);
  @override
  _StudentReviewState createState() => _StudentReviewState(studentName, studentPic);
}

class _StudentReviewState extends State<StudentReview> {
  List<String> studentName = new List<String>();
  List<String> studentPic = new List<String>();
  _StudentReviewState(this.studentName, this.studentPic);
  final GlobalKey<ScaffoldState> scaffoldRevKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldRevKey,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(title: Text("Student Review"),),
      body: Center(
        child: PageView.builder(
          itemCount: studentName.length,
          itemBuilder: (BuildContext context, int index){
            return Card(
              child: GestureDetector(
                onTap: () => scaffoldRevKey.currentState.showSnackBar(SnackBar(content: Text(studentName[index]), duration: Duration(seconds: 1))),
                child: Image.network(studentPic[index])
              ),
            );
          },
        ),
      ),
    );
  }
}