import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order/Provider/LocationProvider.dart';
import 'package:order/Screens/MapScreen.dart';
import 'package:order/Screens/home.dart';
import 'package:order/Services/UserSerice.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auht = FirebaseAuth.instance;
  String smsOtp;
  String verificationId;
  String phoneNumber;
  String error = '';
  UserServices _userServices = UserServices();
  bool loading = false;
  LocationProvider locationData = LocationProvider();
  String screen;
  double latitude;
  double longitude;
  String address;

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
      await _auht.signInWithCredential(credential);
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      this.loading = false;
      print(e.code);
      this.error = e.toString();
      notifyListeners();
    };

    final PhoneCodeSent smsOtpSend = (String verId, int resendToken) async {
      this.verificationId = verId;

      // diaglog show enter received otp sms

      smsOtpDialog(context, number);
    };

    try {
      _auht.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: smsOtpSend,
          codeAutoRetrievalTimeout: (String veriId) {
            this.verificationId = veriId;
          });
    } catch (e) {
      this.loading = false;
      this.error = e.toString();

      notifyListeners();
      print(e);
    }
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
                Text('ລະຫັດ ຢືນຢັນ'),
                SizedBox(
                  height: 6,
                ),
                Text('ປ້ອນລະຫັດ ຢືນຢັນ 6 ຕົວເລກທີ່ສົ່ງເຂົ້າ SMS',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            content: Container(
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) {
                  this.smsOtp = value;
                },
              ),
            ),
            actions: [
              FlatButton(
                  onPressed: () async {
                    try {
                      PhoneAuthCredential phoneAuthCredential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationId, smsCode: smsOtp);
                      final User user = (await _auht
                              .signInWithCredential(phoneAuthCredential))
                          .user;
                      if (user != null) {
                        this.loading = false;
                        notifyListeners();
                        _userServices.getUserById(user.uid).then((snapShot) {
                          if (snapShot.exists) {
                            // user data aalready exists
                            if (this.screen == 'ເຂົ້າລະບົບ') {
                              // neet to check user data already exists in db or not
                              // if its 'login' no new data so no need to update
                              Navigator.pushReplacementNamed(context, Home.id);
                            } else {
                              // need to update new selected address
                              print(
                                  '${locationData.latitude}:${locationData.longitude}');
                              updateUser(
                                  id: user.uid, number: user.phoneNumber);
                              Navigator.pushReplacementNamed(context, Home.id);
                            }
                          } else {
                            // user data dont exists
                            // will create new data in db

                            _createUser(id: user.uid, number: user.phoneNumber);
                            Navigator.pushReplacementNamed(context, Home.id);
                          }
                        });
                      } else {
                        print('ເຂົ້າລະບົບຜີດພາດ');
                      }
                      /* if (locationData.selectedAddress != null) {
                        updateUser(
                            id: user.uid,
                            number: user.phoneNumber,
                            latitude: locationData.latitude,
                            longitude: locationData.longitude,
                            address: locationData.selectedAddress.addressLine);
                      } else {
                        _createUser(
                            id: user.uid,
                            number: user.phoneNumber,
                            latitude: latitude,
                            longitude: longitude,
                            address: address);
                      }

                      if (user != null) {
                        Navigator.of(context).pop();

                        Navigator.pushReplacementNamed(context, Home.id);
                      } else {
                        print('ເຂົ້າລະບົບຜິດພາດ');
                      }*/
                    } catch (e) {
                      this.error = ' OTP ບໍ່ຖືກຕ້ອງ!';
                      notifyListeners();
                      print(e.toString());
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    'ດຳເນີນຕໍ່',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ))
            ],
          );
        }).whenComplete(() {
      this.loading = false;
      notifyListeners();
    });
  }

  void _createUser({
    String id,
    String number,
  }) {
    _userServices.createUserData({
      'id': id,
      'number': number,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'address': this.address
    });
    this.loading = false;
    notifyListeners();
  }

  Future<bool> updateUser({
    String id,
    String number,
  }) async {
    try {
      _userServices.createUserData({
        'id': id,
        'number': number,
        'latitude': this.latitude,
        'longitude': this.longitude,
        'address': this.address
      });
      this.loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error $e');
      return false;
    }
  }
}
