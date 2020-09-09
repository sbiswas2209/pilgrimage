import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilgrimage/services/authService.dart';
SliverAppBar logoAppBar({
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
                onTap: (){
                  AuthService().signOut();
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