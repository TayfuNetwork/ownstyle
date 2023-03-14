import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ownstyle/esnafAnaSayfa.dart';
import 'package:ownstyle/sign_in_page.dart';

import 'Auth_Service.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    AuthService().checkUser();
    if (FirebaseAuth.instance.currentUser == null) {
      return const signInPage();
    } else {
      if (AuthService().isHaveProfile) {
        return MainScreen();
      } else {
        return const signInPage();
      }
    }
  }
}