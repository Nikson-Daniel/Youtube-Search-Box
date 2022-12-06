import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserModel{
  final String title;

  UserModel({required this.title});

  factory UserModel.fromJson(final json){
    return UserModel(
      title: json['title']
    );
  }

}