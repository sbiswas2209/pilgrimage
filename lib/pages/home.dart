import 'package:curved_drawer/curved_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('Home'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(50.0),
              )
            ),
            floating: true,
            pinned: true,
            toolbarHeight: 40.0,
            collapsedHeight: 50.0,
            expandedHeight: 200.0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.amber, Colors.amberAccent]),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(50.0),
                ),
              ),
            ),
          ),
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
      drawer: Drawer()
    );
  }
}