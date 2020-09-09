import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilgrimage/auth/login.dart';
import 'package:pilgrimage/auth/signup.dart';
class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  flagFunc(){
    setState(() {
      loginState = !loginState;
    });
  }

  bool loginState = true;//If true login widget will be shown or sign up widget will be shown.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.amber, Colors.amberAccent])
        ),
        child: ListView(
            children: [
              SizedBox(height: 100.0),
              SvgPicture.asset(
                'assets/images/authPic.svg',
                height: 300.0,
              ),
              SizedBox(height: 100),
              loginState ? LoginWidget(flagFunc: flagFunc) : SignUpWidget(flagFunc: flagFunc),
            ],
          ),
      ),
    );
  }
}