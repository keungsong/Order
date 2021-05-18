import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:order/Constants/constants.dart';
import 'package:order/Constants/localization_constants.dart';
import 'package:order/Localization/localization.dart';
import 'package:order/Providers/auth_provider.dart';
import 'package:order/Providers/location_provider.dart';

import 'package:order/Screens/OnboradScreen.dart';
import 'package:order/Screens/home.dart';
import 'package:order/Screens/map_screen.dart';
import 'package:order/classes/language.dart';
import 'package:order/main.dart';
import 'package:provider/provider.dart';

class WelcomScreen extends StatefulWidget {
  static const String id = 'welcome-screen';

  @override
  _WelcomScreenState createState() => _WelcomScreenState();
}

class _WelcomScreenState extends State<WelcomScreen> {
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    bool _validPhoneNumber = false;
    var _textPhoneController = TextEditingController();

    void showBottomSheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, StateSetter myState) {
          return Container(
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
                              myState(() {
                                auth.loading = true;
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
                                auth.loading = false;
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
          );
        }),
      ).whenComplete(() {
        setState(() {
          auth.loading = false;
          _textPhoneController.clear();
        });
      });
    }

    final locationData = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
        /* appBar: AppBar(
          actions: [
            /*Padding(
              padding: const EdgeInsets.all(20.0),
              child: DropdownButton(
                onChanged: (Language language) {
                  _changeLanguage(language);
                },
                underline: SizedBox(),
                 icon: Icon(
                  Icons.translate,
                  color: Colors.white,
                ),
                items: Language.languageList()
                    .map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(
                          value: lang,
                          child: Row(
                            children: [
                              Text(lang.name),
                              SizedBox(width: 8),
                              Text(lang.flag),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),*/
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Home()));
                  },
                  child: Text(
                    'ຂ້າມໄປກ່ອນ >',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
            ),
          ],
        ),*/
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(child: OnboardScreen()),
              Text('ພ້ອມທີ່ຈະສັ່ງຊື້ຈາກຮ້ານທີ່ໃກ້ທ່ານແລ້ວບໍ່ ?',
                  style: TextStyle(color: Colors.grey)),
              SizedBox(height: 20),
              FlatButton(
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
                    print('ຍັງບໍ່ໄດ້ຮັບການອະນຸຍາດ');
                    setState(() {
                      locationData.loading = false;
                    });
                  }
                },
                child: locationData.loading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        'ຕັ້ງຄ່າສະຖານທີ່ຈັດສົ່ງ',
                        style: textStyle,
                      ),
                color: Colors.orange,
              ),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                  onPressed: () {
                    setState(() {
                      auth.screen = 'screen';
                    });
                    showBottomSheet(context);
                  },
                  child: RichText(
                      text: TextSpan(
                          text: 'ທ່ານມີບັນຊີແລ້ວບໍ່ ? ',
                          style: TextStyle(color: Colors.black),
                          children: [
                        TextSpan(
                            text: 'ເຂົ້າສູ່ລະບົບ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue))
                      ]))),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ],
      ),
    ));
  }

  void _changeLanguage(Language language) {
    Locale _temp;
    switch (language.languageCode) {
      case 'en':
        _temp = Locale(language.languageCode, 'US');
        break;
      case 'zh':
        _temp = Locale(language.languageCode, 'LA');
        break;
      default:
        _temp = Locale(language.languageCode, 'US');
    }
    // MyApp.setLocale(context, _temp);
  }
}
