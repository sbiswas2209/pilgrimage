import 'package:curved_drawer/curved_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pilgrimage/constants/logoAppBar.dart';
import 'package:pilgrimage/pages/newPost.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
          child: Scaffold(
        //backgroundColor: Colors.black,
          body: CustomScrollView(
      physics: ScrollPhysics(
        parent: BouncingScrollPhysics()
      ),
      slivers: [
        logoAppBar(title: 'Home'),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context , index){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.amber,
                  height: 100.0,
                  width: 100.0,
                ),
              );
            },
            childCount: 20
          ),
        ),
      ],
          ),
          floatingActionButton: FloatingActionButton.extended(
      onPressed: (){
        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new NewPost()));
      },
      icon: Icon(Icons.add, color: Colors.white,),
      backgroundColor: Colors.amber[800],
      label: Text('Post')
          ),
          drawer: Drawer()
        ),
    );
  }
}