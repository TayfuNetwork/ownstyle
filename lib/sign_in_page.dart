import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ownstyle/esnafGirisi.dart';
import 'package:ownstyle/musteriGirisi.dart';

class signInPage extends StatefulWidget {
  const signInPage({super.key});

  @override
  State<signInPage> createState() => _signInPageState();
}

class _signInPageState extends State<signInPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => const musteriGirisi()));
                    },
                    child: const Text("Müşteri")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => const esnafGirisi()));
                    },
                    child: const Text("Esnaf"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
