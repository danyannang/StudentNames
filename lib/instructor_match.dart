import 'package:flutter/material.dart';

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

  List<bool> picked = new List<bool>();

  @override
  void initState() {
    for(int i = 0; i < studentName.length; i++){
      picked.add(false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC3C5C7),
      appBar: AppBar(
        backgroundColor: Color(0xFF249e7e),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(), 
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

  _openChooser(int index){
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
                  studentPic[index],
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
                        picked[index] = !picked[index];
                      });
                    },
                    child: Text(studentName[index], style: TextStyle(color: !picked[index] ? Colors.black : Color(0xFF249e7e))),
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