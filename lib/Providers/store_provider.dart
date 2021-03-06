import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:order/Screens/welcom_screen.dart';
import 'package:order/Services/store_services.dart';
import 'package:order/Services/user_services.dart';

class StoreProvider with ChangeNotifier {
  StoreServices _storeServices = StoreServices();
  UserServices _userServices = UserServices();
  User user = FirebaseAuth.instance.currentUser;
  var userLatitude = 0.0;
  var userLongitude = 0.0;
  String selectedStore;
  String selectedStoreId;

  getSelectedStore(storeName, storeId) {
    this.selectedStore = storeName;
    this.selectedStoreId = storeId;
    notifyListeners();
  }

  Future<void> getUserLocationData(context) async {
    _userServices.getUserById(user.uid).then((result) {
      if (user != null) {
        this.userLatitude = result.data()['latitude'];
        this.userLongitude = result.data()['longitude'];
        notifyListeners();
      } else {
        Navigator.pushReplacementNamed(context, WelcomScreen.id);
      }
    });
  }
}
