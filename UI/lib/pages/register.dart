import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/pages/colors.dart';
import 'package:untitled/pages/new_night.dart';
import 'user_data.dart';

class Register extends StatefulWidget {
  final String email;
  final String password;

  Register({required this.email, required this.password});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  String _firstName = '';
  String _lastName = '';
  String _nickname = '';
  String _imagePath = '';
  bool _isImageSelected = false;

  Future<void> getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _isImageSelected = true;
        if (kIsWeb) {
          _imagePath = pickedFile.path;
          print('Web image: $_imagePath');
        } else {
          _imagePath = File(pickedFile.path).path;
          print('Mobile image: $_imagePath');
        }
      });
    } else {
      print('No image selected.');
    }
  }

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      if (!_isImageSelected) {
        _imagePath = 'assets/avatar.png';
      }

      UserData user = UserData(
        firstname: _firstName,
        lastname: _lastName,
        nickname: _nickname,
        imagePath: _imagePath,
        email: widget.email,
        password: widget.password,
      );

      print('User data: $_firstName $_lastName $_nickname $_imagePath ${widget.email}');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Writer(user: user, initialText: '', initialPleasure: 5.0),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: onyx,
        title: Text(
          'Sweet Dreams',
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
      body: Container(
        color: raisin_black,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 36.0),
                // First Name
                Center(
                  child: Container(
                    width: 300,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _firstName = value ?? '';
                      },
                    ),
                  ),
                ),
                SizedBox(height: 19.0),

                // Last Name
                Center(
                  child: Container(
                    width: 300,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _lastName = value ?? '';
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20.0),

                // Nickname
                Center(
                  child: Container(
                    width: 300,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nickname',
                        labelStyle: TextStyle(color: onyx),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your nickname';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _nickname = value ?? '';
                      },
                    ),
                  ),
                ),
                SizedBox(height: 45.0),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        color: gunmetal,
                        onPressed: getImage,
                        child: Text(
                          'Choose profile picture',
                          style: TextStyle(
                            color: indian_red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      if (_isImageSelected)
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 24.0,
                        )
                      else
                        Image.asset(
                          'assets/avatar.png',
                          width: 50,
                          height: 50,
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 20.0),

                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: onyx,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 13),
                    ),
                    onPressed: _register,
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: indian_red,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 230.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text('About'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('Help'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('More'),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    '©Sweet Dreams 2021 la Grindset Edition',
                    style: TextStyle(
                      color: indian_red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
