import 'package:flutter/material.dart';
import 'package:order/Screens/top_pick_store.dart';

import 'package:order/widgets/AppBar.dart';
import 'package:order/widgets/ImageSlide.dart';

class Home extends StatefulWidget {
  static const String id = 'home-screen';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(112),
        child: MyAppBar(),
      ),
      body: Center(
        child: Column(
          children: [ImageSlider(), TopPickStore()],
        ),
      ),
    );
  }
}
