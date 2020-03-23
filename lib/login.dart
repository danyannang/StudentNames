import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student_names/instructor_home.dart';
import 'package:student_names/student_home.dart';
import 'package:student_names/login_home.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
GoogleSignIn _googleSignIn;

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
      print("Printing error below:");
      print('$e');
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new LoginPage()));
    }).then((val){
      print("Printing val below:");
      print(val);
      if(val == null){
        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new LoginPage()));
      }
      else{
        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new LoginHome()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
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
            FlatButton(
              onPressed: () => _signOn(), 
              child: Text("Google Sign In", style: TextStyle(fontSize: 40, color: Colors.white70)),
              color: Colors.transparent.withAlpha(50),
              colorBrightness: Brightness.dark,
            )
          ],
        ),
      )
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
    print(user);
    if(user != null){
      // If user is an instructor pushReplacement InstructorHome()
      // Else pushReplacement StudentHome()
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new LoginHome()));
    }
    print("signed in " + user.displayName);
  }
}