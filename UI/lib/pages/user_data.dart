import 'package:flutter/material.dart';
import 'package:untitled/pages/colors.dart';

class UserData {
  final String firstname;
  final String lastname;
  final String nickname;
  late final String imagePath;
  final String email;
  final String password;


  UserData({required this.firstname, required this.lastname, required this.nickname, required this.imagePath, required this.email, required this.password});
}