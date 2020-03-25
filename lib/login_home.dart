import 'package:flutter/material.dart';
import 'package:student_names/instructor_home.dart';
import 'package:student_names/student_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


//Alert button: https://stackoverflow.com/questions/53844052/how-to-make-an-alertdialog-in-flutter


Future<String> getUID() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  return user.uid;
}

Future<String> getName(id) async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  return user.displayName;
}

/*
 * Choose to login as instructor or student.
 */
class LoginHome extends StatefulWidget {
  @override
  _LoginHomeState createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  String name = "";
  String id;
  TextEditingController newName = new TextEditingController();
  var snapShot;

  /*
   * Creates a new document with the default name if it doesn't already exist in the database
   */
  void _checkUserName() async {
    id = await getUID();
    name = await getName(id);
    snapShot = Firestore.instance
        .collection('names')
        .document(id);
    final snapShotCheck = await snapShot.get();

    if (snapShotCheck == null || !snapShotCheck.exists) {
      // If current doc doesn't exist, make one for the user
      // go to a page maybe named "New User" to change the name.
      snapShot.setData({'name':'$name'}, merge: true);
    }
    else {
      // name = await snapShot.get().then((DocumentSnapshot ds) {
        // return ds.data['name'];
      // });
      // print(name);
      // setState((){});
    }
  }

  showChangeNameDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        name = newName.text;
        print(name);
        snapShot.setData({'name':'$name'});
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Set your name"),
      content: TextField(
        autofocus: true,
        controller: newName,
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState(){
    super.initState();
    _checkUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Center(child: Text('Welcome, $name')),
          leading: new IconButton(
            icon: new Icon(Icons.sentiment_neutral, color: Colors.white), //This is just here to help center title...
            onPressed: null,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings, //Change name to be identified as
              ),
              onPressed: () {
                showChangeNameDialog(context);
                print(name);
                setState((){});
              },
            )
          ]
      ),
      body: Padding(
        padding: EdgeInsets.all(50.0),
        child: Center(child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Image(
                image: NetworkImage('https://img.freepik.com/free-vector/man-woman-symbol_77417-537.jpg?size=626&ext=jpg'), //Placeholder, maybe actually have a logo or something here after
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 10.0, left: 10.0, right: 10.0),
              child: ButtonTheme(
                height: 50,
                child: RaisedButton(
                  elevation: 25,
                  onPressed: () {
                    Firestore.instance.collection('names').document(id).setData({'Type' : 'Instructor'}, merge: true);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => InstructorHome()));
                  },
                  child: Text(
                    'Instructor',
                    style: TextStyle(fontSize: 25),
                  )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 25.0, left: 10.0, right: 10.0),
              child: ButtonTheme(
                height: 50,
                child: RaisedButton(
                  elevation: 25,
                  onPressed: () {
                    Firestore.instance.collection('names').document(id).setData({'Type' : 'Student'}, merge: true);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => StudentHome()));
                  },
                  child: Text(
                    'Student',
                    style: TextStyle(fontSize: 25),
                  )
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}