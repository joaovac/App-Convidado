import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  final String name;
  final String image;
  bool comprado;

  User(
      {required this.id,
      required this.name,
      required this.image,
      required this.comprado});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'comprado': comprado,
      };

  static User fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      comprado: json['comprado']);
}
