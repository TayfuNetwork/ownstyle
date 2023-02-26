import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ownstyle/MainScreen.dart';

import 'Auth_Service.dart';

class esnafGirisi extends StatefulWidget {
  const esnafGirisi({super.key});

  @override
  State<esnafGirisi> createState() => _esnafGirisiState();
}

bool _isloading = false;

class _esnafGirisiState extends State<esnafGirisi> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                TextButton(onPressed: () {}, child: const Text("Giriş")),
                TextButton(
                    onPressed: () {
                      _googleGirisi();
                    },
                    child: Text("Üye ol"))
              ],
            )
          ],
        ),
      ),
    );
  }

  _googleGirisi() async {
    setState(() {
      _isloading = true;
    });
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();
    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      try {
        if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
          UserCredential sonuc = await FirebaseAuth.instance
              .signInWithCredential(GoogleAuthProvider.credential(
                  idToken: _googleAuth.idToken,
                  accessToken: _googleAuth.accessToken));
          // ignore: unused_local_variable
          User? _user = await sonuc.user;
          try {
            await AuthService().checkUser();
            setState(() {
              _isloading = false;
            });
            return Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(builder: (context) => MainScreen()),
                ((route) => false));
          } on Exception {
            setState(() {
              _isloading = true;
            });
            Fluttertoast.showToast(
              msg: "googlegiremedi",
              gravity: ToastGravity.BOTTOM,
              toastLength: Toast.LENGTH_LONG,
            );
            return Container(); //
          }
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
