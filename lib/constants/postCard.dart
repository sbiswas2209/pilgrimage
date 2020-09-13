import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
//import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
//import 'package:like_button/like_button.dart';
import 'package:pilgrimage/models/user.dart';
import 'package:provider/provider.dart';

import 'controls.dart';
class PostCard extends StatefulWidget {

  final String title;
  final String caption;
  final String url;
  final String id;
  final List<dynamic> likes;
  FlareControls flareControls;

  PostCard({
    @required this.title,
    @required this.caption,
    @required this.url,
    @required this.id,
    @required this.likes,
    this.flareControls,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  @override
  Widget build(BuildContext context) {


    final user = Provider.of<User>(context);
    final uid = user.uid;

    bool liked = widget.likes.contains(uid);

    //FlareControls flareControls = FlareControls();

    return ClayContainer(
      depth: 50,
      emboss: true,
      customBorderRadius: BorderRadius.circular(25.0),
      color: Colors.white,
      height: 600.0,
      width: MediaQuery.of(context).size.width,
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(25.0),
      //   color: Colors.amber,
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: 4,
                      child: GestureDetector(
              onDoubleTap: () async {
                widget.flareControls.play("like");
                if(liked == true){
                        widget.likes.remove(uid);
                      }
                      else{
                        widget.likes.add(uid);
                      }
                      await Firestore.instance.collection('posts').document('${widget.id}').updateData({
                          'likes' : widget.likes,
                        });
                        // setState(() {
                        //   widget.flareControls = FlareControls();
                        // });
                        
              },
                        child: Stack(
                          children: [
                            Container(
                width: MediaQuery.of(context).size.width,
                height: 400.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.amber,
                  image: DecorationImage(
                    image: NetworkImage('${widget.url}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 400,
                width: 400,
                child: SizedBox(
                                width: 80,
                                height: 80,
                                            child: FlareActor(
                                  'assets/images/instagram_like.flr',
                                  controller: widget.flareControls,
                                  animation: 'idle',
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
              ),
                          ],
                          alignment: Alignment.center,
                        ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder(
                stream: Firestore.instance.collection('users').document(uid).snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData == true){
                    return FlatButton(
                    onPressed: () async {
                      print(snapshot.data['saved']);
                      print(snapshot.data.toString());
                      if(snapshot.data['saved'].contains(widget.id) == true){
                        print(true);
                        print(snapshot.data['saved'].indexOf(widget.id));
                        List list = snapshot.data['saved'];
                        list.remove(widget.id);
                        print(list);
                        
                      }
                      else{
                        print(false);
                      }
                    }, 
                    child: Icon(Icons.bookmark_border)
                  );
                  }
                  else{
                    return SizedBox(height: 1);
                  }
                }
              ),
              SizedBox(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0 , 10.0 , 15.0 , 0.0),
                child: FlatButton.icon(
                  onPressed: () async {
                    if(liked == true){
                      widget.likes.remove(uid);
                    }
                    else{
                      widget.likes.add(uid);
                    }
                    await Firestore.instance.collection('posts').document('${widget.id}').updateData({
                        'likes' : widget.likes,
                      });
                      widget.flareControls.play('like');
                  },
                  icon: Icon(Icons.favorite, color: liked == true ? Colors.redAccent : Colors.black,),
                  label: Text('${widget.likes.length}'),
                ),
                // child: LikeButton(
                //   isLiked: widget.likes.contains(uid),
                //   likeCount: widget.likes.length,
                //   onTap: (isLiked) async {
                //     if(liked == true){
                //       widget.likes.remove(uid);
                //     }
                //     else{
                //       widget.likes.add(uid);
                //     }
                //     await Firestore.instance.collection('posts').document('${widget.id}').updateData({
                //         'likes' : widget.likes,
                //       });
                //       return liked;
                //   },
                // ),
              ),
            ],
          ),
          Flexible(
            flex: 2,
                      child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('${widget.title}',
                style: Theme.of(context).textTheme.headline1,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
          Flexible(
            flex: 1,
                      child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text('${widget.caption}',
                style: Theme.of(context).textTheme.bodyText1,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }
}