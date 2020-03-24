import 'package:flutter/material.dart';
import 'instructor_course_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_names/login_home.dart';

//Going to be changed to a listview builder instead...
/*
 * Home page for the instructors.
 */
class InstructorAddCourse extends StatefulWidget {
  @override
  _InstructorAddCourseState createState() => _InstructorAddCourseState();
}

class _InstructorAddCourseState extends State<InstructorAddCourse> {
  String id;
  String name;
  TextEditingController courseName = new TextEditingController();
  TextEditingController coursePass = new TextEditingController();

  void _getInstructorInfo() async{
    id = await getUID();
    name = await getName(id);
  }

  void _createNewClass() async {
    Firestore.instance.collection(id + 'CLASSES').document(courseName.text)
        .setData({ 'instructor': name, 'password': coursePass.text });
  }

  @override
  void initState() {
    super.initState();
    _getInstructorInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Center(child: const Text('Add a Course')),
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
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Your new course\'s name:',
              ),
              controller: courseName,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password for students:',
              ),
              controller: coursePass,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: RaisedButton(
                  elevation: 25,
                  onPressed: (){
                    _createNewClass();
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Confirm'
                  )),
            )
          ],
        )
      ),
    );
  }
}


