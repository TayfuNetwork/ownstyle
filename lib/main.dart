import 'package:flutter/material.dart';
import 'package:ownstyle/sign_in_page.dart';

void main() {
  runApp( MyApp());
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
      home:  signInPage(),
    );
  }
}
