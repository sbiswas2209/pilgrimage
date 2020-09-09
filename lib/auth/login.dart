import 'package:flutter/material.dart';
import 'package:pilgrimage/services/authService.dart';
import 'package:toast/toast.dart';
class LoginWidget extends StatefulWidget {

  final VoidCallback flagFunc;

  LoginWidget({@required this.flagFunc});

  bool loading = false;

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {

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
              print(widget.loading);
              try{
                await AuthService().signIn(email, password);
              }
              catch(e){
                //await showAlert();
                print('Login Exception');
                print(e);
                Toast.show('An error occured', context, gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
                setState(() {
                  widget.loading = false;
                  email = null;
                  password = null; 
                });
              }
              setState(() {
                  widget.loading = false;
                });
              print(widget.loading);
            },
            child: Text('Log In', style: Theme.of(context).textTheme.bodyText1,),
            color: Colors.amber,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
        FlatButton(
          onPressed: widget.flagFunc,
          child: Text('Sign Up', style: Theme.of(context).textTheme.bodyText1,),
        ),
      ],
    );
  }

  Future<void> showAlert(){
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Authentication Failed'),
          content: Text('Your credentials might have been wrong. Please retry.'),
          actions: [
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

}