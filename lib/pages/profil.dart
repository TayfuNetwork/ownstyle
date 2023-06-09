// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ownstyle/esnafAnaSayfa.dart';
import 'package:ownstyle/services/servisler.dart';
import 'package:ownstyle/models/user_model.dart';

import '../services/Auth_Service.dart';

// ignore: camel_case_types

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  String meslek;
  Profile({
    Key? key,
    required this.meslek,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfileState createState() => _ProfileState();
}

String? ad;
String? okundu = "hayir";

class _ProfileState extends State<Profile> {
  MeslekServices model1 = MeslekServices();
  String? isim;
  Meslek? meslek;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 80,
          elevation: 0,
          backgroundColor: Colors.black12,
          title: Center(child: Text('Profil'.tr())),
        ),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 220, 222, 238),
                Color.fromARGB(255, 76, 65, 147)
              ], end: Alignment.topRight, begin: Alignment.bottomRight),
              color: Color.fromARGB(255, 163, 215, 231)),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 10),
                  Text('Bilgilerinizi Giriniz'.tr(),
                      style: const TextStyle(color: Colors.yellow)),

                  /*************/ const SizedBox(height: 10),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    maxLength: 20,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 1)),
                      focusColor: Colors.blue,
                      hintText: 'Isim',
                      enabled: true,
                    ),
                    autofocus: false,
                    onChanged: (girilenisim) {
                      isim = girilenisim;
                    },
                  ),
                  const SizedBox(height: 30),
                  widget.meslek != "esnaf"
                      ? const SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              "Meslek:",
                              style: TextStyle(color: Colors.white),
                            ),
                            DropdownButton<int>(
                              iconEnabledColor: Colors.blue,
                              dropdownColor:
                                  const Color.fromARGB(255, 28, 185, 242),
                              style: const TextStyle(color: Colors.black),
                              value: meslek?.x ?? 1,
                              items: model1.meslekler.map((a) {
                                return DropdownMenuItem(
                                  // ignore: sort_child_properties_last
                                  child: Text(a.meslek,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  value: a.x,
                                  onTap: () {
                                    setState(() {
                                      meslek = a;
                                    });
                                  },
                                );
                              }).toList(),
                              onChanged: (s) {},
                            ),
                          ],
                        ),
                  /*************/ Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (isim != null || meslek != null)
                        ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (builder) => Stack(
                                        children: [
                                          AlertDialog(
                                            content: const Card(
                                              child: Text(
                                                  "Uygulama çalışırken sizden arama geçmişinizi görmek ve varsayılan sms gönderme uygulamanıza yönlendirmek için izin isteyecektir. Bu izinler vasıtasıylsa sadece arama geçmişinizi size gösterebilir. Uygulama içi arama yapamaz, kişi ekleyemez, silemez ve uygulama içerisinden sms gönderimi yapamaz. Devam ederek bu izinlerin sizden istenmesini sağlayacaksınız. Reddetmeniz durumunda uygulama düzgün çalışmaz."),
                                            ),
                                            actions: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Icon(Icons.cut),
                                                  TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          okundu = "evet";
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child:
                                                          const Text("Devam")),
                                                  const Icon(Icons.cut)
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ));
                            },
                            child: const Text("Devam")),
                      if (meslek != null && okundu == "evet")
                        ElevatedButton(
                          // ignore: prefer_const_constructors

                          onPressed: () async {
                            if (isim!.isNotEmpty &&
                                meslek != null &&
                                okundu == "evet") {
                              setState(() {
                                ad = isim!;

                                meslek = (meslek)!;
                              });
                              User user = FirebaseAuth.instance.currentUser!;

                              await user.updateDisplayName(
                                ad!,
                              );

                              MyUser myUser = MyUser(
                                  saatler: [],
                                  abone: false,
                                  isim: ad ?? "isimsiz",
                                  id: user.uid,
                                  meslek: (meslek)!.meslek,
                                  numaralar: [],
                                  dateDate: "");

                              AuthService().user = MyUser();
                              final fcmToken =
                                  await FirebaseMessaging.instance.getToken();
                              FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(user.uid)
                                  .set({'token': fcmToken},
                                      SetOptions(merge: true));

                              AuthService().user!.token = fcmToken;
                              await AuthService().updateUser(myUser);

                              myUser = MyUser(
                                  saatler: [],
                                  abone: false,
                                  mail: user.email,
                                  musteri: false,
                                  isim: ad ?? "isimsiz",
                                  id: user.uid,
                                  meslek: (meslek)!.meslek,
                                  token: fcmToken,
                                  dateDate: "",
                                  numaralar: []);
                              await AuthService().updateUser(myUser);
                              if (AuthService().user!.musteri == false)
                                // ignore: curly_braces_in_flow_control_structures, use_build_context_synchronously
                                await Navigator.of(context).push(
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            const MainScreen()));
                              Navigator.of(context).pop();
                            } else {
                              Fluttertoast.showToast(
                                msg: "Bilgiler Hatalı".tr(),
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_LONG,
                              );
                            }
                          },
                          child: Text('Kaydet ve Devam Et'.tr(),
                              style: const TextStyle(color: Colors.white)),
                        )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
