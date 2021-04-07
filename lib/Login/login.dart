import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:order/Login/phoneLogin.dart';
import 'package:order/Login/test.dart';
import 'package:order/animation/FadeAnimation.dart';
import 'package:simple_animations/simple_animations.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildSocialBtnRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PhoneLogin()));
          },
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6.0)
              ],
            ),
            child: Icon(
              Icons.phone,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(''),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 500,
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  FadeAnimation(1, Text('Sign in to continue')),
                  SizedBox(
                    height: 10,
                  ),
                  FadeAnimation(
                      1.2,
                      Text(
                        'Book Store',
                        style: TextStyle(
                            fontSize: 50,
                            color: Colors.white,
                            shadows: [
                              BoxShadow(
                                  blurRadius: 10,
                                  color: Colors.green.shade900,
                                  offset: Offset(3, 3))
                            ]),
                      )),
                  SizedBox(
                    height: 80,
                  ),
                  FadeAnimation(
                      1.3,
                      SignInButton(
                        Buttons.Google,
                        text: "Sign up with Google",
                        onPressed: () {},
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  FadeAnimation(
                      1.4,
                      SignInButton(
                        Buttons.Facebook,
                        text: "Sign up with Facebook",
                        onPressed: () {},
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      FadeAnimation(
                          1.5,
                          Text(
                            '-- or --',
                            style: TextStyle(color: Colors.black),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      FadeAnimation(
                          1.5,
                          Text(
                            'sign in with',
                            style: TextStyle(color: Colors.black),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(1.6, _buildSocialBtnRow())
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
