// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ownstyle/models/user_model.dart';


class AuthService {
  MyUser? user;

  bool isHaveProfile = false;

  static AuthService? _instance;

  factory AuthService() {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = AuthService._();
      return _instance!;
    }
  }

  AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get userCollection =>
      FirebaseFirestore.instance.collection("Users");


  Future checkUser() async {
    if (_auth.currentUser != null) {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await userCollection.doc(_auth.currentUser!.uid).get();
      if (doc.data() != null) {
        try {
          MyUser user = MyUser.fromMap(doc.data()!);
          this.user = user;
          if (user.isim != null) {
            return isHaveProfile = true;
          }
          return;
        } on Exception catch (_) {}
      }
    }
    isHaveProfile = false;
  }

  Future<bool> updateUser(MyUser user) async {
    try {
      await userCollection
          .doc(user.id)
          .set(user.toMap(), SetOptions(merge: true));
      this.user = user;
      return true;
    } on Exception catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }
  }


  Future<bool> updateUserName(String userID, String yeniUserName) async {
    // ignore: prefer_is_empty
    if (yeniUserName.length < 0) {
      // ignore: no_leading_underscores_for_local_identifiers
      var _users = await FirebaseFirestore.instance
          .collection("Users")
          .where("isim", isEqualTo: yeniUserName)
          .get();
      if (_users.docs.isNotEmpty) {
        return false;
      } else {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userID)
            .update({"isim": yeniUserName});
        return true;
      }
    } else {
      Fluttertoast.showToast(
        msg: "ButunAlanlariEksiksiDoldur".tr(),
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }
  }
}