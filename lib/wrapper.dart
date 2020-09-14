import 'package:flutter/material.dart';
import 'package:pilgrimage/auth/authScreen.dart';
import 'package:pilgrimage/pages/home.dart';
import 'package:pilgrimage/pages/intro.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if(user == null){//Show Auth Screen if user is not logged in else show HomeScreen
      return AuthScreen();
    }
    else{
      return HomePage();
    }
  }
}