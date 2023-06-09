// ignore_for_file: file_names

import 'dart:async';
import 'package:call_log/call_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ownstyle/myDrawer.dart';
import 'package:ownstyle/services/Auth_Service.dart';
import 'package:ownstyle/services/NotificationService.dart';
import 'package:ownstyle/services/search_service.dart';
import 'package:ownstyle/models/user_model.dart';
import 'package:phone_state/phone_state.dart';
import 'package:flutter_sms/flutter_sms.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
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

  // ignore: deprecated_member_use
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
    super.initState();
    setState(() {
      AuthService().checkUser;
    });
    _getCallLog();
    setStream();
  }

  void setStream() {
    PhoneState.phoneStateStream.listen((event) {
      switch (event) {
        case PhoneStateStatus.CALL_ENDED:
        case PhoneStateStatus.NOTHING:
          setState(() {
            Future.delayed(const Duration(seconds: 3), _getCallLog);
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
      callLog.map((p) => MapEntry(p.name ?? p.number!, p)),
    );

    List<CallLogEntry> uniquCallLogs = map.values.toList();
    setState(() {
      _callLogEntries = uniquCallLogs;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  DateTime? randevuTarihi;
  _selectDate(a) {
    if (a == "Bugün") {
      return randevuTarihi = DateTime.now();
    } else if (a == "Yarin") {
      return randevuTarihi = DateTime.now().add(const Duration(days: 1));
    } else if (a == "2 gün sonra") {
      return randevuTarihi = DateTime.now().add(const Duration(days: 2));
    } else if (a == "3 gün sonra") {
      return randevuTarihi = DateTime.now().add(const Duration(days: 3));
    } else if (a == "3 gün sonra") {
      return randevuTarihi = DateTime.now().add(const Duration(days: 4));
    } else if (a == "3 gün sonra") {
      return randevuTarihi = DateTime.now().add(const Duration(days: 5));
    }
  }

  // ignore: prefer_typing_uninitialized_variables
  var a = 08;
  // ignore: prefer_typing_uninitialized_variables
  var b = 00;
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: randevusonuTimeOfDayTurunden(),
    );
    if (pickedTime != null) {
      setState(() {
        saat = ('${pickedTime.hour}:${pickedTime.minute}');
        a = pickedTime.hour;
        b = pickedTime.minute;
      });
    }
  }

  TimeOfDay randevusonuTimeOfDayTurunden() {
    List<String> parts = musait.split(":");
    TimeOfDay timeOfDay =
        TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    return timeOfDay;
  }

  TimeOfDay todcevir(y) {
    List<String> parts = y.split(":");
    TimeOfDay timeOfDay =
        TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    return timeOfDay;
  }

  /*   sendSMS(String message, String recipents) async {
    bool _result = await launchSms(message: message, number: recipents);
  } */
  int? secilecekDegisken;
  String? secilenRandevuTarihi;
  String? degisken = "Bugün";
  String musait = AuthService().user?.dateId ?? "08:00";
  List<String> menuItems = [
    "Bugün",
    "Yarin",
    "2 gün sonra",
    "3 gün sonra",
    "4 gün sonra",
    "5 gün sonra"
  ];
  List<int> sureItems = [
    20,
    40,
    60,
    90,
    120,
  ];

  deleteManuelDataAtSpecificTime(t) {
    DateTime now = DateTime.now();
    DateTime targetTime = DateTime(now.year, now.month, now.day, a, b);

    Duration difference = targetTime.difference(now);

    Timer(difference, () => deleteManuelDate(t));
  }

  deleteManuelDate(e) {
    FirebaseFirestore.instance
        .collection("Randevular")
        .doc("${AuthService().user!.id}")
        .collection("kim")
        .doc(e)
        .delete();
    AuthService().user!.numaralar!.removeWhere((element) => element == e);
    AuthService().user!.saatler!.removeWhere((element) => element == saat);
    AuthService().updateUser(AuthService().user!);
  }

  deleteDate(e) {
    FirebaseFirestore.instance
        .collection("Randevular")
        .doc("${AuthService().user!.id}")
        .collection("kim")
        .doc(e.no)
        .delete();
    AuthService().user!.numaralar!.removeWhere((element) => element == e.no);
    AuthService().user!.saatler!.removeWhere((element) => element == saat);
    setState(() {
      musait = saat;
    });
    AuthService().updateUser(AuthService().user!);
    Navigator.pop(context);
  }

  int? degiskenZaman = 20;
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
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton.large(
          backgroundColor: const Color.fromARGB(255, 106, 81, 203),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (context, setState) {
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
                                    keyboardType: TextInputType.phone,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Saat : ",
                                    style: TextStyle(color: Colors.blue)),
                                IconButton(
                                    icon: const Icon(Icons.access_time),
                                    onPressed: () {
                                      _selectTime(context);
                                    }),
                                const Text(
                                  "Tarih :",
                                  style: TextStyle(color: Colors.blue),
                                ),
                                DropdownButton(
                                  value: secilenRandevuTarihi,
                                  items: menuItems
                                      .map<DropdownMenuItem<String>>(
                                          (String b) {
                                    return DropdownMenuItem<String>(
                                      value: b,
                                      child: Text(b),
                                      onTap: () {
                                        setState(() {
                                          secilenRandevuTarihi = b;
                                          _selectDate(b);
                                        });
                                      },
                                    );
                                  }).toList(),
                                  onChanged: (a) {},
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Tahmini Sürecek Dakika : ",
                                    style: TextStyle(color: Colors.blue)),
                                DropdownButton(
                                  value: degiskenZaman,
                                  items: sureItems
                                      .map<DropdownMenuItem<int>>((int b) {
                                    return DropdownMenuItem<int>(
                                      value: b,
                                      child: Text("$b"),
                                      onTap: () {
                                        setState(() {
                                          degiskenZaman = b;
                                        });
                                      },
                                    );
                                  }).toList(),
                                  onChanged: (a) {},
                                )
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
                                    List<String>? x =
                                        AuthService().user?.saatler ?? [];
                                    if (x.contains(saat)) {
                                      Fluttertoast.showToast(
                                        msg: "Bu saatte randevu bulunmaktadır"
                                            .tr(),
                                        gravity: ToastGravity.BOTTOM,
                                        toastLength: Toast.LENGTH_LONG,
                                      );
                                    } else {
                                      if (manuelIsim != null &&
                                          manuelNo != null &&
                                          // ignore: unnecessary_null_comparison
                                          saat != null) {
                                        AuthService()
                                            .user
                                            ?.numaralar!
                                            .add(manuelNo!);
                                        AuthService().user?.saatler!.add(saat);

                                        AuthService()
                                            .updateUser(AuthService().user!);

                                        await FirebaseFirestore.instance
                                            .collection("Randevular")
                                            .doc((AuthService().user!.id))
                                            .collection("kim")
                                            .doc(manuelNo.toString())
                                            .set({
                                          "no": manuelNo.toString(),
                                          "dateDate": saat,
                                          "dateYapilacak": yapilacak,
                                          // ignore: unnecessary_null_in_if_null_operators
                                          "dateName": manuelIsim ?? null,
                                          "dateTarihi": randevuTarihi,
                                        });

                                        AuthService().checkUser();
                                        List<String> timeParts =
                                            saat.split(":");
                                        int hour = int.parse(timeParts[0]);
                                        int minute = int.parse(timeParts[1]);
                                        DateTime sss = DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day,
                                            hour,
                                            minute);
                                        NotificationService()
                                            .randevuZamanla("$manuelNo", sss);
                                        // ignore: use_build_context_synchronously
                                        await zamanEkle(context, degiskenZaman,
                                            todcevir(saat));
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);

                                        deleteManuelDataAtSpecificTime(
                                            manuelNo);
                                      } else {}
                                    }
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
                });
          },
          foregroundColor: Colors.white,
          //splashColor: Colors.purple,
          child: const Icon(Icons.add_alarm)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        actions: const [
          Icon(
            Icons.online_prediction,
            color: Colors.blue,
          )
        ],
        toolbarHeight: 70,
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Center(
          child: Text(
            isim!,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
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
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                //color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Text(
                        "$musait ve sonrasında kayıt yok",
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                    ),
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
                            List<String>? b =
                                AuthService().user?.numaralar ?? [];
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
                            List<String>? b =
                                AuthService().user?.numaralar ?? [];
                            if (b.contains(a)) {
                              return const Icon(
                                Icons.cut,
                                color: Colors.green,
                              );
                            } else {
                              return const Icon(
                                Icons.add_alarm_sharp,
                                size: 35,
                                color: Colors.blue,
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
                                                              color:
                                                                  Colors.blue),
                                                        ),
                                                        Text(callLogEntry
                                                            .number!),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text("Saat : ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue)),
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
                                                            "Tahmini Sürecek Dakika : ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue)),
                                                        DropdownButton(
                                                          value: degiskenZaman,
                                                          items: sureItems.map<
                                                              DropdownMenuItem<
                                                                  int>>((int
                                                              b) {
                                                            return DropdownMenuItem<
                                                                int>(
                                                              value: b,
                                                              child: Text("$b"),
                                                              onTap: () {
                                                                setState(() {
                                                                  degiskenZaman =
                                                                      b;
                                                                });
                                                              },
                                                            );
                                                          }).toList(),
                                                          onChanged: (a) {},
                                                        )
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
                                                            List<String>? x =
                                                                AuthService()
                                                                        .user
                                                                        ?.saatler ??
                                                                    [];
                                                            if (x.contains(
                                                                saat)) {
                                                              Fluttertoast
                                                                  .showToast(
                                                                msg:
                                                                    "Bu saatte randevu bulunmaktadır"
                                                                        .tr(),
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                toastLength: Toast
                                                                    .LENGTH_LONG,
                                                              );
                                                            } else {
                                                              deleteManuelDataAtSpecificTime(
                                                                  callLogEntry
                                                                      .number);
                                                              AuthService()
                                                                  .user
                                                                  ?.numaralar!
                                                                  .add(callLogEntry
                                                                      .number!);
                                                              AuthService()
                                                                  .user
                                                                  ?.saatler!
                                                                  .add(saat);

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
                                                                  .collection(
                                                                      "kim")
                                                                  .doc(callLogEntry
                                                                      .number
                                                                      .toString())
                                                                  .set({
                                                                "no": callLogEntry
                                                                    .number
                                                                    .toString(),
                                                                "dateDate":
                                                                    saat,
                                                                "dateYapilacak":
                                                                    yapilacak,
                                                                "dateName":
                                                                    // ignore: unnecessary_null_in_if_null_operators
                                                                    callLogEntry
                                                                            .name ??
                                                                        null
                                                              });
                                                              List<String>
                                                                  timeParts =
                                                                  saat.split(
                                                                      ":");
                                                              int hour =
                                                                  int.parse(
                                                                      timeParts[
                                                                          0]);
                                                              int minute =
                                                                  int.parse(
                                                                      timeParts[
                                                                          1]);
                                                              DateTime sss = DateTime(
                                                                  DateTime.now()
                                                                      .year,
                                                                  DateTime.now()
                                                                      .month,
                                                                  DateTime.now()
                                                                      .day,
                                                                  hour,
                                                                  minute);
                                                              NotificationService()
                                                                  .randevuZamanla(
                                                                      "$manuelNo",
                                                                      sss);
                                                              // ignore: use_build_context_synchronously
                                                              await zamanEkle(
                                                                  context,
                                                                  degiskenZaman,
                                                                  todcevir(
                                                                      saat));
                                                              // ignore: use_build_context_synchronously
                                                              Navigator.pop(
                                                                  context);
                                                            }
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
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
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
                                      leading: GestureDetector(
                                          onTap: () {
                                            launchSms(
                                                message:
                                                    "Sevgili ${e.dateName ?? 'Müşterimiz'}; ${AuthService().user!.isim} de ki randevunuzun yaklaştığını hatırlatmak isteriz. Bizi tercih ettiğiniz için teşekkür eder memnuniyet dileriz.",
                                                number: e.no);
                                          },
                                          child: const CircleAvatar(
                                            // ignore: sort_child_properties_last
                                            child: Icon(Icons.message),
                                            backgroundColor: Colors.yellow,
                                          )),
                                      subtitle: SingleChildScrollView(
                                        child: Text(
                                          "${e.dateYapilacak}",
                                          style: const TextStyle(
                                              color: Colors.blue),
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
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                          Text(e.dateName!
                                                                  .isEmpty
                                                              ? e.no!
                                                              : e.dateName!),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Text("Saat : ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue)),
                                                          IconButton(
                                                              icon: const Icon(Icons
                                                                  .access_time),
                                                              onPressed: () {
                                                                _selectTime(
                                                                    context);
                                                              }),
                                                          Text(
                                                              " ${(e.dateDate)}",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey))
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Text(
                                                              "Tahmini Sürecek Dakika : ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue)),
                                                          DropdownButton(
                                                            value:
                                                                degiskenZaman,
                                                            items: sureItems.map<
                                                                DropdownMenuItem<
                                                                    int>>((int
                                                                b) {
                                                              return DropdownMenuItem<
                                                                  int>(
                                                                value: b,
                                                                child:
                                                                    Text("$b"),
                                                                onTap: () {
                                                                  setState(() {
                                                                    degiskenZaman =
                                                                        b;
                                                                  });
                                                                },
                                                              );
                                                            }).toList(),
                                                            onChanged: (a) {},
                                                          )
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
                                                                deleteDate(e);
                                                              },
                                                              child: const Text(
                                                                  "Sil")),
                                                          TextButton(
                                                            child: const Text(
                                                                "Kaydet"),
                                                            onPressed:
                                                                () async {
                                                              List<String>? x =
                                                                  AuthService()
                                                                          .user
                                                                          ?.saatler ??
                                                                      [];
                                                              if (x.contains(
                                                                  saat)) {
                                                                Fluttertoast
                                                                    .showToast(
                                                                  msg:
                                                                      "Bu saatte randevu bulunmaktadır"
                                                                          .tr(),
                                                                  gravity:
                                                                      ToastGravity
                                                                          .BOTTOM,
                                                                  toastLength: Toast
                                                                      .LENGTH_LONG,
                                                                );
                                                              } else {
                                                                AuthService()
                                                                    .user
                                                                    ?.saatler!
                                                                    .add(saat);
                                                                deleteManuelDataAtSpecificTime(
                                                                    e.no);
                                                                // ignore: use_build_context_synchronously
                                                                Navigator.pop(
                                                                    context);
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "Randevular")
                                                                    .doc((AuthService()
                                                                        .user!
                                                                        .id))
                                                                    .collection(
                                                                        "kim")
                                                                    .doc(e.no!
                                                                        .toString())
                                                                    .set({
                                                                  "dateDate": saat
                                                                      .toString(),
                                                                  "dateYapilacak":
                                                                      yapilacak,
                                                                  "dateName":
                                                                      // ignore: unnecessary_null_in_if_null_operators
                                                                      e.dateName ??
                                                                          null,
                                                                  "no": e.no
                                                                      .toString()
                                                                });
                                                                List<String>
                                                                    timeParts =
                                                                    saat.split(
                                                                        ":");
                                                                int hour =
                                                                    int.parse(
                                                                        timeParts[
                                                                            0]);
                                                                int minute =
                                                                    int.parse(
                                                                        timeParts[
                                                                            1]);
                                                                DateTime sss = DateTime(
                                                                    DateTime.now()
                                                                        .year,
                                                                    DateTime.now()
                                                                        .month,
                                                                    DateTime.now()
                                                                        .day,
                                                                    hour,
                                                                    minute);
                                                                NotificationService()
                                                                    .randevuZamanla(
                                                                        "$manuelNo",
                                                                        sss);
                                                                // ignore: use_build_context_synchronously
                                                                await zamanEkle(
                                                                    context,
                                                                    degiskenZaman,
                                                                    todcevir(
                                                                        saat));
                                                              }
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
                    }),
              ),
            ),
    ));
  }

  Future<void> zamanEkle(BuildContext context, zaman, x) async {
    TimeOfDay currentTime = x;
    int addedMinutes = zaman; // Eklenecek dakika sayısı

    int newMinutes = currentTime.minute + addedMinutes; // Dakikaya 20 ekleyin
    int newHours =
        currentTime.hour + (newMinutes ~/ 60); // Saatleri güncelleyin
    newMinutes = newMinutes % 60; // Dakikaları güncelleyin

    TimeOfDay newTime = TimeOfDay(hour: newHours, minute: newMinutes);
    String timeString =
        // ignore: use_build_context_synchronously
        newTime.format(context);

    await FirebaseFirestore.instance
        .collection("Users")
        .doc((AuthService().user!.id))
        .update({
      "dateId": timeString.toString(),
    });
    //AuthService().updateUser(AuthService().user!);
    setState(() {
      musait = timeString.toString();
    });
  }
}
