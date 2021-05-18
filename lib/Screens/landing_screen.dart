import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:order/Providers/location_provider.dart';
import 'package:order/Screens/home.dart';
import 'package:order/Screens/map_screen.dart';
import 'package:order/Services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingScreen extends StatefulWidget {
  static const String id = 'landing-screen';
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LocationProvider _locationProvider = LocationProvider();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'ຍັງບໍ່ໄດ້ເລືອກສະຖານທີ່ຮັບເຄື່ອງ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('ກະລຸນາ ເລືອກສະຖານທີ່ຮັບເຄື່ອງທີ່ໃກ້ຮ້ານສຳລັບທ່ານ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  )),
            ),
            // CircularProgressIndicator(),
            Container(
              width: 600,
              child: Lottie.asset('assets/city.json'),
            ),
            _loading
                ? CircularProgressIndicator()
                : FlatButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                      });
                      await _locationProvider.getCurrentPosition();
                      if (_locationProvider.permissionAllowed == true) {
                        Navigator.pushReplacementNamed(context, MapScreen.id);
                      } else {
                        Future.delayed(Duration(seconds: 4), () {
                          if (_locationProvider.permissionAllowed == false) {
                            print('ຍັງບໍ່ມີສິດທີ່');
                            setState(() {
                              _loading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('ກະລຸນາ ຊອກຫາຮ້ານທີ່ໃກ້ທ່ານ')));
                          }
                        });
                      }
                    },
                    child: Text(
                      'ເລືອກສະຖານທີ່',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
