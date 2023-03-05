import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:ownstyle/Auth_Service.dart';
import 'package:ownstyle/user_model.dart';
import 'package:phone_state/phone_state.dart';

class MainScreen extends StatefulWidget {
  final MyUser user;
  MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

int _selectedIndex = 0;

class _MainScreenState extends State<MainScreen> {
  PhoneStateStatus status = PhoneStateStatus.NOTHING;
  bool granted = false;

  Iterable<CallLogEntry> _callLogEntries = [];
  @override
  void initState() {
    _getCallLog();
    setStream();
  }

  void setStream() {
    PhoneState.phoneStateStream.listen((event) {
      print("aaaaaaaaaaaaaaaaaaaa $event");

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
    setState(() {
      _callLogEntries = callLog;
    });
  }

  late TextEditingController _yapilacakController;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  var saat = "00:00";
  String yapilacak = "";
  @override
  Widget build(BuildContext context) {
    String? isim = widget.user.isim;
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            backgroundColor: Colors.blue,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Randevu Oluştur',
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
            backgroundColor: Colors.black,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.black,
                content: Column(
                  children: [
                    const SizedBox(
                      height: 400,
                    ),
                    customerControl()
                  ],
                ),
                duration: const Duration(seconds: 3),
              ));
            },
            foregroundColor: Colors.white,
            //splashColor: Colors.purple,
            child: const Text(
              "05395904016",
              style: TextStyle(fontSize: 10),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            toolbarHeight: 70,
            elevation: 0,
            backgroundColor: Colors.blueAccent,
            title: Center(
              child: Text(
                isim!,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(8))),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          body: _selectedIndex == 0
              ? Container(
                  /* width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width, */
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
                            return ListTile(
                              leading: Icon(Icons.phone),
                              title: Text(callLogEntry.number!),
                              trailing: IconButton(
                                  onPressed: () {
                                    showDialog(
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
                                                      SizedBox(
                                                        width: 200,
                                                        child: TextField(
                                                          maxLines: 1,
                                                          onChanged: (a) {
                                                            setState(() {
                                                              saat = a;
                                                            });
                                                          },
                                                        ),
                                                      ),
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
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                            backgroundColor:
                                                                Colors.blue,
                                                            content: Text(
                                                                "Randevu Alındı",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                            duration: Duration(
                                                                seconds: 1),
                                                          ));
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
                                  icon: dateAdd()),
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
                  height: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text("Tayfun Kaya"),
                        trailing: const Text("17:00"),
                        subtitle: Text(yapilacak),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  title: const Center(
                                    child: Text(
                                      "Randevu Ayarları",
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
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "Sil",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            )),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Düzenle",
                                              style: TextStyle(
                                                  color: Colors.blue)),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              });
                        },
                        onLongPress: () {},
                      ),
                      const Divider()
                    ],
                  ),
                )),
    );
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
}

dateAdd() {
  if (1 == 1) {
    return GestureDetector(
      child: const Icon(
        Icons.add,
        size: 34,
      ),
    );
  } else {
    return GestureDetector(
      child: const Icon(
        Icons.add,
        size: 34,
      ),
    );
  }
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
