import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register-screen';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              SizedBox(
                width: 100,
                height: 100,
                child: Hero(
                  tag: 'logo',
                  child: Lottie.asset('assets/register.json', fit: BoxFit.fill),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'ລົງທະບຽນ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(),
              TextField(),
              TextField(),
            ],
          ),
        ),
      ),
    );
  }
}
