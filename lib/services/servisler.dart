import 'dart:convert';

class MeslekServices {
  List<Meslek> get meslekler {
    List meslekler = jsonDecode(_MeslekData) as List;
    return meslekler.map((a) => Meslek.fromJson(a)).toList();
  }
}

class Meslek {
  String meslek;
  int x;

  Meslek({required this.meslek, required this.x});

  factory Meslek.fromJson(Map<String, dynamic> json) {
    return Meslek(meslek: json["meslek"], x: json["x"]);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['meslek'] = meslek;
    data['x'] = x;
    return data;
  }
}

// ignore: constant_identifier_names
const String _MeslekData = """[
  {
    "meslek": "Erkek Kuaforu",
    "x": 1
  },
  {
    "meslek": "Kadın Kuaforu",
    "x": 2
  }
  
]""";
