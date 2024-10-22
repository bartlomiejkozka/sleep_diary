import 'package:flutter/material.dart';
import 'package:untitled/pages/colors.dart';
import 'package:untitled/pages/setting.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: raisin_black,
        title: Text(
          'Settings',
          style: TextStyle(
            color: indian_red,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: raisin_black,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: <Widget>[
                Divider(
                  color: indian_red,
                  thickness: 2,
                  height: 10,
                ),
                Setting(
                  icon: Icons.notification_add,
                  title: 'Notifications',
                  nextScreen: NotificationsScreen(),
                ),
                Setting(
                  icon: Icons.lock,
                  title: 'Privacy',
                  nextScreen: PrivacyScreen(),
                ),
                Setting(
                  icon: Icons.security,
                  title: 'Security',
                  nextScreen: PrivacyScreen(),
                ),
                Setting(
                  icon: Icons.payment,
                  title: 'Payments',
                  nextScreen: PrivacyScreen(),
                ),
                Setting(
                  icon: Icons.ads_click,
                  title: 'Ads',
                  nextScreen: PrivacyScreen(),
                ),
                Setting(
                  icon: Icons.help,
                  title: 'Help',
                  nextScreen: PrivacyScreen(),
                ),
                Setting(
                  icon: Icons.info,
                  title: 'About',
                  nextScreen: PrivacyScreen(),
                ),
                Setting(
                  icon: Icons.dangerous,
                  title: 'Delete Account',
                  nextScreen: PrivacyScreen(),
                ),
                Divider(
                  color: indian_red,
                  thickness: 2,
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
