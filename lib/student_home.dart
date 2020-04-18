import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  Firestore db = Firestore.instance;
  List<String> classes = new List<String>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  void initState(){
    getNameandPic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      backgroundColor: Color(0xFFC3C5C7),
      appBar: AppBar(
        backgroundColor: Color(0xFF249e7e),
        title: name == "" ? CircularProgressIndicator() : Text(name, style: TextStyle(fontSize: 25)),
        actions: <Widget>[
          FlatButton(
            padding: EdgeInsets.only(left: 30),
            child: Icon(Icons.add, color: Colors.white, size: 30,),
            onPressed: () => _addClassDialog(),
          )
        ]
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Color(0xFF249e7e),
        child: Icon(Icons.camera),
        children: [
          SpeedDialChild(
            label: "Take A Picture",
            child: Icon(Icons.camera_alt),
            backgroundColor: Color(0xFF249e7e),
            onTap: () => takeImage(),
          ),
          SpeedDialChild(
            label: "Choose A Picture",
            child: Icon(Icons.camera_roll),
            backgroundColor: Color(0xFF249e7e),
            onTap: () => chooseImage(),
          ),
        ],
      ),
      body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 20),
            Container(
              height: MediaQuery.of(context).size.height/2-75,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: pictureUrl == null ? Placeholder(color: Color(0xFF249e7e)) : Image.network(pictureUrl,
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
                },
              ),
              )
            ),
            SizedBox(height: 20),
            Container(
              height: MediaQuery.of(context).size.height/2-50,
              child: StreamBuilder<QuerySnapshot>(
                stream: db.collection('/names').document(uid).collection('Classes').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap){
                  if(snap.hasData){
                    classes.clear();
                    snap.data.documents.forEach((data){
                      classes.add(data.documentID);
                    });
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: classes.length,
                      itemBuilder: (BuildContext context, int index){
                        return new Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          color: Color(0xFF249e7e),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                dense: true,
                                title: Text(classes[index], textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Colors.white)),
                                onLongPress: () => removeClass(classes[index]),
                              ),
                            ]
                          )
                        );
                      }
                    );
                  }
                  else{
                    return Center(
                      child: CircularProgressIndicator()
                    );
                  }
                },
              ),
            )
          ],
        )
    );
  }
  Future takeImage() async{
    bool res = await showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("When taking an image please make sure you're as close to the center as possible."),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel", style: TextStyle(color: Color(0xFF249e7e))),
              onPressed: () => Navigator.pop(context, false),
            ),
            FlatButton(
              child: Text("OK", style: TextStyle(color: Color(0xFF249e7e))),
              onPressed: () => Navigator.pop(context, true),
            )
          ],
        );
      }
    );
    if(res){
      var image = await ImagePicker.pickImage(source: ImageSource.camera);
      StorageReference storageReference = FirebaseStorage.instance.ref().child(uid);    
      StorageUploadTask uploadTask = storageReference.putFile(image);    
      await uploadTask.onComplete;    
      await storageReference.getDownloadURL().then((fileURL) {    
        db.collection('/names').document(uid).setData({"Pic" : fileURL}, merge: true);
      }).then((_){
        getPicture();
      });
    }
  }

  Future chooseImage() async{
    bool res = await showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("When taking an image please make sure you're as close to the center as possible."),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel", style: TextStyle(color: Color(0xFF249e7e))),
              onPressed: () => Navigator.pop(context, false),
            ),
            FlatButton(
              child: Text("OK", style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.pop(context, true),
            )
          ],
        );
      }
    );
    if(res){
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      StorageReference storageReference = FirebaseStorage.instance.ref().child(uid);    
      StorageUploadTask uploadTask = storageReference.putFile(image);    
      await uploadTask.onComplete;    
      await storageReference.getDownloadURL().then((fileURL) {    
        db.collection('/names').document(uid).setData({"Pic" : fileURL}, merge: true);
      }).then((_){
        getPicture();
      });
    }
  }

  getName() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    uid = user.uid;
    DocumentSnapshot doc = await db.collection('names').document(uid).get();
    setState(() {
      name = doc.data['name'];
    });
  }

  getStockPic() async{
    await FirebaseAuth.instance.currentUser().then((user){
      pictureUrl = user.photoUrl;
      setState(() {
      });
    });
  }

  getPicture() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    uid = user.uid;
    await db.collection('/names').document(uid).get().then((data){
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

  _addClassDialog() async{
    TextEditingController codeCont;
    showDialog(
      context: context,
      builder: (BuildContext context){
        return SimpleDialog(
          backgroundColor: Color(0xFFE3E5E7),
          titlePadding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
          title: Text("Enter The Code Of The Class", style: TextStyle(fontSize: 20, color: Color(0xFF249e7e))),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
          children: <Widget>[
            TextField(
              controller: codeCont,
              cursorColor: Color(0xFF249e7e),
              autofocus: true,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: "Code",
                icon: Icon(Icons.code),
              ),
              onSubmitted: (code) async{
                if(await classExists(code) == "Added"){
                  scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Class Successfully Added!"), duration: Duration(seconds: 3)));
                }
                else if(await classExists(code) == "Class Exists Already"){
                  scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("You Are Already Enrolled In This Class"), duration: Duration(seconds: 3)));
                }
                else if(await classExists(code) == "Cancelled"){
                  scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Operation Cancelled"), duration: Duration(seconds: 3)));
                }
                else{
                  scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Class Does Not Exist"), duration: Duration(seconds: 3)));
                }
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    );
  }

  removeClass(String index) async{
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Are you sure you want to remove this class?"),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context), 
              child: Text("No", style: TextStyle(color: Colors.red))
            ),
            FlatButton(
              onPressed: (){
                db.collection('/names').document(uid).collection('Classes').document(index).delete();
                db.collection('/Classes').document(index).collection('Students').document(uid).delete();
                Navigator.pop(context);
              }, 
              child: Text("Yes", style: TextStyle(color: Color(0xFF249e7e)))
            ),
          ],
        );
      }
    );
  }

  Future<String> classExists(String code) async{
    final snap = await db.collection('/Classes').document(code).get();
    if(snap.exists){
      bool studentExist = false;
      await db.collection('/names').document(uid).collection('Classes').getDocuments().then((data){
        data.documents.forEach((d){
          if(d.documentID == code){
            print("Class Matches: ${d.documentID}");
            studentExist = true;
          }
        });
      });
      if(studentExist == true){
        return "Class Exists Already";
      }
      if(await _displayClassInfo(code)){
        await db.collection('/names').document(uid).collection('Classes')
          .document(code).setData({'ID' : snap.data['ID']}, merge: true);
        await db.collection('Classes').document(code).collection('Students').document(uid).setData({'Name' : name}, merge: true);
        await db.collection('Classes').document(code).collection('Students').document(uid).setData({'Pic' : pictureUrl}, merge: true);
        return "Added";
      }
      else{
        return "Cancelled";
      }
    }
    return "Does Not Exist";
  }

  Future<bool> _displayClassInfo(String code) async{
    String courseName;
    String instructorName;
    await db.collection('/Classes').document(code).get().then((data){
      courseName = data.data['Name'];
      instructorName = data.data['Instructor'];
    });
    bool res = await showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          content: Text(courseName + " with " + instructorName),
          title: Text("Are you sure you want to add this class?"),
          actions: <Widget>[
            FlatButton(
              child: Text("No", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            FlatButton(
              child: Text("Yes", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      }
    );
    return res;
  }

  getNameandPic() async{
    await getName();
    await getPicture();
    setState((){});
  }

}
