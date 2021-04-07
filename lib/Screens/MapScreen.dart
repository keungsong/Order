import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:order/Provider/LocationProvider.dart';
import 'package:order/Provider/authProvider.dart';
import 'package:order/Screens/LoginScreen.dart';
import 'package:order/Screens/home.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map-screen';
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng currentLocation;
  GoogleMapController _mapController;
  bool _locating = false;
  bool _loggedIn = false;
  User user;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
      // _loggedIn = true;
    });

    if (user != null) {
      setState(() {
        _loggedIn = true;
        // user = FirebaseAuth.instance.currentUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    final _auth = Provider.of<AuthProvider>(context);

    setState(() {
      currentLocation = LatLng(locationData.latitude, locationData.longitude);
    });

    void onCreated(GoogleMapController controller) {
      setState(() {
        _mapController = controller;
      });
    }

    return Scaffold(
        body: Center(
      child: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLocation,
                zoom: 14.4746,
              ),
              zoomControlsEnabled: false,
              minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.8),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              mapToolbarEnabled: true,
              onCameraMove: (CameraPosition position) {
                setState(() {
                  _locating = true;
                });
                locationData.onCameraMove(position);
              },
              onMapCreated: onCreated,
              onCameraIdle: () {
                setState(() {
                  _locating = false;
                });
                locationData.getMoveCamera();
              },
            ),
            Center(
              child: Container(
                height: 50,
                margin: EdgeInsets.only(bottom: 40),
                child: Image.asset('assets/loca.png'),
              ),
            ),
            Center(
              child: SpinKitPulse(
                color: Colors.black54,
                size: 100.0,
              ),
            ),
            Positioned(
                bottom: 0.0,
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _locating
                          ? LinearProgressIndicator(
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 20),
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.location_searching,
                            color: Theme.of(context).primaryColor,
                          ),
                          label: Flexible(
                            child: Text(
                                _locating
                                    ? 'ກຳລັງໂຫຼດ...'
                                    : locationData.selectedAddress.featureName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          _locating
                              ? ''
                              : locationData.selectedAddress.addressLine,
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: AbsorbPointer(
                            absorbing: _locating ? true : false,
                            child: FlatButton(
                                onPressed: () {
                                  // save address in shared preferences
                                  locationData.savePrefs();

                                  if (_loggedIn == false) {
                                    Navigator.pushReplacementNamed(
                                        context, LoginScreen.id);
                                  } else {
                                    setState(() {
                                      _auth.latitude = locationData.latitude;
                                      _auth.longitude = locationData.longitude;
                                      _auth.address = locationData
                                          .selectedAddress.addressLine;
                                    });
                                    _auth
                                        .updateUser(
                                      id: user.uid,
                                      number: user.phoneNumber,
                                    )
                                        .then((value) {
                                      if (value == true) {
                                        Navigator.pushReplacementNamed(
                                            context, Home.id);
                                      }
                                    });
                                  }
                                },
                                color: _locating
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor,
                                child: Text(
                                  'ຢືນຢັນທີ່ຕັ້ງ',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    ));
  }
}
