import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pilgrimage/models/user.dart';
import 'package:provider/provider.dart';
class PostCard extends StatefulWidget {

  final String title;
  final String caption;
  final String url;
  final String id;
  final int likes;

  PostCard({
    @required this.title,
    @required this.caption,
    @required this.url,
    @required this.id,
    @required this.likes,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  bool liked = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final uid = user.uid;
    return Container(
      height: 600.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.amber,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onDoubleTap: () async {
              setState(() {
                      liked = !liked;
                    });
                    if(liked == true){
                      await Firestore.instance.collection('posts').document('${widget.id}').updateData({
                        'likes' : FieldValue.increment(1),
                      });
                    }
                    if(liked == false){
                      await Firestore.instance.collection('posts').document('${widget.id}').updateData({
                        'likes' : FieldValue.increment(-1),
                      });
                    }
            },
                      child: Container(
              width: MediaQuery.of(context).size.width,
              height: 400.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.amber,
                image: DecorationImage(
                  image: NetworkImage('${widget.url}'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0 , 10.0 , 15.0 , 0.0),
                child: FlatButton.icon(
                  onPressed: () async {
                    setState(() {
                      liked = !liked;
                    });
                    if(liked == true){
                      await Firestore.instance.collection('posts').document('${widget.id}').updateData({
                        'likes' : FieldValue.increment(1),
                      });
                    }
                    if(liked == false){
                      await Firestore.instance.collection('posts').document('${widget.id}').updateData({
                        'likes' : FieldValue.increment(-1),
                      });
                    }
                  },
                  icon: Icon(Icons.thumb_up_sharp, color: liked == true ? Colors.white : Colors.black,),
                  label: Text('${widget.likes}'),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('${widget.title}',
              style: Theme.of(context).textTheme.headline1,
              overflow: TextOverflow.fade,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text('${widget.caption}',
              style: Theme.of(context).textTheme.bodyText1,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}