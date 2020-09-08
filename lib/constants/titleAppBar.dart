import 'package:flutter/material.dart';
SliverAppBar titleAppBar({
  @required String title,
  List<Widget> actions,
  bool automaticallyImplyLeading = true,
  Widget leading,
}){
  return SliverAppBar(
    title: Text('$title'),
    actions: actions,
    automaticallyImplyLeading: automaticallyImplyLeading,
    pinned: false,
    floating: true,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.amber, Colors.amberAccent]),
      ),
    ),
  );
}