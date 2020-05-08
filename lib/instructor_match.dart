import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';


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
  List<String> randomNames;



  @override
  void initState() {
    for(int i = 0; i < studentName.length; i++){
      picked[studentName[i]] = {"": false};
      namePicked[studentName[i]] = false;
    }
    // randomNames = studentName;
    randomNames = new List<String>.from(studentName);
    for (int i = 0; i < randomNames.length-1; ++i){
      int j = Random().nextInt(randomNames.length);
      var tempName = randomNames[i];
      randomNames[i] = randomNames[j];
      randomNames[j] = tempName;
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
            child: Text("Finish", style: TextStyle(color: Colors.white, fontSize: 20)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: GridView.count(
          shrinkWrap: true,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          crossAxisCount: 3,
          children: List.generate(
            studentName.length,
            (index) {
              return Container(
                child: GestureDetector(
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
                  content: Container(
                height: MediaQuery.of(context).size.height/2,
                width: MediaQuery.of(context).size.width/2,
                child: GridView.count(
                      crossAxisCount: 3,
                      children: List.generate(
                          randomNames.length,
                              (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if(namePicked[randomNames[index]] == true && randomNames[index] != picked[studentName[student]].keys.first){
                                    HapticFeedback.selectionClick();
                                  }
                                  else{
                                    if(picked[studentName[student]].keys.first == ""){
                                      picked[studentName[student]] = {randomNames[index] : true};
                                      namePicked[randomNames[index]] = true;
                                    }
                                    else if(randomNames[index] == picked[studentName[student]].keys.first){
                                      picked[studentName[student]] = {"" : false};
                                      namePicked[randomNames[index]] = false;
                                    }
                                    else{
                                      namePicked[picked[studentName[student]].keys.first] = false;
                                      picked[studentName[student]] = {randomNames[index] : true};
                                      namePicked[randomNames[index]] = true;
                                    }
                                  }
                                });
                              },
                              child: Text(randomNames[index], style: TextStyle(color: !namePicked[randomNames[index]] ? Colors.black : Color(0xFF249e7e))),
                            );
                          }
                      )
                  ),
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
        automaticallyImplyLeading: false,
        actions: <Widget>[
          FlatButton(
            child: Text("Done", style: TextStyle(color: Colors.white, fontSize: 20)),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height-81,
            child: ListView.builder(
              itemCount: studentName.length,
              itemBuilder: (BuildContext context, int index){
                return Column(
                  children: <Widget>[
                    Container(
                      height: 175,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(studentPic[index], height: 170, width: 175, fit: BoxFit.cover)
                              )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 20),
                            child: Column(
                              children: <Widget>[
                                Text("Correct Answer:", style: TextStyle(fontSize: 20),),
                                Text(studentName[index], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                Text("Your Answer:", style: TextStyle(fontSize: 20),),
                                Text(picked[studentName[index]].keys.first, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                studentName[index].toLowerCase() == picked[studentName[index]].keys.first.toLowerCase()  ? Icon(Icons.check, color: Color(0xFF249e7e), size: 45,) : 
                                  Icon(Icons.close, color: Colors.red, size: 45),
                              ],
                            ),
                          )
                        ],
                      )
                    ),
                  ],
                );
              }
            )
          )
        ],
      ),
    );
  }
}