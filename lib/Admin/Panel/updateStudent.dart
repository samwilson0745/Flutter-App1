import 'dart:convert';

import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:myapptest/Admin/Panel/updateDetails.dart';

class Update extends StatefulWidget {

  final apiToken;
  Update({this.apiToken});

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {

  List _allStudent=[];
  var i,classId,classID;
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

  bool _displayStudent(String Name,String classId){
    for(i=0;i!=_allStudent.length;i++){
      if(Name==_allStudent[i]['Name'] && classId==_allStudent[i]['ClassId']){
        Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePanel(_allStudent[i],widget.apiToken)) );
        return true;
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Student does not exist'));
    return false;
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
         title: Text('Update Student'),
      ),
      body:Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25,vertical: 20),
          child: Column(
            children: [
              Form(
                key: _formKey,
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
                      _displayStudent(_nameController.text,classId);
                      }
                    },
                  child: Text('Search')
              )
            ],
          ),
        ),
      ),
    );
  }
}
