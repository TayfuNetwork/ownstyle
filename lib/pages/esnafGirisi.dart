// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:ownstyle/esnafAnaSayfa.dart';
import 'package:ownstyle/pages/profil.dart';

import '../services/Auth_Service.dart';

// ignore: camel_case_types
class esnafGirisi extends StatefulWidget {
  String meslek;
  esnafGirisi({
    Key? key,
    required this.meslek,
  }) : super(key: key);

  @override
  State<esnafGirisi> createState() => _esnafGirisiState();
}

class Final {}

// ignore: unused_element
bool _isloading = false;

// ignore: camel_case_types
class _esnafGirisiState extends State<esnafGirisi> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 220, 222, 238),
              Color.fromARGB(255, 76, 65, 147)
            ], end: Alignment.topRight, begin: Alignment.bottomRight),
            color: Color.fromARGB(255, 163, 215, 231),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Üye misiniz",
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 30),
              ),
              TextButton(
                  onPressed: () async {
                    await AuthService().checkUser();
                    if (!AuthService().isHaveProfile) {
                      _googleGirisi();
                    } else {
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) =>  MainScreen()));
                    }
                  },
                  child: const Text("Giriş yap / Üye ol",
                      style: TextStyle(color: Colors.black)))
            ],
          ),
        ),
      ),
    );
  }

  _googleGirisi() async {
    // ignore: no_leading_underscores_for_local_identifiers
    GoogleSignIn _googleSignIn = GoogleSignIn();
    // ignore: no_leading_underscores_for_local_identifiers
    GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();
    if (_googleUser != null) {
      // ignore: no_leading_underscores_for_local_identifiers
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      try {
        if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
          UserCredential sonuc = await FirebaseAuth.instance
              .signInWithCredential(GoogleAuthProvider.credential(
                  idToken: _googleAuth.idToken,
                  accessToken: _googleAuth.accessToken));
          // ignore: unused_local_variable, await_only_futures, no_leading_underscores_for_local_identifiers
          User? _user = await sonuc.user;
          String a = "esnaf";
          await AuthService().checkUser();
          // ignore: use_build_context_synchronously
          return Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                  builder: (context) => Profile(
                        meslek: a,
                      )),
              ((route) => false));
        }
      } on PlatformException catch (e) {
        Fluttertoast.showToast(
          msg: e.message.toString(),
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Transaction could not be completed",
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }
}
