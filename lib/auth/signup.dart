import 'package:flutter/material.dart';
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
        Padding(
          padding: const EdgeInsets.fromLTRB(100.0 , 20.0 , 100.0 , 20.0),
          child: RaisedButton(
            onPressed: () async {
              setState(() {
                widget.loading = true;
              });
              try{
                await AuthService().signUp(email, password);
                //Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new HomePage()));
              }
              catch(e){
                Toast.show('An error occured', context, gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
                setState(() {
                  email = null;
                  password = null;
                });
              }
              setState(() {
                widget.loading = false;
              });
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