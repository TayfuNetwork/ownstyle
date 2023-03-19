import 'package:call_log/call_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ownstyle/Auth_Service.dart';
import 'package:ownstyle/search_service.dart';
import 'package:ownstyle/sign_in_page.dart';
import 'package:ownstyle/user_model.dart';
import 'package:phone_state/phone_state.dart';
import 'package:flutter_sms/flutter_sms.dart';

import 'NotificationService.dart';
import 'main.dart';

class MainScreen extends StatefulWidget {
  MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

void randevuZamanla(String mesaj, String numara, int zaman, String name) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final scheduledNotificationDateTime =
      DateTime.now().add(Duration(minutes: zaman));
  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id', 'Scheduled Notification',
      importance: Importance.max, priority: Priority.high);
  const platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.schedule(
      payload: "$mesaj,$numara",
      0,
      'Sıradaki Randevu',
      "$name'a randevusunu hatırlatın !",
      scheduledNotificationDateTime,
      platformChannelSpecifics);
}

int _selectedIndex = 0;

class _MainScreenState extends State<MainScreen> {
  PhoneStateStatus status = PhoneStateStatus.NOTHING;
  bool granted = false;
  String? manuelNo;
  String? manuelIsim;
  Iterable<CallLogEntry> _callLogEntries = [];

  @override
  void initState() {
    AuthService().checkUser;
    _getCallLog();
    setStream();
  }

  void setStream() {
    PhoneState.phoneStateStream.listen((event) {
      switch (event) {
        case PhoneStateStatus.CALL_ENDED:
        case PhoneStateStatus.NOTHING:
          setState(() {
            Future.delayed(Duration(seconds: 3), _getCallLog);
          });
          break;
        case PhoneStateStatus.CALL_INCOMING:
          break;
        case PhoneStateStatus.CALL_STARTED:
          break;
      }
    });
  }

