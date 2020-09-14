import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:mime/mime.dart';
import 'package:pilgrimage/models/user.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
class EditProfilePage extends StatefulWidget {

  final String url;

  EditProfilePage({
    @required this.url,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  File pickedImage = null;

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

  bool loading = false;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    final uid = user.uid;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.amber , Colors.amberAccent])
        ),
        child: loading == false ? Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: GestureDetector(
                  onTap: (){
                    pickImage();
                  },
                  child: Stack(
                  children: [
                    Container(
                      height: 200,
                      child: CircleAvatar(
                        backgroundImage: pickedImage == null ? 
                        NetworkImage('${widget.url}'):
                        FileImage(pickedImage),
                        radius: 100,
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      radius: 100,
                    ),
                    Icon(Icons.edit, color: Colors.amber, size: 50.0,),
                  ],
                  alignment: Alignment.center,
                ),
              ),
            ),
            RaisedButton(
              shape: CircleBorder(),
              color: Colors.amber[800],
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                if(pickedImage == null){
                  setState(() {
                    loading = false;
                  });
                  Navigator.pop(context);
                }
                else{
                  try{
                    StorageReference storageReference = FirebaseStorage().ref();
                    var uploadTask = storageReference.child('profiles').child(uid).putFile(pickedImage);
                    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
                    var url = await snapshot.ref.getDownloadURL();

                    await Firestore.instance.collection('users').document(uid).updateData({
                      'profilePic': url,
                    });

                    setState(() {
                      loading = false;
                    });

                    Navigator.pop(context);

                  }
                  catch(e){
                    setState(() {
                      loading = false;
                    });
                    Toast.show('An error occured. Please try again', context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Icon(Icons.check, color: Colors.black,),
              ),
            ),
          ],
        ) : LoadingDoubleFlipping.circle(
          borderColor: Colors.amber[800],
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}