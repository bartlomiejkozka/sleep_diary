import 'package:flutter/material.dart';
import 'package:untitled/pages/colors.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: onyx,
      appBar: AppBar(
        backgroundColor: onyx,
        title: Text(
          'Profile',
          style: TextStyle(
            color: indian_red,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 50.0),
            CircleAvatar(
              backgroundImage: AssetImage('assets/hehe.jpg'),
              radius: 80,
            ),
            SizedBox(height: 20.0),
            Text(
              'Jan Kowalski',
              style: TextStyle(
                color: indian_red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Adolf',
              style: TextStyle(
                color: indian_red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'jakies info opcjonalnie',
              style: TextStyle(
                color: indian_red,
                fontSize: 15,
                fontFamily: 'Roboto',
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
