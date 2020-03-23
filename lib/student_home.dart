import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
 * Home page for the students.
 */
class StudentHome extends StatefulWidget {
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  File picture;
  String name = "";

  @override
  void initState(){
    super.initState();
    getName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Center(child: const Text('Home')),
        actions: <Widget>[
          IconButton(
            icon: Icon( //Centering the title...
              null,
            ),
            onPressed: null,
          ),
        ]
      ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.camera),
        children: [
          SpeedDialChild(
            label: "Take A Picture",
            child: Icon(Icons.camera_alt),
            onTap: () => takeImage(),
          ),
          SpeedDialChild(
            label: "Choose A Picture",
            child: Icon(Icons.camera_roll),
            onTap: () => getImage(),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Container(
              height: 250,
              child: picture == null ? Placeholder(color: Colors.blue,) : 
                Image.file(picture),
            ),
            SizedBox(height: 20),
            name == "" ? CircularProgressIndicator() :
              Text(name, style: TextStyle(fontSize: 30)),
          ],
        )
      ),
    );
  }
  Future takeImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      picture = image;
    });
  }

  Future getImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      picture = image;
    });
  }

  getName() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var id = user.uid;
    DocumentSnapshot doc = await Firestore.instance.collection('names').document(id).get();
    setState(() {
      name = doc.data['name'];
    });
  }
}
