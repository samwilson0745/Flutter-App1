import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:myapptest/Admin/adminPanel.dart';

class AdminLogin extends StatefulWidget {

  @override
  _adminLoginState createState() => _adminLoginState();

}

class _adminLoginState extends State<AdminLogin> {

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final url = 'http://bs.koushikisoftware.com/reacttest/api/AdminUser/Login';

  final _formKey = GlobalKey<FormState>();

  var error="";
  var apitoken="";

  void fetchPosts(String LoginId,String password) async{

      var response = await post(Uri.parse(url),body:
        {
          "LoginId": LoginId,
          "Password": password
        }
      );
      var _postJson=(jsonDecode(response.body));

      if(_postJson['IsSucess']==false){
        setState(() {
          error=_postJson['Message'].toString();
        });
      }
      else{
        setState(() {
          error="";
          apitoken=_postJson['Data']['ApiToken'].toString();
        });
      }

      if(_formKey.currentState!.validate() && error==''){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Panel(apiToken: apitoken)), (route) => false);
      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child:Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child:Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Admin',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            ),
                              Container(
                                child: Text(error,style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold
                                ),),
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                        child:TextFormField(
                                          controller: nameController,
                                          validator: (value){
                                            if(value == null || value.isEmpty){
                                              setState(() {
                                                error="";
                                              });
                                              return "Please Enter Name";}
                                            else return null;
                                          },
                                        )
                                    ),
                                    Container(
                                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                        child:TextFormField(
                                          controller: passwordController,
                                          validator: (value){
                                            if((value == null || value.isEmpty)){
                                              setState(() {
                                                error="";
                                              });
                                              return "Please Enter Password";}
                                            else return null;
                                          },
                                        )
                                    ),
                                    Container(
                                        height: 120,
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(vertical: 30,horizontal: 20),
                                        child: ElevatedButton(
                                          child: Text('Login'),
                                          onPressed: (){
                                            fetchPosts(nameController.text, passwordController.text);
                                          },
                                        )
                                    ),
                                  ],
                                ),
                              )
                          ],
                  ))
              )
            ],
          )
      );
  }
}