  void _getCallLog() async {
    var callLog = await CallLog.query();
    Map<String, CallLogEntry> map = Map.fromEntries(
      await callLog.map((p) => MapEntry(p.name ?? p.number!, p)),
    );

    List<CallLogEntry> uniquCallLogs = await map.values.toList();
    setState(() {
      _callLogEntries = uniquCallLogs;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        saat = ('${pickedTime.hour}:${pickedTime.minute}');
      });
    }
  }

  TimeOfDay randevusonuTimeOfDayTurunden() {
    List<String> parts = saat.split(":");
    TimeOfDay timeOfDay =
        TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    return timeOfDay;
  }

  /*   sendSMS(String message, String recipents) async {
    bool _result = await launchSms(message: message, number: recipents);
  } */

  String saat = "00:00";
  String yapilacak = "";
  @override
  Widget build(BuildContext context) {
    String? isim = AuthService().user!.isim;
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.blue,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Tüm Randevular',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton.large(
          backgroundColor: const Color.fromARGB(255, 106, 81, 203),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Center(
                      child: Text(
                        "Randevu Oluştur",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    actions: <Widget>[
                      Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                "No : ",
                                style: TextStyle(color: Colors.blue),
                              ),
                              SizedBox(
                                width: 200,
                                child: TextField(
                                  maxLines: 1,
                                  onChanged: (a) {
                                    setState(() {
                                      manuelNo = a;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "isim : ",
                                style: TextStyle(color: Colors.blue),
                              ),
                              SizedBox(
                                width: 200,
                                child: TextField(
                                  maxLines: 1,
                                  onChanged: (a) {
                                    setState(() {
                                      manuelIsim = a;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text("Saat : ",
                                  style: TextStyle(color: Colors.blue)),
                              IconButton(
                                  icon: const Icon(Icons.access_time),
                                  onPressed: () {
                                    _selectTime(context);
                                  }),
                            ],
                          ),
                          Row(
                            children: [
                              const Text("Yapılacaklar : ",
                                  style: TextStyle(color: Colors.blue)),
                              SizedBox(
                                width: 200,
                                child: TextField(
                                  maxLines: 1,
                                  onChanged: (a) {
                                    setState(() {
                                      yapilacak = a;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.cut),
                              TextButton(
                                child: const Text("Kaydet"),
                                onPressed: () async {
                                  AuthService().user?.numaralar!.add(manuelNo!);

                                  AuthService().updateUser(AuthService().user!);

                                  await FirebaseFirestore.instance
                                      .collection("Randevular")
                                      .doc((AuthService().user!.id))
                                      .collection("kim")
                                      .doc(manuelNo.toString())
                                      .set({
                                    "no": manuelNo.toString(),
                                    "dateDate": saat,
                                    "dateYapilacak": yapilacak,
                                    "dateName": manuelIsim ?? null
                                  });
                                  TimeOfDay currentTime =
                                      randevusonuTimeOfDayTurunden();
                                  int addedMinutes =
                                      20; // Eklenecek dakika sayısı

                                  int newMinutes = currentTime.minute +
                                      addedMinutes; // Dakikaya 20 ekleyin
                                  int newHours = currentTime.hour +
                                      (newMinutes ~/
                                          60); // Saatleri güncelleyin
                                  newMinutes =
                                      newMinutes % 60; // Dakikaları güncelleyin

                                  TimeOfDay newTime = TimeOfDay(
                                      hour: newHours, minute: newMinutes);
                                  String timeString = newTime.format(context);

                                  await FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc((AuthService().user!.id))
                                      .update({
                                    "dateDate": timeString.toString(),
                                  });
                                  randevuZamanla(
                                      "Sevgili $manuelIsim; ${AuthService().user!.isim} de ki randevunuza son 20 dakikanız kaldığını hatırlatmak isteriz. Bizi tercih ettiğiniz için teşekkür eder memnuniyet dileriz.",
                                      "$manuelNo",
                                      1,
                                      "$manuelIsim");

                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);

                                  /************************************************/
                                },
                              ),
                              const Icon(
                                Icons.cut,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  );
                });
          },
          foregroundColor: Colors.white,
          //splashColor: Colors.purple,
          child: const Icon(Icons.cut)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        actions: <Widget>[
          TextButton(
            onPressed: _cikisYap,
            child: const Text(
              'Cikis Yap',
              style: TextStyle(color: (Colors.red)),
            ),
          )
        ],
        toolbarHeight: 70,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        title: Center(
          child: Text(
            isim!,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
        ),
      ),
      body: _selectedIndex == 0
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Text("Son Aramalar"),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _callLogEntries.length,
                      itemBuilder: (context, index) {
                        var callLogEntry = _callLogEntries.elementAt(index);
                        Text dateControl() {
                          var a = callLogEntry.number.toString();
                          List<String>? b = AuthService().user?.numaralar ?? [];
                          if (b.contains(a)) {
                            return const Text("Randevulu",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 16));
                          } else {
                            return const Text("Randevusuz",
                                style: TextStyle(
                                    color: Colors.pink, fontSize: 16));
                          }
                        }

                        iconControl() {
                          var a = callLogEntry.number.toString();
                          List<String>? b = AuthService().user?.numaralar ?? [];
                          if (b.contains(a)) {
                            return const Icon(
                              Icons.cut,
                              color: Colors.green,
                            );
                          } else {
                            return const Icon(
                              Icons.add_alarm_sharp,
                              size: 35,
                              color: Colors.red,
                            );
                          }
                        }

                        return ListTile(
                          leading: const Icon(Icons.phone),
                          title: Text(callLogEntry.name!.isEmpty
                              ? callLogEntry.number!
                              : callLogEntry.name!),
                          trailing: IconButton(
                              onPressed: () {
                                var a = callLogEntry.number.toString();
                                List<String>? b =
                                    AuthService().user?.numaralar ?? [];
                                !b.contains(a)
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Center(
                                              child: Text(
                                                "Randevu Oluştur",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                            actions: <Widget>[
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Kişi : ",
                                                        style: TextStyle(
                                                            color: Colors.blue),
                                                      ),
                                                      Text(
                                                          callLogEntry.number!),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text("Saat : ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue)),
                                                      IconButton(
                                                          icon: const Icon(Icons
                                                              .access_time),
                                                          onPressed: () {
                                                            _selectTime(
                                                                context);
                                                          }),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                          "Yapılacaklar : ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue)),
                                                      SizedBox(
                                                        width: 200,
                                                        child: TextField(
                                                          maxLines: 1,
                                                          onChanged: (a) {
                                                            setState(() {
                                                              yapilacak = a;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Icon(Icons.cut),
                                                      TextButton(
                                                        child: const Text(
                                                            "Kaydet"),
                                                        onPressed: () async {
                                                          AuthService()
                                                              .user
                                                              ?.numaralar!
                                                              .add(callLogEntry
                                                                  .number!);

                                                          AuthService()
                                                              .updateUser(
                                                                  AuthService()
                                                                      .user!);

                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "Randevular")
                                                              .doc(
                                                                  (AuthService()
                                                                      .user!
                                                                      .id))
                                                              .collection("kim")
                                                              .doc(callLogEntry
                                                                  .number
                                                                  .toString())
                                                              .set({
                                                            "no": callLogEntry
                                                                .number
                                                                .toString(),
                                                            "dateDate": saat,
                                                            "dateYapilacak":
                                                                yapilacak,
                                                            "dateName":
                                                                callLogEntry
                                                                        .name ??
                                                                    null
                                                          });
                                                          TimeOfDay
                                                              currentTime =
                                                              randevusonuTimeOfDayTurunden();
                                                          int addedMinutes =
                                                              20; // Eklenecek dakika sayısı

                                                          int newMinutes =
                                                              currentTime
                                                                      .minute +
                                                                  addedMinutes; // Dakikaya 20 ekleyin
                                                          int newHours =
                                                              currentTime.hour +
                                                                  (newMinutes ~/
                                                                      60); // Saatleri güncelleyin
                                                          newMinutes = newMinutes %
                                                              60; // Dakikaları güncelleyin

                                                          TimeOfDay newTime =
                                                              TimeOfDay(
                                                                  hour:
                                                                      newHours,
                                                                  minute:
                                                                      newMinutes);
                                                          String timeString =
                                                              newTime.format(
                                                                  context);

                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "Users")
                                                              .doc(
                                                                  (AuthService()
                                                                      .user!
                                                                      .id))
                                                              .update({
                                                            "dateDate":
                                                                timeString
                                                                    .toString(),
                                                          });
                                                          /*       AuthService().updateUser(
                                                          AuthService().user!); */
                                                          // ignore: use_build_context_synchronously
                                                          Navigator.pop(
                                                              context);

                                                          /************************************************/
                                                        },
                                                      ),
                                                      const Icon(
                                                        Icons.cut,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          );
                                        })
                                    : null;
                              },
                              icon: iconControl()),
                          subtitle: dateControl(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: SearchService2().searchStream1(),
                builder: (c, snap) {
                  if (snap.hasData) {
                    List<MyUser> users = snap.data!.docs
                        .map((e) => MyUser.fromMap(e.data()))
                        .toList();

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            children: users.map((e) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: ListTile(
                                  title: SingleChildScrollView(
                                    child: Row(
                                      children: [
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(e.dateName!.isEmpty
                                              ? e.no!
                                              : e.dateName!),
                                        ),
                                      ],
                                    ),
                                  ),
                                  leading: CircleAvatar(child: Icon(Icons.cut)),
                                  subtitle: SingleChildScrollView(
                                    child: Text(
                                      "${e.dateYapilacak}",
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  trailing: Text(
                                    e.dateDate.toString(),
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.red),
                                  ),
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Center(
                                              child: Text(
                                                "Randevu Düzenle",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                            actions: <Widget>[
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Kişi : ",
                                                        style: TextStyle(
                                                            color: Colors.blue),
                                                      ),
                                                      Text(e.dateName!.isEmpty
                                                          ? e.no!
                                                          : e.dateName!),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text("Saat : ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue)),
                                                      IconButton(
                                                          icon: const Icon(Icons
                                                              .access_time),
                                                          onPressed: () {
                                                            _selectTime(
                                                                context);
                                                          }),
                                                      Text(" ${(e.dateDate)}",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .grey))
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                          "Yapılacaklar : ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue)),
                                                      SizedBox(
                                                        width: 200,
                                                        child: TextField(
                                                          maxLines: 1,
                                                          onChanged: (a) {
                                                            setState(() {
                                                              yapilacak = a;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Icon(Icons.cut),
                                                      TextButton(
                                                          onPressed: () {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "Randevular")
                                                                .doc(
                                                                    "${AuthService().user!.id}")
                                                                .collection(
                                                                    "kim")
                                                                .doc(e.no)
                                                                .delete();
                                                            AuthService()
                                                                .user!
                                                                .numaralar!
                                                                .removeWhere(
                                                                    (element) =>
                                                                        element ==
                                                                        e.no);

                                                            AuthService()
                                                                .updateUser(
                                                                    AuthService()
                                                                        .user!);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              "Sil")),
                                                      TextButton(
                                                        child: const Text(
                                                            "Kaydet"),
                                                        onPressed: () async {
                                                          TimeOfDay
                                                              currentTime =
                                                              randevusonuTimeOfDayTurunden();
                                                          int addedMinutes =
                                                              20; // Eklenecek dakika sayısı

                                                          int newMinutes =
                                                              currentTime
                                                                      .minute +
                                                                  addedMinutes; // Dakikaya 20 ekleyin
                                                          int newHours =
                                                              currentTime.hour +
                                                                  (newMinutes ~/
                                                                      60); // Saatleri güncelleyin
                                                          newMinutes = newMinutes %
                                                              60; // Dakikaları güncelleyin

                                                          TimeOfDay newTime =
                                                              TimeOfDay(
                                                                  hour:
                                                                      newHours,
                                                                  minute:
                                                                      newMinutes);
                                                          String timeString =
                                                              newTime.format(
                                                                  context);

                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "Users")
                                                              .doc(
                                                                  (AuthService()
                                                                      .user!
                                                                      .id))
                                                              .update({
                                                            "dateDate":
                                                                timeString
                                                                    .toString(),
                                                          });
                                                          /************************************************/

                                                          Navigator.pop(
                                                              context);
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "Randevular")
                                                              .doc(
                                                                  (AuthService()
                                                                      .user!
                                                                      .id))
                                                              .collection("kim")
                                                              .doc(e.no!
                                                                  .toString())
                                                              .set({
                                                            "dateDate":
                                                                saat.toString(),
                                                            "dateYapilacak":
                                                                yapilacak,
                                                            "dateName":
                                                                e.dateName ??
                                                                    null,
                                                            "no":
                                                                e.no.toString()
                                                          });

                                                          /************************************************/
                                                        },
                                                      ),
                                                      const Icon(
                                                        Icons.cut,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text("Randevu Yok"),
                    );
                  }
                },
              ),
            ),
    ));
  }

  Column customerControl() {
    return Column(
      children: [
        Row(
          children: const [
            Text("Şu an ki müşteriniz ", style: TextStyle(color: Colors.white)),
            Text("Tayfun Kaya", style: TextStyle(color: Colors.red))
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text("Yapılacaklar ",
                  style: TextStyle(color: Colors.white)),
              // ignore: unnecessary_string_interpolations
              Text("$yapilacak", style: const TextStyle(color: Colors.red))
            ],
          ),
        ),
      ],
    );
  }

  Text dateControl() {
    if (1 == 1) {
      return const Text("Randevusuz",
          style: TextStyle(color: Colors.pink, fontSize: 16));
    } else {
      return const Text("Randevusuz",
          style: TextStyle(color: Colors.pink, fontSize: 16));
    }
  }

  Future _cikisYap() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await GoogleSignIn().disconnect();
    await Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => const signInPage()),
        (route) => false);
  }
}
