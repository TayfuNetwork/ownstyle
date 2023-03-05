// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MyDate {
  String? dateName;
  DateTime? dateDate;
  int? dateNo;
  String? dateId;
  String? dateYapilacak;
  MyDate({
    this.dateName,
    this.dateDate,
    this.dateNo,
    this.dateId,
    this.dateYapilacak,
  });

  MyDate copyWith({
    String? dateName,
    DateTime? dateDate,
    int? dateNo,
    String? dateId,
    String? dateYapilacak,
  }) {
    return MyDate(
      dateName: dateName ?? this.dateName,
      dateDate: dateDate ?? this.dateDate,
      dateNo: dateNo ?? this.dateNo,
      dateId: dateId ?? this.dateId,
      dateYapilacak: dateYapilacak ?? this.dateYapilacak,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dateName': dateName,
      'dateDate': dateDate?.millisecondsSinceEpoch,
      'dateNo': dateNo,
      'dateId': dateId,
      'dateYapilacak': dateYapilacak,
    };
  }

  factory MyDate.fromMap(Map<String, dynamic> map) {
    return MyDate(
      dateName: map['dateName'] != null ? map['dateName'] as String : null,
      dateDate: map['dateDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['dateDate'] as int) : null,
      dateNo: map['dateNo'] != null ? map['dateNo'] as int : null,
      dateId: map['dateId'] != null ? map['dateId'] as String : null,
      dateYapilacak: map['dateYapilacak'] != null ? map['dateYapilacak'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyDate.fromJson(String source) => MyDate.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MyDate(dateName: $dateName, dateDate: $dateDate, dateNo: $dateNo, dateId: $dateId, dateYapilacak: $dateYapilacak)';
  }

  @override
  bool operator ==(covariant MyDate other) {
    if (identical(this, other)) return true;
  
    return 
      other.dateName == dateName &&
      other.dateDate == dateDate &&
      other.dateNo == dateNo &&
      other.dateId == dateId &&
      other.dateYapilacak == dateYapilacak;
  }

  @override
  int get hashCode {
    return dateName.hashCode ^
      dateDate.hashCode ^
      dateNo.hashCode ^
      dateId.hashCode ^
      dateYapilacak.hashCode;
  }
}
