import 'dart:convert';

import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class UpdatePanel extends StatefulWidget {
  final student;
  String apiToken;
  UpdatePanel(this.student,this.apiToken);

  @override
  _UpdatePanelState createState() => _UpdatePanelState();
}
class Student {
  Student(
      this.StudentID,
      this.name,
      this.gender,
      this.classId,
      this.dob,
      this.isSpeciallyEligible,
      this.subjects,
      this.apiToken,
      );
  String StudentID;
  String name;
  String gender;
  String classId;
  DateTime dob;
  bool isSpeciallyEligible;
  List subjects;
  String apiToken;

  Map<String, dynamic> toJson() => {
    "StudentId":StudentID,
    "Name": name,
    "Gender": gender,
    "ClassId": classId,
    "DOB": dob.toString(),
    "IsSpeciallyEligible": isSpeciallyEligible.toString(),
    "Subjects": List<dynamic>.from(subjects.map((x) => x)),
    "ApiToken": apiToken,
  };
  String convertToJson(){
    return jsonEncode(this.toJson());
  }
}
class _UpdatePanelState extends State<UpdatePanel> {

  var name,gender,classId,dob,error="";
  
  DateTime selectedDate = DateTime.now();
  var genders,classID;
  List subjectData=[];
  List  subjects=[];
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController DOBcontroller = TextEditingController();

  void _updateStudent()async{
    Student results=Student(widget.student['StudentId'],name, gender, classId, selectedDate,true, subjects, widget.apiToken);
    final response = await post(Uri.parse('http://bs.koushikisoftware.com/reacttest/api/Student/Update'),
      body: results.convertToJson(),
      headers: {
        "access-control-allow-origin": "*",
        "cache-control": "no-cache",
        "content-type": "application/json; charset=utf-8",
        "pragma": "no-cache",

      }
    );
    print(response.body);
    var _updateData=jsonDecode(response.body);
    if(_updateData["IsSucess"]==true){
      ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Student Update'));
      await Future.delayed(const Duration(seconds: 2), (){
        Navigator.pop(context);
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Server Error PLease try again'));
    }
  }
  void getGenders() async{
    final response = await post(Uri.parse('http://bs.koushikisoftware.com/reacttest/api/Student/GetGenders'));
    var _postJson=(jsonDecode(response.body));
    if(_postJson['IsSucess']==true){
      setState(() {
        genders=_postJson['Data'];
      });}
    else{
      setState(() {
        genders='';
      });
    }
  }

  //to show the snackbar
  SnackBar _showSnackBar(String text){
    return SnackBar(
      content: Text(text),
    );
  }

  //to get the subjectID from the api
  void getSubject() async{
    final response = await post(Uri.parse('http://bs.koushikisoftware.com/reacttest/api/Student/GetSubjects'),body:{
      "ApiToken": widget.apiToken
    });
    var _postJson=(jsonDecode(response.body));
    if(_postJson['IsSucess']==true){
      setState(() {
        subjectData=_postJson['Data'];
      });
    }
    else{
      setState(() {
        subjectData=[];
      });

    }
  }
  //to get all student


  //to get the classID from the api
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
  void initState(){
    super.initState();
    nameController.text=widget.student['Name'];
    gender=widget.student['Gender'];
    classId=widget.student['ClassId'];
    DOBcontroller.text=widget.student['DOB'];
    subjects=widget.student['Subjects'];
    getSubject();
    getGenders();
    getClass();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UpdatePanel'),
      ),
      body: CustomScrollView(
          slivers:[
            SliverFillRemaining(
                hasScrollBody: false,
                child:Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Column(
                          children:[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                              child: Text(error,style:TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              )),
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child:TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: nameController,
                                  decoration: InputDecoration(
                                      labelText: "Enter Students Full Name"
                                  ),
                                  validator: (value){
                                    if((value == null || value.isEmpty)){
                                      return "Please Enter Name";
                                    }
                                    else{
                                      return null;
                                    }
                                  },
                                  onChanged: (value){
                                    setState(() {
                                      name=value;
                                    });
                                  },
                                )
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              child: DropDownFormField(
                                validator: (value){
                                  if((value == null || value.isEmpty)){
                                    return "PLease Select Gender";
                                  }
                                  else return null;
                                },
                                titleText: 'Gender',
                                hintText: 'None',
                                required: true,
                                value: gender,
                                onSaved: (value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                                onChanged: (value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                                dataSource: (genders==null)?[]:genders,
                                textField: (genders==null)?'':'Name',
                                valueField: (genders==null)?'':'Value',
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
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              child:MultiSelectDialogField(
                                validator:(value){
                                  if((value == null || value.isEmpty)){
                                    return "Please Select Subjects";
                                  }
                                  else return null;
                                },
                                items: subjectData.map((e) => MultiSelectItem(e['SubjectId'], e['Name'])).toList(),
                                listType: MultiSelectListType.CHIP,
                                buttonText: Text('Subjects'),
                                onConfirm: (values) {
                                  subjects= List<String>.from(values);
                                },
                              ),
                            ),
                            Container(
                                padding:EdgeInsets.symmetric(horizontal: 20,vertical: 10) ,
                                child: TextFormField(
                                  validator: (value){
                                    if((value == null || value.isEmpty)){
                                      return "PLease Enter Date of Birth";
                                    }
                                    else return null;
                                  },
                                  controller: DOBcontroller,
                                  decoration: InputDecoration(
                                    labelText: "Date of birth",
                                    hintText: "Ex. Insert your dob",),
                                  onTap: () async{
                                    FocusScope.of(context).requestFocus(new FocusNode());
                                    final DateTime? date = await showDatePicker(
                                        context: context,
                                        initialDate:selectedDate,
                                        firstDate:DateTime(1900),
                                        lastDate: DateTime(2100));
                                    if (date != null && date != selectedDate)
                                      setState(() {
                                        selectedDate = date;
                                        DOBcontroller.text="${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
                                      });
                                  },
                                )
                            ),
                          ]
                      ),
                      Container(
                        height: 90,
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (){
                            if(_formKey.currentState!.validate()){
                              _updateStudent();
                            }
                          },
                          child: Text('Update'),
                        ),)
                    ],
                  ),
                ))]),
    );
  }
}
