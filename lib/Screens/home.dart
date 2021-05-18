import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:order/Providers/auth_provider.dart';
import 'package:order/Providers/location_provider.dart';
import 'package:order/Screens/map_screen.dart';
import 'package:order/widgets/nearby_store.dart';
import 'package:order/widgets/top_pick_store.dart';
import 'package:order/Screens/welcom_screen.dart';
import 'package:order/widgets/image_slide.dart';
import 'package:order/widgets/my_appbar.dart';

class Home extends StatefulWidget {
  static const String id = 'home-screen';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(112),
        child: MyAppBar(),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 0.0),
        children: [
          ImageSilde(),
          Container(
            color: Colors.white,
            child: TopPickStore(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: NearByStore(),
          ),
        ],
      ),
    );
  }
}
