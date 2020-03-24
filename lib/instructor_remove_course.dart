import 'package:flutter/material.dart';
import 'instructor_course_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_names/login_home.dart';

//Going to be changed to a listview builder instead...
/*
 * Home page for the instructors.
 */
class InstructorRemoveCourse extends StatefulWidget {
  @override
  _InstructorRemoveCourseState createState() => _InstructorRemoveCourseState();
}

class _InstructorRemoveCourseState extends State<InstructorRemoveCourse> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Center(child: const Text('Your Courses')),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.settings,
                ),
                onPressed: () {
                  setState(() {});
                }, //Add course, remove course
              )
            ]),
        body: Text(''),
    );
  }
}


