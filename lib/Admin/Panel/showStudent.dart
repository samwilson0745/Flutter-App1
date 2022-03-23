import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Show extends StatefulWidget {
  String apiToken;
  Show(this.apiToken);
  @override
  _ShowState createState() => _ShowState();
}

class _ShowState extends State<Show> with TickerProviderStateMixin{

  List _allStudent=[];
  bool state=false;
  var length=0;
  var classID;

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

  void _getAllStudent()async{

    final response = await post(Uri.parse("http://bs.koushikisoftware.com/reacttest/api/Student/GetAll"),
        body:{

          "ApiToken": widget.apiToken

        }
    );

    var _data=jsonDecode(response.body);
    _allStudent=_data["Data"];
    setState(() {
      length=_allStudent.length!=0?_allStudent.length:0;
      state=true;
    });

  }


  @override
  void initState() {
    super.initState();
    _getAllStudent();
    getClass();
  }
  _checkClass(var id){
    for(var i=0;i<classID.length;i++){
      if(id==classID[i]['ClassId']){
        return classID[i]['Name'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Students'),
      ),
      body: state==true?Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child:length!=0?ListView.builder(
            itemCount: length,
            itemBuilder: (context,index){
              return ListTile(
                leading: _allStudent[index]["Documents"].length!=0?Container(
                  height: 50,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage("${_allStudent[index]["Documents"][0]["DocumentUrl"]}"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ):Container(
                  height: 50,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue
                  ),),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_allStudent[index]['Name']),
                    Text("StudentID: ${_allStudent[index]['StudentId']}",style: TextStyle(
                      fontSize: 10
                    ),)
                  ],
                ),
                subtitle: Text("Class:${_checkClass(_allStudent[index]['ClassId'])}"),
                onTap: (){},
              );
            }):Center(
          child: Text('No students added'),
        ),
      ):Center(
        child: Container(
          child:CircularProgressIndicator()
        ),
      ),
    );
  }
}
