import 'package:flutter/cupertino.dart';

class Post{

  final String title;
  final String caption;
  final String url;
  final String category;
  final String id;
  final List<dynamic> likes;

  Post({
    @required this.title,
    @required this.caption,
    @required this.category,
    @required this.id,
    @required this.url,
    @required this.likes,
  });

}