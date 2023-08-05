// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:ownstyle/services/Auth_Service.dart';
import 'package:ownstyle/pages/landing_page.dart';

import 'services/NotificationService.dart';

GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

Future<void> checkForUpdate() async {
  try {
    AppUpdateInfo info = await InAppUpdate.checkForUpdate();
    if (info.updateAvailability == UpdateAvailability.updateAvailable) {
      try {
        await InAppUpdate.performImmediateUpdate();
      } on Exception catch (e) {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
            .showSnackBar(SnackBar(content: Text("$e")));
      }
    }
  } on Exception catch (e) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!)
        .showSnackBar(SnackBar(content: Text("$e")));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //checkForUpdate();
  await Firebase.initializeApp();
  await AuthService().checkUser();
  await NotificationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OwnStyle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LandingPage(),
    );
  }
}
