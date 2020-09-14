import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:pilgrimage/constants/postCard.dart';
import 'package:pilgrimage/constants/titleAppBar.dart';
import 'package:pilgrimage/models/post.dart';
import 'package:pilgrimage/models/user.dart';
import 'package:provider/provider.dart';
class SavedPostsPage extends StatefulWidget {
  @override
  _SavedPostsPageState createState() => _SavedPostsPageState();
}

class _SavedPostsPageState extends State<SavedPostsPage> {

  Future<List<Post>> getPosts() async {

    final user = Provider.of<User>(context);

    final uid = user.uid;
    
    List saved = new List();
    
    await Firestore.instance.collection('users').document(uid).get().then((snapshot){
      saved = snapshot.data['saved'];
    });

    List<Post> data = new List();
    await Firestore.instance.collection('posts').getDocuments().then(
      (snapshot){
        int length = snapshot.documents.length;

        print(length);

        snapshot.documents.forEach((element) { 
          if(saved.contains(element['docId'])){
            data.add(new Post(
            title: element['title'],
            caption: element['content'],
            id: element['docId'],
            url: element['url'],
            category: element['category'],
            likes: element['likes'],
          ));
          }
        });

      }
    );

    return data;

  }

  @override
  Widget build(BuildContext context) {

    Future<List<Post>> data = getPosts();
    List<FlareControls> controls = new List();
    return Scaffold(
      body: FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if(snapshot.hasData == true){
            int i = 0;
          for(i=0 ; i<snapshot.data.length ; i++){
                  controls.add(new FlareControls());
                }
            return CustomScrollView(
              physics: ScrollPhysics(
                parent: BouncingScrollPhysics()
              ),
              slivers: [
                titleAppBar(title: 'Saved Posts'),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context , index){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PostCard(
                          title: snapshot.data[index].title, 
                          caption: snapshot.data[index].caption, 
                          url: snapshot.data[index].url, 
                          id: snapshot.data[index].id, 
                          likes: snapshot.data[index].likes,
                          flareControls: controls[index],
                          interactionDisabled: true,
                        ),
                      );
                    },
                    childCount: snapshot.data.length
                  ),
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