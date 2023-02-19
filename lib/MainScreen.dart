import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:ownstyle/UserInfo.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

void getCallLogs() async {
  List<CallLogEntry> callLogs = [];
  Iterable<CallLogEntry> entries = await CallLog.get();
  entries.forEach((entry) {
    callLogs.add(entry);
  });
}

int _selectedIndex = 0;

class _MainScreenState extends State<MainScreen> {
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            child: const Text("Tayfun"),
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
                User().userName,
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
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Container(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Text("Son Aramalar"),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "05395904016",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                              dateControl(),
                              IconButton(onPressed: () {}, icon: dateAdd())
                            ],
                          ),
                        ),
                      ],
                    ),
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
                        subtitle: const Text("Saç + Sakal"),
                        onTap: () {},
                        onLongPress: () {},
                      ),
                      const Divider()
                    ],
                  ),
                )),
    );
  }
}

Icon dateAdd() {
  if (1 == 1) {
    return const Icon(
      Icons.add,
      size: 34,
    );
  } else {
    return const Icon(
      Icons.add,
      size: 34,
    );
  }
}

Text dateControl() {
  if (1 == 1) {
    return const Text("Randevusuz",
        style: TextStyle(color: Colors.pink, fontSize: 20));
  } else {
    return const Text("Randevusuz",
        style: TextStyle(color: Colors.pink, fontSize: 20));
  }
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
          children: const [
            Text("Yapılacaklar ", style: TextStyle(color: Colors.white)),
            Text("Saç + Sakal", style: TextStyle(color: Colors.red))
          ],
        ),
      ),
    ],
  );
}
