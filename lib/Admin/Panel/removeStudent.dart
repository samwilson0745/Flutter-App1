import 'dart:convert';

import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Remove extends StatefulWidget {
  String apiToken;
  Remove(this.apiToken);
  @override
  _RemoveState createState() => _RemoveState();
}

class _RemoveState extends State<Remove> {
  List _allStudent=[];
  var i,classId,classID,studentID;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController=new TextEditingController();

  SnackBar _showSnackBar(String text){
    return SnackBar(
      content: Text(text),
    );
  }

  void _getAllStudent()async{
    final response = await post(Uri.parse("http://bs.koushikisoftware.com/reacttest/api/Student/GetAll"),
        body:{

          "ApiToken": widget.apiToken

        }
    );
    var _data=jsonDecode(response.body);
    _allStudent=_data["Data"];
  }
  void _removeStudent()async{
    final response = await post(Uri.parse("http://bs.koushikisoftware.com/reacttest/api/Student/Remove"),
      body: {
        "StudentId":studentID,
        "ApiToken":widget.apiToken,
      }
    );
    var _data=jsonDecode(response.body);
    if(_data["IsSucess"]==true){
      ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Student Removed'));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Student not removed.Try Again!'));
    }
  }
  void _checkStudent()async{
    for(i=0;i!=_allStudent.length;i++){
      if(_nameController.text==_allStudent[i]['Name'] && classId==_allStudent[i]['ClassId']){
          setState(() {
            studentID=_allStudent[i]['StudentId'];
          });
          _removeStudent();
          return;
      }
  }
    ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Student does not exist'));
  }
  void getClass() async{
    final response = await post(Uri.parse('http://bs.koushikisoftware.com/reacttest/api/Student/GetClasses'),body: {
      "ApiToken": widget.apiToken
    });
    var _postJson = (jsonDecode(response.body));
    if(_postJson['IsSucess']==true){
      setState(() {
        classID=_postJson['Data'];
      });
    }
    else{
      setState(() {
        classID="";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getAllStudent();
    getClass();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remove Student'),
      ),
      body: Column(
          children:[
        Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
                labelText: "Enter Students Name"
            ),
            validator: (value){
              if((value == null || value.isEmpty)){
                return "Please Enter Name";
              }
              else{
                return null;
              }
            },
          ),
        ),
      ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: DropDownFormField(
            validator: (value){
              if((value == null || value.isEmpty)){
                return "Please Select a class";
              }
              else return null;
            },
            titleText: 'Class',
            hintText: 'None',
            value: classId,
            onSaved: (value) {
              setState(() {
                classId = value;
              });
            },
            onChanged: (value) {
              setState(() {
                classId = value;
              });
            },
            dataSource: (classID==null)?[]:classID,
            textField: (classID==null)?'':'Name',
            valueField: (classID==null)?'':'ClassId',
            required: true,
          ),
        ),
        ElevatedButton(
            onPressed: (){
              if(_formKey.currentState!.validate()) {
                _checkStudent();
              }
            },
            child: Text('Remove')
        ),
        ]
    ));
  }
}

