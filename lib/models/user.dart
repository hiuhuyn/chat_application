class UserModel {
  String? id;
  String? name;
  String? photoUrl;
  String? email;
  bool isOnline;
  UserModel(
      {this.id, this.name, this.photoUrl, this.email, this.isOnline = false});

  UserModel copyWith({
    String? id,
    String? name,
    String? photoUrl,
    String? email,
    bool? isOnline,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      email: email ?? this.email,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'photoUrl': photoUrl,
      'email': email,
      'isOnline': isOnline,
    };
  }

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      photoUrl: map['photoUrl'],
      email: map['email'],
      isOnline: map['isOnline'] ?? false,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, photoUrl: $photoUrl, email: $email, isOnline: $isOnline)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.photoUrl == photoUrl &&
        other.email == email;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ photoUrl.hashCode ^ email.hashCode;
  }
}
