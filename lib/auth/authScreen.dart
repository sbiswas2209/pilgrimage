import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilgrimage/auth/login.dart';
import 'package:pilgrimage/auth/signup.dart';
import 'package:pilgrimage/constants/controls.dart';
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

  FlareControls flare = FlareControls();

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
              // SvgPicture.asset(
              //   'assets/images/authPic.svg',
              //   height: 300.0,
              // ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                height: 400,
                width: 400,
                child: SizedBox(
                  height: 80,
                  width: 80,
                    child: FlareActor(
                      'assets/images/auth.flr',
                      controller: flare,
                      animation: 'idle',
                      fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              SizedBox(height: 100),
              loginState ? LoginWidget(flagFunc: flagFunc, flare: flareControls,) : SignUpWidget(flagFunc: flagFunc),
            ],
          ),
      ),
    );
  }
}