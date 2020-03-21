import 'package:flutter/material.dart';

/*
 * After selecting a course, an instructor has three different options.
 */
class InstructorCourseHome extends StatefulWidget {
  @override
  _InstructorCourseHomeState createState() => _InstructorCourseHomeState();
}

class _InstructorCourseHomeState extends State<InstructorCourseHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(child: const Text('Course Name (Placeholder)')),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
              ),
              onPressed: null,
            )
          ]
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ButtonTheme(
              height: MediaQuery.of(context).size.height/5,
              child: RaisedButton(
                  elevation: 25,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'View Students',
                  )
              ),
            ),
            ButtonTheme(
              height: MediaQuery.of(context).size.height/5,
              child: RaisedButton(
                  elevation: 25,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Review',
                  )
              ),
            ),
            ButtonTheme(
              height: MediaQuery.of(context).size.height/5,
              child: RaisedButton(
                  elevation: 25,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Games',
                  )
              ),
            ),
          ],
        )),
      ),
    );
  }
}