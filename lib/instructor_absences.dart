import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class InstructorAbsences extends StatefulWidget {
  List<String> studentName = new List<String>();
  List<String> studentPic = new List<String>();
  var documentid;
  InstructorAbsences(this.documentid);
  @override
  _InstructorAbsencesState createState() =>
      _InstructorAbsencesState(documentid);
}

class _InstructorAbsencesState extends State<InstructorAbsences> {
  var documentid;
  _InstructorAbsencesState(this.documentid);
  final GlobalKey<ScaffoldState> scaffoldRevKey =
  new GlobalKey<ScaffoldState>();
  QuerySnapshot result;
  List<DocumentSnapshot> documents;
  List _elements = [];
  Map<String,dynamic> ablists = new Map<String,dynamic>();

  void _getAbsences() async {
    await Firestore.instance.collection('Classes').document(documentid).collection('Roll').getDocuments()
    .then((result){
      setState(() {
        documents = result.documents;
        documents.forEach((data) {
          if (data.documentID != 'GridPics') {
            ablists.addAll(data.data);
          }
          if (data.documentID != 'GridPics') {
            data.data.values.forEach((name){
              for (int i = 0; i < name.length; i++) {
                _elements.add({'date':data.documentID, 'name':name[i]});
              }
            });
          }
        });
      });
    });


    print(ablists);
    print(_elements);
  }

  Widget _buildGroupSeparator(dynamic groupByValue) {
    return Text('$groupByValue');
  }

  @override
  void initState() {
    super.initState();
    _getAbsences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3E5E7),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Center(child: Text('Absences')),
          backgroundColor: Color(0xFF249e7e),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Color(0xFF249e7e),
              ),
              onPressed: () {
              },
            )
          ]),
      body:
      GroupedListView(
        elements: _elements,
        groupBy: (element) => element['date'],
        groupSeparatorBuilder: _buildGroupSeparator,
        itemBuilder: (context, element) => Text(element['name']),
        order: GroupedListOrder.DESC,
      ),
    );
  }
}