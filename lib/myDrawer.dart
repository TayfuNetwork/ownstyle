// ignore: file_names
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ownstyle/pages/sign_in_page.dart';
import 'package:ownstyle/services/Auth_Service.dart';
import 'package:ownstyle/models/user_model.dart';

//import 'package:in_app_update/in_app_update.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  MyUser user = AuthService().user!;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        shadowColor: Colors.black,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: <Color>[Colors.blue, Colors.blueAccent]),
                ),
                accountName: Text(user.isim!,
                    style: const TextStyle(
                        fontSize: 20, fontStyle: FontStyle.italic)),
                accountEmail: Text(user.mail!),
                currentAccountPicture: CircleAvatar(
                  radius: 95,
                  backgroundColor: Colors.white,
                )),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                      leading: const Icon(Icons.no_accounts),
                      title: Text(
                        "CikisYap".tr(),
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                title: Center(
                                  child: Text(
                                    "UygulamadanCikiliyor".tr(),
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                actions: <Widget>[
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                          onPressed: () async {
                                            _cikisYap();
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "CikisYap".tr(),
                                            style:
                                                TextStyle(color: Colors.blue),
                                          )),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Vazgeç".tr(),
                                            style:
                                                TextStyle(color: Colors.blue)),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            });
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                  AboutListTile(
                    applicationName: "Lisans".tr(),
                    applicationIcon: Icon(Icons.file_open),
                    applicationVersion: "3.8",
                    child: Text("UygulamaHakkinda".tr(),
                        style: TextStyle(fontSize: 12)),
                    icon: Icon(Icons.info),
                    applicationLegalese: null,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _cikisYap() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().disconnect();
    await GoogleSignIn().signOut();
    // ignore: use_build_context_synchronously
    await Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => const signInPage()),
        (route) => false);
  }
}
