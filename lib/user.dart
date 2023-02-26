// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MyUser {
  String? id;
  bool? musteri;
  bool? abone;
  String? meslek;
  String? isim;
  int? no;
  String? token;
  MyUser({
    this.id,
    this.musteri,
    this.abone,
    this.meslek,
    this.isim,
    this.no,
    this.token,
  });

  MyUser copyWith({
    String? id,
    bool? musteri,
    bool? abone,
    String? meslek,
    String? isim,
    int? no,
    String? token,
  }) {
    return MyUser(
      id: id ?? this.id,
      musteri: musteri ?? this.musteri,
      abone: abone ?? this.abone,
      meslek: meslek ?? this.meslek,
      isim: isim ?? this.isim,
      no: no ?? this.no,
      token: token ?? this.token,
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
    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
      id: map['id'] != null ? map['id'] as String : null,
      musteri: map['musteri'] != null ? map['musteri'] as bool : null,
      abone: map['abone'] != null ? map['abone'] as bool : null,
      meslek: map['meslek'] != null ? map['meslek'] as String : null,
      isim: map['isim'] != null ? map['isim'] as String : null,
      no: map['no'] != null ? map['no'] as int : null,
      token: map['token'] != null ? map['token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyUser.fromJson(String source) => MyUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MyUser(id: $id, musteri: $musteri, abone: $abone, meslek: $meslek, isim: $isim, no: $no, token: $token)';
  }

  @override
  bool operator ==(covariant MyUser other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.musteri == musteri &&
      other.abone == abone &&
      other.meslek == meslek &&
      other.isim == isim &&
      other.no == no &&
      other.token == token;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      musteri.hashCode ^
      abone.hashCode ^
      meslek.hashCode ^
      isim.hashCode ^
      no.hashCode ^
      token.hashCode;
  }
}
