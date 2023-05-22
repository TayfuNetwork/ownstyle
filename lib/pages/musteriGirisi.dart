import 'package:flutter/material.dart';

class musteriGirisi extends StatefulWidget {
  const musteriGirisi({super.key});

  @override
  State<musteriGirisi> createState() => _musteriGirisiState();
}

class _musteriGirisiState extends State<musteriGirisi> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Row(
          children: [
            TextButton(onPressed: (){}, child: Text("Giriş")),
            TextButton(onPressed: (){}, child: Text("Üye ol"))
          ],
        )
      ],),
    );
  }
}