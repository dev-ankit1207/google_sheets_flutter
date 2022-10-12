import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  Timestamp? createdAt;
  String? email;
  bool? isAdmin;
  bool? isEmailLogin;
  String? name;
  int? phoneNumber;
  String? uid;
  String? image;
  Timestamp? updatedAt;

  UserModel({this.createdAt, this.isEmailLogin, this.image, this.email, this.isAdmin, this.name, this.phoneNumber, this.uid, this.updatedAt});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      createdAt: json['createdAt'],
      email: json['email'],
      isAdmin: json['isAdmin'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      uid: json['uid'],
      image: json['image'],
      isEmailLogin: json['isEmailLogin'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['email'] = this.email;
    data['isAdmin'] = this.isAdmin;
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['image'] = this.image;
    data['uid'] = this.uid;
    data['isEmailLogin'] = this.isEmailLogin;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
