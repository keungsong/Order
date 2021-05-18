import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order/Providers/location_provider.dart';
import 'package:order/Screens/home.dart';
import 'package:order/Screens/landing_screen.dart';
import 'package:order/Screens/main_screen.dart';
import 'package:order/Screens/map_screen.dart';
import 'package:order/Services/user_services.dart';

class AuthProvider with ChangeNotifier {
  String smsOtp;
  String verificationId;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String error = '';
  UserServices _userServices = UserServices();
  bool loading = false;
  LocationProvider locationData = LocationProvider();
  String screen;
  double latitude;
  double longitude;
  String address;
  String location;

  Future<void> verifyPhone({
    BuildContext context,
    String number,
  }) async {
    this.loading = true;
    notifyListeners();
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      this.loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed = (FirebaseException e) {
      this.loading = false;
      print(e.code);
      this.error = e.toString();
      notifyListeners();
    };

    final PhoneCodeSent smsOtpSend = (String verId, int resendToken) async {
      this.verificationId = verId;

      // open dialog to enter received OTP SMS
      smsOtpDialog(context, number);
    };
    try {
      _auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: smsOtpSend,
          codeAutoRetrievalTimeout: (String verId) {
            this.verificationId = verId;
          });
    } catch (e) {
      print(e);
      this.error = e.toString();
      this.loading = false;
      notifyListeners();
    }
  }

// create user location
  void _createUser({
    String id,
    String number,
  }) {
    _userServices.createUserData({
      'id': id,
      'number': number,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'address': this.address,
      'location': this.location
    });
    this.loading = false;
    notifyListeners();
  }

  Future<bool> smsOtpDialog(
    BuildContext context,
    String number,
  ) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Text('ລະຫັດຢືນຢັນ'),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'ປ້ອນລະຫັດ 6 ຕົວເລກສົ່ງເຂົົ້າຂໍ້ຄວາມ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            content: Container(
              height: 85,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) {
                  this.smsOtp = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            actions: [
              FlatButton(
                  onPressed: () async {
                    try {
                      PhoneAuthCredential phoneAuthCredential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationId, smsCode: smsOtp);
                      final User user = (await _auth
                              .signInWithCredential(phoneAuthCredential))
                          .user;

                      if (user != null) {
                        this.loading = false;
                        notifyListeners();
                        _userServices.getUserById(user.uid).then((snapShot) {
                          if (snapShot.exists) {
                            // user already exists
                            if (this.screen == 'ເຂົ້າລະບົບ') {
                              // check user already in db or not
                              // if login, no new data,so no need to update
                              if (snapShot.data()['address'] != null) {
                                Navigator.pushReplacementNamed(
                                    context, MainScreen.id);
                              }
                              Navigator.pushReplacementNamed(
                                  context, LandingScreen.id);
                            } else {
                              print(
                                  '${locationData.latitude}:${locationData.longitude}');
                              updateUser(
                                  id: user.uid, number: user.phoneNumber);
                              Navigator.pushReplacementNamed(
                                  context, MainScreen.id);
                            }
                          } else {
                            // user not exists
                            // create new user

                            _createUser(id: user.uid, number: user.phoneNumber);
                            Navigator.pushReplacementNamed(
                                context, LandingScreen.id);
                          }
                        });
                      } else {
                        print('ເຂົ້າລະບົບລົ້ມແຫຼວ');
                      }

                      if (locationData.selectedAddress != null) {
                        updateUser(
                          id: user.uid,
                          number: user.phoneNumber,
                        );
                        Navigator.pushReplacementNamed(context, Home.id);
                      } else {
                        // create user data in db after user successfully registered.
                        _createUser(
                          id: user.uid,
                          number: user.phoneNumber,
                        );
                      }

                      // navigate to home screen after login
                      if (user != null) {
                        Navigator.of(context).pop();

                        //this.loading = false;

                        // don't want come back to welcome screen after logged in

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => Home(),
                        ));
                      } else {
                        print('ເຂົ້າລະບົບຜິດພາດ');
                      }
                    } catch (e) {
                      this.error = 'OTP ບໍ່ຖືກຕ້ອງ  ';
                      notifyListeners();
                      print(e.toString());
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    'ດຳເນີນການຕໍ່',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ))
            ],
          );
        }).whenComplete(() {
      this.loading = false;
      notifyListeners();
    });
  }

  // update user location
  Future<bool> updateUser({
    String id,
    String number,
  }) async {
    try {
      _userServices.updateUserData({
        'id': id,
        'number': number,
        'latitude': this.latitude,
        'longitude': this.longitude,
        'address': this.address,
        'location': this.location
      });
      this.loading = false;
      notifyListeners();

      return true;
    } catch (e) {
      print('ລົ້ມແຫຼວ $e');
      return false;
    }
  }
}
