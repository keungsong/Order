import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order/Models/user.dart';

class UserServices {
  String collection = 'Users';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // create new user
  Future<void> createUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await _firebaseFirestore.collection(collection).doc(id).setData(values);
  }
  // update user

  Future<void> updateUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await _firebaseFirestore.collection(collection).doc(id).update(values);
  }

  Future<DocumentSnapshot> getUserById(String id) async {
    var result = await _firebaseFirestore.collection(collection).doc(id).get();
    return result;
  }
}
