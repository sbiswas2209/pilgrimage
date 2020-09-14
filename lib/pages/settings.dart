import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:pilgrimage/auth/authScreen.dart';
import 'package:pilgrimage/constants/titleAppBar.dart';
import 'package:pilgrimage/models/user.dart';
import 'package:pilgrimage/pages/editProfilePage.dart';
import 'package:pilgrimage/pages/savedPostsPage.dart';
import 'package:pilgrimage/services/authService.dart';
import 'package:provider/provider.dart';
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {



  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    final uid = user.uid;

    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('users').document(uid).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData == true){
            return CustomScrollView(
              physics: ScrollPhysics(
                parent: BouncingScrollPhysics()
              ),
              slivers: [
                titleAppBar(title: 'Settings'),
                SliverGrid.count(
                  crossAxisCount: 1,
                  childAspectRatio: 2,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)
                        ),
                        child: ClayContainer(
                          emboss: false,
                          depth: 50,
                          customBorderRadius: BorderRadius.circular(25.0),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot.data['profilePic']),
                                ),
                                title: Text('Email : ${snapshot.data['email']}'),
                                trailing: IconButton(
                                  icon: Icon(Icons.edit), 
                                  onPressed: (){
                                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new EditProfilePage(url: snapshot.data['profilePic'],)));
                                  }
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)
                        ),
                        child: ClayContainer(
                          emboss: false,
                          depth: 50,
                          customBorderRadius: BorderRadius.circular(25.0),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: ListTile(
                                leading: Icon(Icons.bookmark),
                                title: Text('Saved Posts'),
                                subtitle: Text('Count : ${snapshot.data['saved'].length}'),
                                onTap: (){
                                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new SavedPostsPage()));
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)
                        ),
                        child: ClayContainer(
                          emboss: false,
                          depth: 50,
                          customBorderRadius: BorderRadius.circular(25.0),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: ListTile(
                                leading: Icon(Icons.info),
                                title: Text('About'),
                                onTap: (){
                                  showAboutDialog(context: context);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          }
          else{
            return LoadingFlipping.circle(
              borderColor: Colors.amber,
            );
          }
        },
      ),
    );
  }
}