import 'package:flutter/material.dart';

Map<String, Map<String, bool>> picked = new Map<String, Map<String, bool>>();
Map<String, bool> namePicked = new Map<String, bool>();

class InstructorMatch extends StatefulWidget {
  List<String> studentName = new List<String>();
  List<String> studentPic = new List<String>();
  InstructorMatch(this.studentName, this.studentPic);

  @override
  _InstructorMatchState createState() => _InstructorMatchState(studentName, studentPic);
}

class _InstructorMatchState extends State<InstructorMatch> {
  List<String> studentName = new List<String>();
  List<String> studentPic = new List<String>();
  _InstructorMatchState(this.studentName, this.studentPic);


  final GlobalKey<ScaffoldState> matchScaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  void initState() {
    for(int i = 0; i < studentName.length; i++){
      picked[studentName[i]] = {"": false};
      namePicked[studentName[i]] = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: matchScaffoldKey,
      backgroundColor: Color(0xFFC3C5C7),
      appBar: AppBar(
        backgroundColor: Color(0xFF249e7e),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new FinishScreen(studentName, studentPic))),
            child: Text("Done", style: TextStyle(color: Colors.white, fontSize: 20)),
          )
        ],
      ),
      body: SafeArea(
        child: GridView.count(
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          crossAxisCount: 3,
          children: List.generate(
            studentName.length,
            (index) {
              return GestureDetector(
                onTap: () => _openChooser(index),
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      studentPic[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }
          ),
        ),
      ),
    );
  }

  _openChooser(int student){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return StatefulBuilder(
          builder: (BuildContext context, setState){
            return AlertDialog(
            title: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  studentPic[student],
                  fit: BoxFit.cover,
                  height: 150,
                ),
              ),
            ),
            content: GridView.count(
              crossAxisCount: 3,
              children: List.generate(
                studentName.length,
                (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if(namePicked[studentName[index]] == true && studentName[index] != picked[studentName[student]].keys.first){
                          print("Already picked");
                          matchScaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Student Already Picked"), duration: Duration(seconds: 1)));
                        }
                        else{
                          if(picked[studentName[student]].keys.first == ""){
                            picked[studentName[student]] = {studentName[index] : true};
                            namePicked[studentName[index]] = true;
                          }
                          else if(studentName[index] == picked[studentName[student]].keys.first){
                            picked[studentName[student]] = {"" : false};
                            namePicked[studentName[index]] = false;
                          }
                          else{
                            namePicked[picked[studentName[student]].keys.first] = false;
                            picked[studentName[student]] = {studentName[index] : true};
                            namePicked[studentName[index]] = true;
                          }
                        }
                        print(picked);
                      });
                    },
                    child: Text(studentName[index], style: TextStyle(color: !namePicked[studentName[index]] ? Colors.black : Color(0xFF249e7e))),
                  );
                }
              )
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Done"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
          }
        );
      }
    );
  }
}

class FinishScreen extends StatelessWidget {
  List<String> studentName = new List<String>();
  List<String> studentPic = new List<String>();
  FinishScreen(this.studentName, this.studentPic);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC3C5C7),
      appBar: AppBar(
        backgroundColor: Color(0xFF249e7e),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            ListView.builder(
              itemBuilder: null
            )
          ],
        ),
      ),
    );
  }
}