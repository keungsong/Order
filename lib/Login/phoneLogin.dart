import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:order/Login/otp.dart';
import 'package:order/Provider/authProvider.dart';
import 'package:order/Screens/home.dart';
import 'package:provider/provider.dart';

enum AuthFormType { phone }

class PhoneLogin extends StatefulWidget {
  final AuthFormType authFormType;

  const PhoneLogin({Key key, this.authFormType}) : super(key: key);
  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  String phoneNumber;
  String smsCode;
  String verificationId;
  bool visible = false;
  String phoneIsoCode;
  String confirmedNumber = '';
  TextEditingController _phoneController = TextEditingController();

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    print(number);
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  onValidPhoneNumber(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      visible = true;
      confirmedNumber = internationalizedPhoneNumber;
    });
  }

  Future<void> _verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialog(context).then((value) {
        print('ເຂົ້າສູ່ລະບົບ');
      });
    };

    final PhoneVerificationCompleted verifiedSuccess =
        (AuthCredential credential) {
      setState(() {
        print('ຢືນຢັນ');
        print(credential);
      });
    };

    /*final PhoneVerificationFailed verifiFailded = (AuthException exception) {
      print('${exception.message}');
    };*/
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNumber,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: null);
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('ກະລຸນາປ້ອນລະຫັດ'),
            content: TextField(
              onChanged: (value) {
                this.smsCode = value;
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: '6 ຕົວເລກ'),
              controller: _phoneController,
              keyboardType: TextInputType.text,
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                onPressed: () {},
                child: Text('ດຳເນີນການຕໍ່'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 30, top: 60, right: 30),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'ປ້ອນເບີໂທລະສັບ',
              style: TextStyle(fontSize: 20),
            ),
            // Spacer(flex: 1),
            SizedBox(height: 20),

            InternationalPhoneInput(
              onPhoneNumberChange: onPhoneNumberChange,
              initialPhoneNumber: phoneNumber,
              initialSelection: phoneIsoCode,
              enabledCountries: ['+856', ''],
              hintText: "ເບີໂທລະສັບ",
            ),

            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: _verifyPhone,
              color: Colors.orange,
              elevation: 7,
              child: Text(
                'ດຳເນີນການຕໍ່',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),

            //Spacer(flex: 2),
            /*Container(
              child: ElevatedButton(
                  child: Text("Continue".toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orange),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                              side: BorderSide(color: Colors.yellow)))),
                  onPressed: _verifyPhone),
            )*/
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  signin() {
    AuthCredential phoneAuthCredential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);
    FirebaseAuth.instance
        .signInWithCredential(phoneAuthCredential)
        .then((user) => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Home()),
            ))
        .catchError((e) => print(e));
  }
}
