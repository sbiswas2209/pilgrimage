
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:pilgrimage/models/user.dart';
import 'package:pilgrimage/pages/home.dart';
import 'package:pilgrimage/services/authService.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
class SignUpWidget extends StatefulWidget {

  final VoidCallback flagFunc;

  SignUpWidget({@required this.flagFunc});

  bool loading = false;

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  String email;
  String password;

  bool obscure = true;

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

  @override
  Widget build(BuildContext context) {
    return widget.loading == true ? Center(child: CircularProgressIndicator()) :
    Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            onChanged: (value) {
              setState(() {
                email = value;
              });
              print('Email : $email');
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextFormField(
            obscureText: obscure,
            decoration: InputDecoration(
              suffixIcon: InkWell(
                child: Icon(!obscure ? Icons.visibility : Icons.visibility_off),
                onTap: () {
                  setState(() {
                    obscure = !obscure;
                  });
                },
              ),
              hintText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            onChanged: (value) {
              setState(() {
                password = value;
              });
              print('Password : $password');
            },
          ),
        ),
        pickedImage == null ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            onPressed: (){
              pickImage();
            },
            child: ListTile(
              title: Text('Choose Profile Picture'),
              trailing: CircleAvatar(
                backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/pilgrimage-2b573.appspot.com/o/no_img.png?alt=media&token=da3252c8-3394-4b46-898b-b28c78a114f2'),
              ),
            ),
          ),
        ) : 
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
              onPressed: (){
                pickImage();
              },
              child: ListTile(
                title: Text('Welcome Aboard!!'),
                trailing: CircleAvatar(
                  backgroundImage: FileImage(pickedImage),
                ),
              ), 
            ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(100.0 , 20.0 , 100.0 , 20.0),
          child: RaisedButton(
            onPressed: () async {
              setState(() {
                widget.loading = true;
              });
              try{
                await AuthService().signUp(email, password, pickedImage);
                //Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new HomePage()));
              }
              catch(e){
                Toast.show('An error occured', context, gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
                setState(() {
                  email = null;
                  password = null;
                });
                setState(() {
                widget.loading = false;
              });
              }
            },
            child: Text('Sign Up', style: Theme.of(context).textTheme.bodyText1,),
            color: Colors.amber,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
        FlatButton(
          onPressed: widget.flagFunc,
          child: Text('Log In', style: Theme.of(context).textTheme.bodyText1,),
        ),
      ],
    );
  }
}