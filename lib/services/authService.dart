import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pilgrimage/models/user.dart';


class AuthService{
  FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user{
    return _auth.onAuthStateChanged.map(_userFromFirebase);
  }

  Future<dynamic> signIn(String email, String password) async {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebase(user);
  }

  Future<dynamic> signUp(String email, String password) async {
    AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      await Firestore.instance.collection('users').document(user.uid).setData({
        'email' : email,
        'password' : password,
        'uid' : user.uid,
        'saved' : [],
      });
      return _userFromFirebase(user);
  }

  Future<void> signOut(){
    return _auth.signOut();
  }

}