import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  final student;
  String apiToken;
  UploadImage(this.student,this.apiToken);

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {

  File? image;

  SnackBar _showSnackBar(String text){
    return SnackBar(
      content: Text(text),
    );
  }

  final _picker = ImagePicker();

  Future getImage()async{
    final pickedFile=await _picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
    if(pickedFile!=null){
      setState(() {
        image=File(pickedFile.path);
      });
    }
    print(image);
  }

  asyncFileUpload() async{

    var request = MultipartRequest("POST", Uri.parse("http://bs.koushikisoftware.com/reacttest/api/Student/UploadStudentImages"));

    request.fields["StudentId"] = widget.student['StudentId'];
    request.fields["ApiToken"] = widget.apiToken;

    var pic = await MultipartFile.fromPath("File", image!.path);

    request.files.add(pic);
    var response = await request.send();

    if(response.statusCode==200){
      ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Image Uploaded'));
      Navigator.pop(context);
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(_showSnackBar('Something went wrong!'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
      ),
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.camera_alt_outlined),
        onPressed: () async {
           getImage();
            }
    ),
      body: image!=null?Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child:Image.file(File(image!.path).absolute,width: 200,height: 200,fit: BoxFit.cover,)),
          ElevatedButton(onPressed: (){
            asyncFileUpload();
          }, child: Text('Upload'),)
        ],
      ):Center(child: Text('No File'),),
    );
  }
}
