import 'package:flutter/material.dart';
import 'package:untitled/pages/colors.dart';

// Widget dla najazdu kursorem
class Setting extends StatefulWidget {
  final IconData icon;
  final String title;
  final Widget nextScreen;

  Setting({
    required this.icon,
    required this.title,
    required this.nextScreen,
  });
  @override
  _HoverableSettingState createState() => _HoverableSettingState();
}

class _HoverableSettingState extends State<Setting> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // push do podanego ekranu
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.nextScreen),
        );
      },
      onHover: (hovering) {
        setState(() {
          _isHovered = hovering;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: raisin_black,
          boxShadow: _isHovered ? [
            BoxShadow(
              color: indian_red.withOpacity(0.7),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),] : [],
        ),
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(widget.icon, color: Colors.white),
                SizedBox(width: 10.0),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

//nawigacja dla notyfikacji
class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: Center(child: Text('Notifications Settings')),
    );
  }
}

//nawigacja dla prywatności
class PrivacyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privacy')),
      body: Center(child: Text('Privacy Settings')),
    );
  }
}
