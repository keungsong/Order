import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:order/Screens/welcom_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            pushNewScreenWithRouteSettings(context,
                screen: WelcomScreen(),
                settings: RouteSettings(name: WelcomScreen.id),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino);
          },
          child: Text('ອອກຈາກລະບົບ'),
        ),
      ),
    );
  }
}
