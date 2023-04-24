import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ownstyle/esnafGirisi.dart';
import 'package:ownstyle/musteriGirisi.dart';
import 'package:ownstyle/profil.dart';

import 'Auth_Service.dart';
import 'esnafAnaSayfa.dart';

class signInPage extends StatefulWidget {
  const signInPage({super.key});

  @override
  State<signInPage> createState() => _signInPageState();
}

class _signInPageState extends State<signInPage> {
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
                "Hosgeldiniz",
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 30),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /* TextButton(
                      onPressed: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => const musteriGirisi()));
                      },
                      child: const Text(
                        "Müşteri",
                        style: TextStyle(color: Colors.black),
                      )), */
                  const SizedBox(
                    width: 20,
                  ),
                  TextButton(
                      onPressed: () async {
                        if (AuthService().isHaveProfile) {
                          _googleGirisi();
                        } else {
                          Navigator.of(context).pushAndRemoveUntil(
                              CupertinoPageRoute(
                                  builder: (context) => MainScreen()),
                              (route) => false);
                        }
                      },
                      child: const Text("Esnaf Girisi",
                          style: TextStyle(color: Colors.black)))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _googleGirisi() async {
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
          String a = "esnaf";
          await AuthService().checkUser();
          AuthService().isHaveProfile
              ? Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute(builder: (context) => MainScreen()),
                  ((route) => false))
              : Navigator.of(context).pushAndRemoveUntil(
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
