import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PhotoUpload extends StatefulWidget {
  PhotoUpload({Key key}) : super(key: key);

  @override
  _PhotoUploadState createState() => _PhotoUploadState();
}

class _PhotoUploadState extends State<PhotoUpload> {
  File sampleImage;
  final formkey = GlobalKey<FormState>();
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
                  onPressed: validateAndSave,
                )
              ],
            ),
          ),
        ),
      ),
    );
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
