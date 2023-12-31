import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student_names/instructor_home.dart';
import 'package:student_names/student_home.dart';
import 'package:student_names/login_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
GoogleSignIn _googleSignIn;
final Firestore db = Firestore.instance;

/* 
 * This class is so that when the user closes the app they won't have to
 * sign back into the app. If they haven't previously signed in, it will
 * create a new LoginPage for them to login from.
 */
class SilentLogIn extends StatefulWidget {
  @override
  _SilentLogInState createState() => _SilentLogInState();
}

class _SilentLogInState extends State<SilentLogIn> {

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn(
      scopes: [
        'email'
      ]
    );
    _googleSignIn.signInSilently(suppressErrors: true).catchError((dynamic e){
      print('$e');
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new LoginPage()));
    }).then((val){
      if(val == null){
        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new LoginPage()));
      }
      else{
        _goToNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Logging You In", style: TextStyle(fontSize: 30), textAlign: TextAlign.center,),
            SizedBox(height:20),
            CircularProgressIndicator(),
          ]
        )
      )
    );
  }

  _goToNextPage() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;
    await Firestore.instance.collection('/names').document(uid).get().then((data){
      if(data.data['Type'] == 'Student'){
        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new StudentHome()));
      }
      else{
        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new InstructorHome()));
      }
    });
  }
}

/*
 * This class will create a scaffold and have a google sign in button
 * that, when pressed, will let a user use their google account to sign in.
 * We need to implement some way to tell if this a users first time ever
 * signing into this app so we can set whether they are an instructor or a 
 * student.
 */
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC3C5C7),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 250),
            Text("Student Names", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Color(0xFF249e7e))),
            SizedBox(height: 25),
            Container(
              color: Color(0xFF249e7e),
              width: 250,
              height: 1, 
            ),
            SizedBox(height: 25),
            RaisedButton(
              onPressed: () => _signOn(),
              padding: EdgeInsets.only(top: 7.5, bottom: 7.5, left: 5, right: 5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image(
                    image: AssetImage("assets/google_logo.png"),
                    height: 30,
                  ),
                  SizedBox(width: 10),
                  Text("Sign In With Google", style: TextStyle(fontSize: 30, color: Color(0xFF249e7e))),
                ],
              ),
              colorBrightness: Brightness.light,
              color: Colors.white,
              elevation: 20,
            )
          ]
        ),
      ),
    );
  }

  Future<void> _signOn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    if(user != null){
      String uid = user.uid;
      print("UID IS: $uid");
      DocumentSnapshot doc = await db.collection('/names').document(uid).get();
      if(doc.exists){
        print(doc.data['Type']);
        if(doc.data['Type'] == 'Instructor'){
          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new InstructorHome()));
        }
        else{
          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new StudentHome()));
        }
      }
      else{
        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new LoginHome()));
      }
    }
  }
}