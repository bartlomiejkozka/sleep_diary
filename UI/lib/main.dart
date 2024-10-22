import 'package:flutter/material.dart';
import 'package:untitled/pages/dream_data.dart';
import 'package:untitled/pages/home.dart';
import 'package:untitled/pages/register.dart';
import 'package:untitled/pages/profile.dart';
import 'package:untitled/pages/settings.dart';
import 'package:untitled/pages/new_night.dart';
import 'package:untitled/pages/history.dart';
import 'package:untitled/pages/user_data.dart';
import 'package:untitled/pages/register.dart';
import 'package:untitled/pages/check.dart';
import 'package:untitled/pages/user_profile.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/home',
  routes: {
    '/': (context) => Check(),
    '/register': (context) => Register(email: '', password: ''),
    '/profile': (context) => Profile(),
    '/settings': (context) => Settings(),
    '/new_night': (context) => Writer(
        user: UserData(firstname: '', lastname: '', nickname: '', imagePath: '', email: '', password: ''),
        initialText: '',
        initialPleasure: 0.0),
    '/history': (context) => History(
        text: 'No data',
        user: UserData(firstname: '', lastname: '', nickname: '', imagePath: '', email: '', password: ''),
        dreamData: DreamData(dreamText: '', dreamImagePath: '', dreamPleasure: 0.0)
    ),
    'home': (context) => HomePage(user: UserData(firstname: '', lastname: '', nickname: '', imagePath: '', email: '', password: ''),),
    'mainApp': (context) => HomePage(user: UserData(firstname: '', lastname: '', nickname: '', imagePath: '', email: '', password: ''),),

  },
));

