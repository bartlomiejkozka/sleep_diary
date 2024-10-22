import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Importujemy pakiet http
import 'dart:convert'; // Importujemy json
import 'package:untitled/pages/colors.dart';
import 'register.dart';

class Check extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Check> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _passwordsMatch = true;

  Future<void> login(String email, String password) async {
    // Adres URL twojego endpointu
    final url = Uri.parse('http://localhost:8888/login'); // Upewnij się, że endpoint jest poprawny

    // Tworzymy obiekt JSON
    final Map<String, dynamic> body = {
      'email': email,
      'password': password,
    };

    // Wykonujemy zapytanie POST
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(body), // Konwertujemy Mapę na JSON
    );

    // Sprawdzamy odpowiedź
    if (response.statusCode == 200) {
      // Jeśli zapytanie się powiodło
      print('Login successful!');
      print('Response: ${response.body}');
    } else {
      // Jeśli zapytanie się nie powiodło
      print('Failed to login. Status code: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  }

  void _checkCredentials() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      if (_password == _confirmPassword) {
        setState(() {
          _passwordsMatch = true;
        });

        // Wywołanie funkcji login z email i hasłem
        login(_email, _password);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Register(
                email: _email,
                password: _password),
          ),
        );
      } else {
        setState(() {
          _passwordsMatch = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: onyx,
        title: Text(
          'Sweet Dreams Login',
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
          padding: const EdgeInsets.all(19.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 37.0),
                Center(
                  child: Container(
                    width: 300,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value ?? '';
                      },
                    ),
                  ),
                ),
                SizedBox(height: 19.0),

                Center(
                  child: Container(
                    width: 300,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                      ),
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value ?? '';
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20.0),

                Center(
                  child: Container(
                    width: 300,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                      ),
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _confirmPassword = value ?? '';
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20.0),

                if (!_passwordsMatch)
                  Center(
                    child: Text(
                      'Passwords do not match',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(height: 30.0),

                // Przycisk Check
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: onyx,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    onPressed: _checkCredentials,
                    child: Text(
                      'Check',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: indian_red,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
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
