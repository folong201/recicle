import 'dart:convert';

class User {
  final String? uid;
  final String? email;
  final String? name;
  final String? photoUrl;
  final String? username;
  final String? password;
  final String? phone;

  User({this.uid, this.email, this.name, this.photoUrl, this.username, this.password, this.phone});

  // Method to convert User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'username': username,
      'password': password,
      'phone': phone,
    };
  }

  // Method to create a User object from a Map
  static User fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      photoUrl: map['photoUrl'],
      username: map['username'],
      password: map['password'],
      phone: map['phone'],
    );
  }

  // Method to convert User object to JSON string
  String toJson() {
    return json.encode(toMap());
  }

  // Method to create a User object from a JSON string
  static User fromJson(String jsonStr) {
    Map<String, dynamic> map = json.decode(jsonStr);
    return fromMap(map);
  }
}