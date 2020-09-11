import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:pilgrimage/models/user.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {

  String title = null;
  String content = null;

  File pickedImage = null;

  String dropDownValue = null;

  bool loading = false;

  Future<void> pickImage(){
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          title: Text('Pick an Image',
            style: Theme.of(context).textTheme.headline1,
          ),
          content: Text('Select an image to be uploaded.\n Only png, jpg, jpeg and gif supported.',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          actions: [
            FlatButton(
              onPressed: (){
                openCamera();
                Navigator.pop(context);
              },
              child: Text('From Camera'),
            ),
            FlatButton(
              onPressed: (){
                openGallery();
                Navigator.pop(context);
              }, 
              child: Text('From Gallery')
            ),
          ],
        );
      },
    );
  }

  void openCamera() async {
    PickedFile image = await ImagePicker().getImage(source: ImageSource.camera);

    if(image != null){
      String mimeStr = lookupMimeType(image.path);
      var fileType = mimeStr.split('/');
      print('$fileType');
      if(fileType[fileType.length-1] == 'png' || fileType[fileType.length-1] == 'jpg' || fileType[fileType.length - 1] == 'jpeg'){
        setState(() {
          pickedImage = File(image.path);
        });
      }
      else{
        Toast.show('Wrong file format.', context, duration: Toast.LENGTH_LONG, gravity: Toast.LENGTH_LONG);
      }
    }

  }

  void openGallery() async {
    PickedFile image = await ImagePicker().getImage(source: ImageSource.gallery);

    if(image != null){
      String mimeStr = lookupMimeType(image.path);
      var fileType = mimeStr.split('/');
      print('Gallery File Type : $fileType');
      if(fileType[fileType.length-1] == 'png' || fileType[fileType.length-1] == 'jpg' || fileType[fileType.length-1] == 'jpeg'){
        setState(() {
          pickedImage = File(image.path);
        });
        
      }
      else{
        Toast.show('Wrong file format.', context, duration: Toast.LENGTH_LONG, gravity: Toast.LENGTH_LONG);
      }
    }

  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    final uid = user.uid;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.amber, Colors.amberAccent]),
          ),
        ),
        leading: FlatButton(
          child: Icon(Icons.cancel_outlined),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        elevation: 0.0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.amber, Colors.amberAccent]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: loading == true ? Center(child: CircularProgressIndicator()) : ListView(
            physics: ScrollPhysics(
              parent: BouncingScrollPhysics()
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: () async {
                    if(pickedImage == null){
                      await pickImage();
                    }
                  },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                                          child: Container(
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.amber, Colors.amberAccent]),
                        border: Border.all(color: Colors.grey, width: 2.0),
                        borderRadius: BorderRadius.circular(50.0)
                      ),
                      child: pickedImage == null ? Center(
                        child: Icon(Icons.add_photo_alternate_outlined, size: 100.0, color: Colors.grey,),
                      ) : 
                      Stack(
                        children: [
                          Image.file(
                            pickedImage,
                            height: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              shape: CircleBorder(),
                              color: Theme.of(context).primaryColor.withOpacity(0.5),
                              child: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  pickedImage = null;
                                });
                              },
                            ),
                          ),
                        ],
                        alignment: Alignment.bottomCenter,
                      ),
                  ),
                    ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.amber[100],
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Title',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      )
                    ),
                    onChanged: (value) {
                      setState(() {
                        title = value;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.amber[100],
                  ),
                  child: TextFormField(
                    minLines: 5,
                    maxLines: 7,
                    maxLength: 200,
                    decoration: InputDecoration(
                      labelText: 'Content',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      )
                    ),
                    onChanged: (value) {
                      setState(() {
                        content = value;
                      });
                    },
                  ),
                ),
              ),
              Text('Category'),
              Padding(
                padding: const EdgeInsets.fromLTRB(100.0 , 10.0 , 100.0 , 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Center(
                    child: DropdownButton<String>(
                      hint: Text('Category'),
      value: dropDownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black),
      onChanged: (String newValue) {
        setState(() {
          dropDownValue = newValue;
        });
      },
      
      items: <String>['Travel', 'Technology', 'Entertainment', 'Other']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ),
                  ),
                ),
              ),
              SizedBox(height: 40.0,),
            ],
          ),
        ),
      ),
      floatingActionButton: !loading ? FloatingActionButton.extended(
        onPressed: () async {
          if(title == null || content == null || pickedImage == null || dropDownValue == null){
            Toast.show('Please fill all fields', context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
          }
          else{
            Toast.show('Starting Upload', context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
            setState(() {
              loading = true;
            });
            try{
              var dbRef = Firestore.instance.collection('posts').document();
              
              var documentId = dbRef.documentID;//Getting Document ID for each post.

              StorageReference storageReference = FirebaseStorage().ref();

              var uploadTask = storageReference.child('images').child('$uid:$documentId').putFile(pickedImage);//Using document id to ensure uniqe name of all media files

              StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;

              var url = await storageTaskSnapshot.ref.getDownloadURL();

              dbRef.setData({
                'title' : title,
                'content' : content,
                'uid' : uid,
                'url' : url,
                'category' : dropDownValue,
                'likes' : [],
                'docId' : documentId,
              });

              Toast.show('Upload Complete', context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP);

              Navigator.pop(context);
            }
            catch(e){
              Toast.show('An error occured. Plase check connectivity and try again.', context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
            }
            setState(() {
              loading = false;
            });
          }
          //Navigator.pop(context);
        },
        backgroundColor: Colors.amber[800],
        label: Text('Confirm'),
        icon: Icon(Icons.check),
      ) : SizedBox(height: 1),
    );
  }
}