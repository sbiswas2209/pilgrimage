



import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilgrimage/pages/intro.dart';
import 'package:pilgrimage/services/authService.dart';
SliverAppBar logoAppBar(
  context,
  {
  @required String title,
  final List<Widget> actions,
  final VoidCallback onLogoTap,
}){
  return SliverAppBar(
    title: Text('Home'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(50.0),
              )
            ),
            floating: true,
            pinned: false,
            onStretchTrigger: () async {
              return await true;
            },
            stretch: true,
            toolbarHeight: 80.0,
            collapsedHeight: 90.0,
            expandedHeight: 200.0,
            actions: [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0 , 0.0 , 10.0 , 0.0),
                  child: Container(
                    height: 70.0,
                    width: 70.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: SvgPicture.asset('assets/images/logo.svg',
                        fit: BoxFit.fill,                    
                    ),
                  ),
                ),
                onTap: () async {
                  await helpDialog(context);
                },
              ),
            ],
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.amber, Colors.amberAccent]),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(50.0),
                ),
              ),
            ),
  );
}

Future<void> helpDialog(context){
  return showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title: Text('Get Help here'),
        titleTextStyle: Theme.of(context).textTheme.headline1,
        actions: [
          FlatButton(
            onPressed: (){
              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new IntroPage()));
            },
            child: Text('About'),
          ),
        ],
      );
    }
  );
}