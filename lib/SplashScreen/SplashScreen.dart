import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:order/Screens/OnboradScreen.dart';

import 'package:order/Screens/home.dart';
import 'package:order/Screens/landing_screen.dart';
import 'package:order/Screens/main_screen.dart';
import 'package:order/Screens/register_screen.dart';
import 'package:order/Screens/welcom_screen.dart';
import 'package:order/Services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(seconds: 3), () {
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user == null) {
          Navigator.pushReplacementNamed(context, WelcomScreen.id);
        } else {
          Navigator.pushReplacementNamed(context, LandingScreen.id);

          getUserData();
        }
      });
    });
    super.initState();
  }

  getUserData() async {
    UserServices _userServices = UserServices();
    _userServices.getUserById(user.uid).then((result) {
      // chack location detials or not
      if (result.data()['address'] != null) {
        // if address detail exists
        updatePrefs(result);
      }
      // if address detail not exists
      Navigator.pushReplacementNamed(context, LandingScreen.id);
    });
  }

  Future<void> updatePrefs(result) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setDouble('latitude', result['latitude']);
    prefs.setDouble('longitude', result['longitude']);
    prefs.setString('address', result['address']);
    prefs.setString('location', result['location']);

    Navigator.pushReplacementNamed(context, MainScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'Logo',
          child: Lottie.asset('assets/loading.json'),
        ),
      ),
    );
  }
}
