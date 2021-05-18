import 'package:flutter/material.dart';
import 'package:order/Constants/constants.dart';
import 'package:order/Providers/auth_provider.dart';
import 'package:order/Providers/location_provider.dart';

import 'package:order/Screens/home.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _validPhoneNumber = false;
  var _textPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: auth.error == 'OTP ບໍ່ຖືກຕ້ອງ' ? true : false,
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          auth.error,
                          style: TextStyle(color: Colors.red),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'ເຂົ້າລະບົບດ້ວຍເບີໂທ',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                Text(
                  'ກະລຸນາ ໃສ່ເບີໂທລະສັບຂອງທ່ານ 8 ຕົວເລກ',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _textPhoneController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone_android),
                    prefixText: '+85620',
                  ),
                  autofocus: true,
                  maxLength: 8,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    if (value.length == 8) {
                      setState(() {
                        _validPhoneNumber = true;
                      });
                    } else {
                      setState(() {
                        _validPhoneNumber = false;
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    // ignore: deprecated_member_use
                    Expanded(
                      child: AbsorbPointer(
                        absorbing: _validPhoneNumber ? false : true,
                        child: FlatButton(
                          color: _validPhoneNumber
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          child: auth.loading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text(
                                  _validPhoneNumber
                                      ? 'ກົດເພື່ອດຳເນີນການຕໍ່'
                                      : 'ເຂົ້າສູ່ລະບົບ',
                                  style: textStyle,
                                ),
                          onPressed: () {
                            setState(() {
                              auth.loading = true;
                              auth.screen = 'MapScreen';
                              auth.latitude = locationData.latitude;
                              auth.longitude = locationData.longitude;
                              auth.address =
                                  locationData.selectedAddress.addressLine;
                            });
                            String number =
                                '+85620${_textPhoneController.text}';
                            auth
                                .verifyPhone(
                              context: context,
                              number: number,
                            )
                                .then((value) {
                              _textPhoneController.clear();

                              setState(() {
                                auth.loading = false;
                              });
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
