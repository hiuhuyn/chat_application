import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Friend {
  String? id;
  String? idUser1;
  String? idUser2;
  bool? isFriend;
  Friend({
    this.id,
    required this.idUser1,
    required this.idUser2,
    this.isFriend = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idUser1': idUser1,
      'idUser2': idUser2,
      'isFriend': isFriend,
    };
  }

  factory Friend.fromMap({String? id, required Map<dynamic, dynamic> map}) {
    return Friend(
      id: id,
      idUser1: map['idUser1'],
      idUser2: map['idUser2'],
      isFriend: map['isFriend'],
    );
  }

  @override
  String toString() {
    return 'Friend(id: $id, idUser1: $idUser1, idUser2: $idUser2, isFriend: $isFriend)';
  }

  Friend copyWith({
    String? id,
    String? idUser1,
    String? idUser2,
    bool? isFriend,
    bool? isOnline,
  }) {
    return Friend(
      id: id ?? this.id,
      idUser1: idUser1 ?? this.idUser1,
      idUser2: idUser2 ?? this.idUser2,
      isFriend: isFriend ?? this.isFriend,
    );
  }

  @override
  bool operator ==(covariant Friend other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.idUser1 == idUser1 &&
        other.idUser2 == idUser2 &&
        other.isFriend == isFriend;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        idUser1.hashCode ^
        idUser2.hashCode ^
        isFriend.hashCode;
  }
}
