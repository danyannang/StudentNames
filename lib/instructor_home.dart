import 'package:flutter/material.dart';
import 'instructor_course_home.dart';
//Going to be changed to a listview builder instead...
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
      appBar: AppBar(
          centerTitle: true,
          title: Center(child: const Text('Your Courses')),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
              ),
              onPressed: null, //Add course, remove course
            )
          ]),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Center(
            child: ListView(
          children: <Widget>[
            ButtonTheme(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    elevation: 25,
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InstructorCourseHome())),
                    child: Text(
                      'Course 1',
                    )),
              ),
            ),
            ButtonTheme(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InstructorCourseHome())),
                    child: Text(
                      'Course 2',
                    )),
              ),
            ),
            ButtonTheme(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InstructorCourseHome())),
                    child: Text(
                      'Course 3',
                    )),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
