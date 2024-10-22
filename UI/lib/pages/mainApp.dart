import 'package:flutter/material.dart';
import 'package:untitled/pages/home.dart';
import 'package:untitled/pages/user_data.dart';
import 'home.dart';

class MainApp extends StatelessWidget
{
  UserData user;
  final Color themeColor = const Color(0xff403f4c);

  MainApp({super.key, required this.user});

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      title: 'Dream Book', 
      theme: ThemeData(
        primaryColor: themeColor, // Define pri mary color directly
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: themeColor, // Set primary color in colorScheme
        ),
        scaffoldBackgroundColor: Color(0xff2c2b3c),
        appBarTheme: AppBarTheme(backgroundColor: themeColor, elevation: 0.0),
      ),
      home: HomePage(user: user,)
    );
  }

}