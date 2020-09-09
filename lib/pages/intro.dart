import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:pilgrimage/auth/authScreen.dart';
import 'package:pilgrimage/pages/home.dart';
class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final introKey = GlobalKey<IntroductionScreenState>();
    void _onIntroEnd() {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => new HomePage()));
    }

    var pages = [
    PageViewModel(
      title: 'Share',
      body: 'Share your posts with others and get discovered.',
      decoration: PageDecoration(
        imageFlex: 3,
        titleTextStyle: Theme.of(context).textTheme.headline1,
        bodyTextStyle: Theme.of(context).textTheme.bodyText1,
        footerPadding: EdgeInsets.fromLTRB(10, 20.0, 10, 10.0),
            titlePadding: EdgeInsets.all(10.0)
      ),
      image: SvgPicture.asset(
          'assets/images/slide-1.svg',
          height: 200.0,
      ),
    ),
    PageViewModel(
      title: 'Explore',
      body: 'Discover other artists and see our beautiful planet at your own comfort.',
      decoration: PageDecoration(
        imageFlex: 3,
        titleTextStyle: Theme.of(context).textTheme.headline1,
        bodyTextStyle: Theme.of(context).textTheme.bodyText1,
        footerPadding: EdgeInsets.fromLTRB(10, 20.0, 10, 10.0),
            titlePadding: EdgeInsets.all(10.0)
      ),
      image: SvgPicture.asset(
          'assets/images/slide-2.svg',
          height: 200.0,
      ),
    )
  ];
    return IntroductionScreen(
      pages: pages,
      onDone: _onIntroEnd,
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: Text(
        'Skip',
        style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 15.0),
      ),
      // done: Text(
      //   'Continue',
      //   style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 15.0),
      // ),
      done: Icon(
        Icons.check,
        color: Colors.amber,
        size: 40.0,
      ),
      next: Icon(
        Icons.arrow_right_alt,
        color: Colors.amber,
        size: 40.0,
      ),
      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.amber,
        activeColor: Colors.amberAccent,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}