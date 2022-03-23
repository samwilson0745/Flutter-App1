import 'package:flutter/material.dart';
import 'package:myapptest/Admin/adminLogin.dart';

class Main extends StatefulWidget {
  @override
  _mainState createState() => _mainState();
}

class _mainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Management System'),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: TextButton(
                  child: Text('Admin'),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AdminLogin()) );
                  },
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
