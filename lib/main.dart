import 'package:flutter/material.dart';
import 'package:ownstyle/sign_in_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
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
      home: signInPage(),
    );
  }
}
