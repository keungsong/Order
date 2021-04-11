import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:order/Provider/LocationProvider.dart';
import 'package:order/Provider/authProvider.dart';
import 'package:order/Screens/MapScreen.dart';
import 'package:order/Screens/welcomScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppBar extends StatefulWidget {
  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  String _location = '';
  String _address = '';

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String location = prefs.getString('location');
    String address = prefs.getString('address');
    setState(() {
      _location = location;
      _address = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    return AppBar(
      automaticallyImplyLeading: false,
      title: FlatButton(
        onPressed: () {
          locationData.getCurrentPosition();
          if (locationData.permissionAllowed == true) {
            Navigator.pushReplacementNamed(context, MapScreen.id);
          } else {
            print('ບໍ່ໄດ້ຮັບອານຸຍາດ');
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    _location == null ? 'ກະລຸນາລະບຸສະຖານທີ່ຈັດສົ່ງ' : _location,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                )
              ],
            ),
            Flexible(
                child: Text(
              _address,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: Colors.white),
            )),
          ],
        ),
      ),
      elevation: 0.0,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            decoration: InputDecoration(
                hintText: 'ຄົ້ນຫາ',
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.orange,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: Colors.white),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: IconButton(
              icon: Icon(
                Icons.account_circle_outlined,
              ),
              color: Colors.white,
              onPressed: () {
                auth.error = '';
                FirebaseAuth.instance.signOut().then((value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WelcomScreen(),
                    )));
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: IconButton(
              icon: Icon(Icons.power_settings_new),
              color: Colors.white,
              onPressed: () {
                auth.error = '';
                FirebaseAuth.instance.signOut().then((value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WelcomScreen(),
                    )));
              }),
        ),
      ],
    );
  }
}
