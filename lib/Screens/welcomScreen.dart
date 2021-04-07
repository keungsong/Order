import 'package:flutter/material.dart';
import 'package:order/Login/login.dart';
import 'package:order/Provider/LocationProvider.dart';
import 'package:order/Screens/MapScreen.dart';
import 'package:order/Screens/OnboradScreen.dart';
import 'package:order/Screens/home.dart';
import 'package:provider/provider.dart';
import 'package:order/Provider/authProvider.dart';

class WelcomScreen extends StatefulWidget {
  static const String id = 'welcome-screen';
  @override
  _WelcomScreenState createState() => _WelcomScreenState();
}

class _WelcomScreenState extends State<WelcomScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    bool _validPhoneNumber = false;
    var _phoneNumberController = TextEditingController();

    void showBottomSheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, StateSetter myState) {
          return SingleChildScrollView(
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
                        myState(() {
                          _validPhoneNumber = true;
                        });
                      } else {
                        myState(() {
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
                                myState(() {
                                  auth.loading = true;
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
                                  // auth.loading = false;
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
          );
        }),
      ).whenComplete(() {
        setState(() {
          auth.loading = false;
          _phoneNumberController.clear();
        });
      });
    }

    final locationData = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Positioned(
                  right: 0.0,
                  top: 20,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => Home()));
                    },
                    child: Text('ຂ້າມ>',
                        style: TextStyle(
                            color: Colors.deepOrangeAccent, fontSize: 18)),
                  )),
              Column(
                children: [
                  Expanded(child: OnboardScreen()),
                  Text(' ພ້ອມສັ່ງແລ້ວຫຼືບໍ່? '),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                      color: Colors.orange,
                      onPressed: () async {
                        setState(() {
                          locationData.loading = true;
                        });
                        await locationData.getCurrentPosition();
                        if (locationData.permissionAllowed == true) {
                          Navigator.pushReplacementNamed(context, MapScreen.id);
                          setState(() {
                            locationData.loading = false;
                          });
                        } else {
                          print('ຍັງບໍໄດ້ຮັບອານຸຍາດ');
                          setState(() {
                            locationData.loading = false;
                          });
                        }
                      },
                      child: locationData.loading
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              'ຕັ້ງຄ່າສະຖານທີ່ຈັດສົ່ງ',
                              style: TextStyle(color: Colors.white),
                            )),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          auth.screen = 'ເຂົ້າລະບົບ';
                        });
                        showBottomSheet(context);
                      },
                      child: RichText(
                          text: TextSpan(
                              text: 'ເປັນສະມາຊີກແລ້ວຫຼືບໍ່ ? ',
                              style: TextStyle(color: Colors.black54),
                              children: [
                            TextSpan(
                                text: 'ເຂົ້າສູ່ລະບົບ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue))
                          ])))
                ],
              ),
            ],
          )),
    );
  }
}
