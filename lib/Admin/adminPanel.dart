import 'package:flutter/material.dart';
import 'package:myapptest/Admin/Panel/addStudent.dart';
import 'package:myapptest/Admin/Panel/showStudent.dart';
import 'package:myapptest/Admin/Panel/updateStudent.dart';

import 'Panel/removeStudent.dart';
import 'Panel/uploadImage.dart';

class Panel extends StatefulWidget {

  final apiToken;
  Panel({this.apiToken});

  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel'),
      ),
      body: CustomScrollView(
        slivers:[
      SliverFillRemaining(
      hasScrollBody: false,
      child:Column(
          children: [
            Container(
                height: 100,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                child: ElevatedButton(
                  child: Text('Add Student'),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddStudent(apiToken: widget.apiToken,)) );
                  },
                )
            ),
            Container(
                height: 100,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                child: ElevatedButton(
                  child: Text('Update Student'),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Update(apiToken:widget.apiToken,)) );
                  },
                )
            ),
            Container(
                height: 100,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                child: ElevatedButton(
                  child: Text('Remove Student'),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Remove(widget.apiToken)) );
                  },
                )
            ),
            Container(
                height: 100,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                child: ElevatedButton(
                  child: Text('Upload Image'),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Upload(widget.apiToken)) );
                  },
                )
            ),
            Container(
                height: 100,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                child: ElevatedButton(
                  child: Text('Search Student'),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Show(widget.apiToken)) );

                  },
                )
            ),
          ],
        ),
      )],
    ));
  }
}
