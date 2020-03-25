import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

// https://stackoverflow.com/questions/50759555/check-image-is-loaded-in-image-network-widget-in-flutter

/*
 * Home page for the students.
 */
class StudentHome extends StatefulWidget {
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  String name = "";
  String uid;
  dynamic pictureUrl;


  @override
  void initState(){
    super.initState();
    getName();
    getPicture();
    getClasses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Center(child: const Text('Home')),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _addOrRemoveClassDialog(),
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
            onTap: () => chooseImage(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Container(
              height: 250,
              child: pictureUrl == null ? Placeholder(color: Colors.blue,) : Image.network(pictureUrl,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent chunk){
                  if(chunk == null){
                    return child;
                  }
                  else{
                    return Center(
                      child: CircularProgressIndicator(
                      value: chunk.expectedTotalBytes != null ? chunk.cumulativeBytesLoaded / chunk.expectedTotalBytes : null,
                    ));
                  }
                },),
            ),
            SizedBox(height: 20),
            name == "" ? CircularProgressIndicator() :
              Text(name, style: TextStyle(fontSize: 30)),
            SizedBox(height: 20),
            // ListView.builder(
            //   itemCount: ,
            //   itemBuilder: null,
            // ),
          ],
        )
      ),
    );
  }
  Future takeImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    StorageReference storageReference = FirebaseStorage.instance.ref().child(uid);    
    StorageUploadTask uploadTask = storageReference.putFile(image);    
    await uploadTask.onComplete;    
    await storageReference.getDownloadURL().then((fileURL) {    
      Firestore.instance.collection('/names').document(uid).setData({"Pic" : fileURL}, merge: true);
    }).then((_){
      getPicture();
    });
  }

  Future chooseImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    StorageReference storageReference = FirebaseStorage.instance.ref().child(uid);    
    StorageUploadTask uploadTask = storageReference.putFile(image);    
    await uploadTask.onComplete;    
    await storageReference.getDownloadURL().then((fileURL) {    
      Firestore.instance.collection('/names').document(uid).setData({"Pic" : fileURL}, merge: true);
    }).then((_){
      getPicture();
    });
  }

  getName() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    uid = user.uid;
    DocumentSnapshot doc = await Firestore.instance.collection('names').document(uid).get();
    setState(() {
      name = doc.data['name'];
    });
  }

  getStockPic() async{
    await FirebaseAuth.instance.currentUser().then((user){
      pictureUrl = user.photoUrl;
      print(pictureUrl);
      setState(() {
      });
    });
  }

  getPicture() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    uid = user.uid;
    await Firestore.instance.collection('/names').document(uid).get().then((data){
      if(data.data.containsKey('Pic')){
        pictureUrl = data.data['Pic'];
        setState(() {
        });
      }
      else{
        getStockPic();
      }
    });
  }

  getClasses() async{

  }

  _addOrRemoveClassDialog() async{
    print("_addOrRemoveClassDialog needs to be implemented.");
  }
}
