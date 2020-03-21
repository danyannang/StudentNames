import 'package:flutter/material.dart';
import 'package:student_names/instructor_home.dart';
import 'package:student_names/student_home.dart';

/*
 * Choose to login as instructor or student.
 */
class LoginHome extends StatefulWidget {
  @override
  _LoginHomeState createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Center(child: const Text('Login as...')),
          leading: new IconButton(
            icon: new Icon(Icons.sentiment_neutral, color: Colors.white), //This is just here to help center title...
            onPressed: null,
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
        padding: EdgeInsets.all(50.0),
        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image(
                image: NetworkImage('https://img.freepik.com/free-vector/man-woman-symbol_77417-537.jpg?size=626&ext=jpg'), //Placeholder, maybe actually have a logo or something here after
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: ButtonTheme(
                height: MediaQuery.of(context).size.height/20,
                child: RaisedButton(
                    elevation: 25,
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => InstructorHome())),
                    child: Text(
                  'Instructor',
                )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: ButtonTheme(
                height: MediaQuery.of(context).size.height/20,
                child: RaisedButton(
                    elevation: 25,
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StudentHome())),
                    child: Text(
                  'Student',
                )
                ),
              ),
            ),
            Spacer(),
          ],
        )),
      ),
    );
  }
}