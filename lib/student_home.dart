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
    super.initState();
    getName();
    getPicture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      appBar: AppBar(
        title: name == "" ? CircularProgressIndicator() : Text(name, style: TextStyle(fontSize: 25)),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (res) => _addOrRemoveClassDialog(res),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                child: Text("Add A New Class"),
                value: "Add"
              ),
              PopupMenuItem<String>(
                child: Text("Remove A Class"),
                value: "Remove"
              ),
            ],
          )
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green[500],
              Colors.blue[900],
            ],
            begin: const Alignment(0.5, 0.5),
            end: const Alignment(1, -1),
          )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(width: 10),
            Container(
              height: MediaQuery.of(context).size.height/2-75,
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
                },
              ),
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
                          color: Colors.transparent.withAlpha(10),
                          child: Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text(classes[index], style: TextStyle(fontSize: 20)),
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
      )
    );
  }
  Future takeImage() async{
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

  Future chooseImage() async{
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

  _addOrRemoveClassDialog(String action) async{
    TextEditingController codeCont;
    if(action == "Add"){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return SimpleDialog(
            title: Text("Enter The Code Of The Class", style: TextStyle(fontSize: 20)),
            children: <Widget>[
              TextField(
                controller: codeCont,
                autofocus: true,
                autocorrect: false,
                decoration: InputDecoration(hintText: "Code", prefixIcon: Icon(Icons.code)),
                onSubmitted: (code) async{
                  if(await classExists(code) == "Added"){
                    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Class Successfully Added!")));
                  }
                  else if(await classExists(code) == "Class Exists Already"){
                    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("You Are Already Enrolled In This Class")));
                  }
                  else{
                    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Class Does Not Exist")));
                  }
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
      );
    }
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
      await db.collection('/names').document(uid).collection('Classes')
        .document(code).setData({'ID' : snap.data['ID']}, merge: true);
      await db.collection('Classes').document(code).collection('Students').document(uid).setData({'Name' : name}, merge: true);
      await db.collection('Classes').document(code).collection('Students').document(uid).setData({'Pic' : pictureUrl}, merge: true);
      return "Added";
    }
    return "Does Not Exist";
  }
}
