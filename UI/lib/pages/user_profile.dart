import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/pages/user_data.dart';
import 'package:untitled/pages/home.dart';

class UserProfile extends StatefulWidget {
  UserData user;
  UserProfile({super.key, required this.user});

  @override
  _UserProfile createState() => _UserProfile();
}

class _UserProfile extends State<UserProfile> {
  String _imagePath = '';
  bool _isImageSelected = false;

  @override
  void initState() {
    super.initState();
    _imagePath = widget.user.imagePath; // Initialize the image path from user data
  }

  Future<void> getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _isImageSelected = true;
        if (kIsWeb) {
          _imagePath = pickedFile.path;
          //widget.user.imagePath = _imagePath;
          print('Web image: $_imagePath');
        } else {
          _imagePath = File(pickedFile.path).path;
          //widget.user.imagePath = _imagePath;
          print('Mobile image: $_imagePath');
        }
      });
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(
          height: 50.0,
          width: 50.0,
          child: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(user: widget.user)));
            },
          ),
        ),
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(0, -100),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    // Display selected image, if available
                    backgroundImage: _isImageSelected
                        ? (kIsWeb
                        ? NetworkImage(_imagePath) // For web
                        : FileImage(File(_imagePath)) as ImageProvider) // For mobile
                        : (widget.user.imagePath.isNotEmpty
                        ? (kIsWeb
                        ? NetworkImage(widget.user.imagePath) // Existing web image
                        : FileImage(File(widget.user.imagePath)) as ImageProvider) // Existing mobile image
                        : AssetImage('assets/avatar.png')), // Default avatar
                    radius: 60, // Increase the radius for better visibility
                    backgroundColor: Colors.white,
                  ),
                  Positioned(
                    bottom: -10,
                    right: -10,
                    child: IconButton(
                      iconSize: 35.0,
                      color: const Color(0xffb76d68),
                      onPressed: getImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                Transform.translate(
                  offset: Offset(0, -90),
                  child: Text(
                    widget.user.nickname,
                    style: TextStyle(color: Colors.white, fontSize: 30.0),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -80),
                  child: Text(
                    widget.user.email,
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ],
            ),
            Transform.translate(
              offset: Offset(0, 0),
              child: Text(
                'Favorite',
                style: TextStyle(color: Color(0xffb76d68), fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
            ),
            Transform.translate(
              offset: Offset(0, 20),
              child: Container(
                height: 300.0,
                width: 300.0,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Color(0xff403f4c)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
