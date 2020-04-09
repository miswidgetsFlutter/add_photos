import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:intl/intl.dart';

class PhotoUpload extends StatefulWidget {
  PhotoUpload({Key key}) : super(key: key);

  @override
  _PhotoUploadState createState() => _PhotoUploadState();
}

class _PhotoUploadState extends State<PhotoUpload> {
  File sampleImage;
  final formkey = GlobalKey<FormState>();
  String url;
  String _myvalue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("upload Image"),
        centerTitle: true,
      ),
      body: Center(
        child: sampleImage == null ? Text("select and Image") : enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: "add Image",
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }

  Widget enableUpload() {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formkey,
            child: Column(
              children: <Widget>[
                Image.file(
                  sampleImage,
                  height: 300.0,
                  width: 600.0,
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Descripcion"),
                  validator: (value) {
                    return value.isEmpty ? "Description is requiered" : null;
                  },
                  onSaved: (value) {
                    return _myvalue = value;
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                RaisedButton(
                  elevation: 10.0,
                  child: Text("Add a new post"),
                  textColor: Colors.white,
                  color: Colors.pink,
                  onPressed: uploadStatusImage,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void uploadStatusImage() async {
    if (validateAndSave()) {
      final StorageReference postImageRef = FirebaseStorage.instance.ref().child("post images");
      var timeKey = DateTime.now();
      final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString()+".jpg").putFile(sampleImage);
      var imageUrl = await(await uploadTask.onComplete).ref.getDownloadURL();
      url = imageUrl.toString();
      print("Image Url: "+ url);
      //guardar imagen es realtime database
      saveToDatabase(url);
      //regresar a home
      Navigator.pop(context);
    }
  }

  void saveToDatabase(String url){
    //guarda el post
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d, YYYY');
    var formatTime = DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var data = {
      "image": url,
      "descripcion": _myvalue,
      "date": date,
      "time": time
    };
    ref.child("Posts").push().set(data);
  }

  bool validateAndSave(){
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }else{
      return false;
    }
  }
}
