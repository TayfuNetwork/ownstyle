import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ownstyle/Auth_Service.dart';

class SearchService {
  bool isHaveProfile = false;

  static SearchService? _instance;

  factory SearchService() {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = SearchService._();
      return _instance!;
    }
  }

  SearchService._();

  CollectionReference<Map<String, dynamic>> get userCollection =>
      FirebaseFirestore.instance.collection("Users");
}

class SearchService2 {
  bool isHaveProfile = false;

  static SearchService2? _instance;

  factory SearchService2() {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = SearchService2._();
      return _instance!;
    }
  }

  SearchService2._();
  String? userID = AuthService().user!.id;
  CollectionReference<Map<String, dynamic>> get userCollection =>
      FirebaseFirestore.instance
          .collection("Randevular")
          .doc(userID)
          .collection("kim");

  Stream<QuerySnapshot<Map<String, dynamic>>> searchStream1() {
    return userCollection.orderBy("dateDate", descending: true).snapshots();
  }
}
