import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pilgrimage/models/user.dart';


class AuthService{
  FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user){
    //sleep(new Duration(seconds: 5));
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user{//Getter function to notify listeners of state change using Provider
    return _auth.onAuthStateChanged.map(_userFromFirebase);
  }

  Future<dynamic> signIn(String email, String password) async {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebase(user);
  }

  Future<dynamic> signUp(String email, String password, File image) async {
    AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      if(image == null){
        await Firestore.instance.collection('users').document(user.uid).setData({
        'email' : email,
        'password' : password,
        'uid' : user.uid,
        'saved' : [],
        'profilePic' : 'https://firebasestorage.googleapis.com/v0/b/pilgrimage-2b573.appspot.com/o/no_img.png?alt=media&token=da3252c8-3394-4b46-898b-b28c78a114f2'
      });
      }
      else{
        StorageReference storageReference = FirebaseStorage().ref();
        var uplpoadTask = storageReference.child('profiles').child('${user.uid}').putFile(image);
        StorageTaskSnapshot storageTaskSnapshot = await uplpoadTask.onComplete;

        var url = await  storageTaskSnapshot.ref.getDownloadURL();

        await Firestore.instance.collection('users').document(user.uid).setData({
        'email' : email,
        'password' : password,
        'uid' : user.uid,
        'saved' : [],
        'profilePic' : '$url'
      });

      }
      return _userFromFirebase(user);
  }

  Future<void> signOut(){
    return _auth.signOut();
  }

}