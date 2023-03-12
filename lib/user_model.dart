// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:ownstyle/randevu_model.dart';

class MyUser {
  String? id;
  bool? musteri;
  bool? abone;
  String? meslek;
  String? isim;
  String? no;
  String? token;
  List<MyDate>? randevu;
  String? dateName;
  String? dateDate = "";
  String? dateNo;
  String? dateId;
  String? dateYapilacak;
  List<String>? numaralar = [];
  MyUser({
    this.id,
    this.musteri,
    this.abone,
    this.meslek,
    this.isim,
    this.no,
    this.token,
    this.randevu,
    this.dateName,
    this.dateDate,
    this.dateNo,
    this.dateId,
    this.dateYapilacak,
    this.numaralar,
  });

  MyUser copyWith({
    String? id,
    bool? musteri,
    bool? abone,
    String? meslek,
    String? isim,
    String? no,
    String? token,
    List<MyDate>? randevu,
    String? dateName,
    String? dateDate = "",
    String? dateNo,
    String? dateId,
    String? dateYapilacak,
    List<String>? numaralar,
  }) {
    return MyUser(
      id: id ?? this.id,
      musteri: musteri ?? this.musteri,
      abone: abone ?? this.abone,
      meslek: meslek ?? this.meslek,
      isim: isim ?? this.isim,
      no: no ?? this.no,
      token: token ?? this.token,
      randevu: randevu ?? this.randevu,
      dateName: dateName ?? this.dateName,
      dateDate: dateDate ?? this.dateDate,
      dateNo: dateNo ?? this.dateNo,
      dateId: dateId ?? this.dateId,
      dateYapilacak: dateYapilacak ?? this.dateYapilacak,
      numaralar: numaralar ?? this.numaralar,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'musteri': musteri,
      'abone': abone,
      'meslek': meslek,
      'isim': isim,
      'no': no,
      'token': token,
      'randevu': randevu?.map((x) => x.toMap()).toList(),
      'dateName': dateName,
      'dateDate': dateDate,
      'dateNo': dateNo,
      'dateId': dateId,
      'dateYapilacak': dateYapilacak,
      'numaralar': numaralar,
    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
      id: map['id'] != null ? map['id'] as String : null,
      musteri: map['musteri'] != null ? map['musteri'] as bool : null,
      abone: map['abone'] != null ? map['abone'] as bool : null,
      meslek: map['meslek'] != null ? map['meslek'] as String : null,
      isim: map['isim'] != null ? map['isim'] as String : null,
      no: map['no'] != null ? map['no'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
      randevu: map['randevu'] != null
          ? List<MyDate>.from(
              (map['randevu'] as List<int>).map<MyDate?>(
                (x) => MyDate.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      dateName: map['dateName'] != null ? map['dateName'] as String : null,
      dateDate: map['dateDate'] != null ? map['dateDate'] as String : null,
      dateNo: map['dateNo'] != null ? map['dateNo'] as String : null,
      dateId: map['dateId'] != null ? map['dateId'] as String : null,
      dateYapilacak:
          map['dateYapilacak'] != null ? map['dateYapilacak'] as String : null,
      numaralar: map['numaralar'] != null
          ? (map['numaralar'] as List).map((e) => e.toString()).toList()
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory MyUser.fromJson(String source) =>
      MyUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MyUser(id: $id, musteri: $musteri, abone: $abone, meslek: $meslek, isim: $isim, no: $no, token: $token, randevu: $randevu, dateName: $dateName, dateDate: $dateDate, dateNo: $dateNo, dateId: $dateId, dateYapilacak: $dateYapilacak, numaralar: $numaralar)';
  }

  @override
  bool operator ==(covariant MyUser other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.musteri == musteri &&
        other.abone == abone &&
        other.meslek == meslek &&
        other.isim == isim &&
        other.no == no &&
        other.token == token &&
        listEquals(other.randevu, randevu) &&
        other.dateName == dateName &&
        other.dateDate == dateDate &&
        other.dateNo == dateNo &&
        other.dateId == dateId &&
        other.dateYapilacak == dateYapilacak &&
        listEquals(other.numaralar, numaralar);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        musteri.hashCode ^
        abone.hashCode ^
        meslek.hashCode ^
        isim.hashCode ^
        no.hashCode ^
        token.hashCode ^
        randevu.hashCode ^
        dateName.hashCode ^
        dateDate.hashCode ^
        dateNo.hashCode ^
        dateId.hashCode ^
        dateYapilacak.hashCode ^
        numaralar.hashCode;
  }
}
