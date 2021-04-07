import 'package:flutter/material.dart';
import 'package:order/Provider/LocationProvider.dart';
import 'package:order/Provider/authProvider.dart';
import 'package:order/Screens/home.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _validPhoneNumber = false;
  var _phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              children: [
                Visibility(
                  visible: auth.error == ' OTP ບໍ່ຖືກຕ້ອງ' ? true : false,
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          auth.error,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  'ເຂົ້າລະບົບຜ່ານເບີໂທ',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                Text(
                  'ປ້ອນເບີໂທລະສັບເພື່ອດຳເນີນການຕໍ່',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                      prefixText: '+85620', labelText: 'ປ້ອນເບີໂທຂອງທ່ານ'),
                  autofocus: true,
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  maxLength: 8,
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
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: AbsorbPointer(
                        absorbing: _validPhoneNumber ? false : true,
                        child: FlatButton(
                            color: _validPhoneNumber
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                            onPressed: () {
                              setState(() {
                                auth.loading = true;
                                auth.screen = 'MapSreen';
                                auth.latitude = locationData.latitude;
                                auth.longitude = locationData.longitude;
                                auth.address =
                                    locationData.selectedAddress.addressLine;
                              });
                              String number =
                                  '+85620${_phoneNumberController.text}';
                              auth
                                  .verifyPhone(
                                context: context,
                                number: number,
                              )
                                  .then((value) {
                                _phoneNumberController.clear();
                                setState(() {
                                  auth.loading = false;
                                });
                              });
                            },
                            child: auth.loading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : Text(
                                    _validPhoneNumber
                                        ? 'ດຳເນີນການຕໍ່'
                                        : 'ກະລຸນາປ້ອນເບີໂທຂອງທ່ານ',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  )),
                      ),
                    )
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
