import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:flutter/material.dart';
import 'package:order/Screens/home.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:pinput/pin_put/pin_put_state.dart';

/*class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  String verificationId;
  String phoneNumber;
  String smsCode;

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  final BoxDecoration pinPutDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(0),
      border: Border.all(color: Colors.grey));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text('Phone Verification'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Center(
              child: Text(
                'Please type the code',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Center(
              child: Text(
                ' sent To +856',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: PinPut(
              fieldsCount: 6,
              textStyle: TextStyle(fontSize: 20, color: Colors.black),
              eachFieldWidth: 40,
              eachFieldHeight: 55,
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration,
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.scale,
              onSubmit: (pin) async {},
            ),
          )
        ],
      ),
    );
  }

  _verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
    };

    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential user) {
      print('Verify');
    };

    final PhoneVerificationFailed verifiFailded =
        (FirebaseAuthException exception) {
      print('${exception.message}');
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNumber,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: verifiFailded);
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Please enter code'),
            content: TextField(
              onChanged: (value) {
                this.smsCode = value;
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: '6 Number'),
              // controller: _controllerPhone,
              keyboardType: TextInputType.text,
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {},
                child: Text('Continue'),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }
}*/
