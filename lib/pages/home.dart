



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_drawer/curved_drawer.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:pilgrimage/constants/logoAppBar.dart';
import 'package:pilgrimage/constants/postCard.dart';
import 'package:pilgrimage/models/post.dart';
import 'package:pilgrimage/pages/intro.dart';
import 'package:pilgrimage/pages/newPost.dart';
import 'package:pilgrimage/pages/savedPostsPage.dart';
import 'package:pilgrimage/pages/settings.dart';
import 'package:pilgrimage/services/authService.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  

  

  @override
  Widget build(BuildContext context) {

   
    int i = 0;
    List<FlareControls> controls = new List();
   
    return WillPopScope(
      onWillPop: () async => true,
          child: Scaffold(
        //backgroundColor: Colors.black,
          body: StreamBuilder(
            stream: Firestore.instance.collection('posts').snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasData == true){
                print(snapshot.data);
                
                
                for(i=0 ; i<snapshot.data.documents.length ; i++){
                  controls.add(new FlareControls());
                }
                return CustomScrollView(
      physics: ScrollPhysics(
        parent: BouncingScrollPhysics()
      ),
      slivers: [
        logoAppBar(context,title: 'Home'),
        
        SliverList(
              delegate: SliverChildBuilderDelegate(
                (context , index){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PostCard(//Custom Card for Posts
                      title: snapshot.data.documents[index]['title'], 
                      caption: snapshot.data.documents[index]['content'], 
                      url: snapshot.data.documents[index]['url'], 
                      id: snapshot.data.documents[index]['docId'], 
                      likes: snapshot.data.documents[index]['likes'],
                      flareControls: controls[index],
                      creatorUid: snapshot.data.documents[index]['uid'],
                      interactionDisabled: false,
                    ),
                  );
                },
                childCount: snapshot.data.documents.length
              ),
            ),
      ],
          );
              }
              else{
                return Center(
                  child: LoadingFlipping.circle(
                    borderColor: Colors.amber,
                  ),
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
      onPressed: () async {
        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new NewPost()));
      },
      icon: Icon(Icons.add, color: Colors.white,),
      backgroundColor: Colors.amber[800],
      label: Text('Post')
          ),
          drawer: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.amberAccent, Colors.amber]),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50.0),
              )
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width*0.6,
            child: Stack(
                children: [
                  ListView(
                children: [
                  SizedBox(height: 50.0),
                  ListTile(
                    leading: Icon(Icons.help),
                    title: Text('Help'),
                    onTap: () {
                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new IntroPage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.bookmark),
                    title: Text('Saved'),
                    onTap: (){
                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new SavedPostsPage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap: (){
                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new SettingsPage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Sign Out'),
                    onTap: () {
                      AuthService().signOut();
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SvgPicture.asset(
                  'assets/images/drawer.svg',
                  height: 400.0,
                ),
              ),
                ],
                alignment: Alignment.bottomCenter,
            ),
          )
        ),
    );
  }
}