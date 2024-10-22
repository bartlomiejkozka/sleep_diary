import 'dart:convert'; // Importuj do pracy z JSON
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Importuj pakiet http
import 'package:untitled/pages/colors.dart';
import 'package:untitled/pages/history.dart';
import 'package:untitled/pages/user_data.dart';
import 'package:untitled/pages/dream_data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Writer extends StatefulWidget {
  final UserData user;
  final String initialText;
  double initialPleasure;

  Writer({
    required this.user,
    required this.initialText,
    required this.initialPleasure,
  });

  @override
  State<Writer> createState() => _WriterState();
}

class _WriterState extends State<Writer> {
  late TextEditingController sen;
  int _charLimit = 140;
  late double _dreamPleasure = widget.initialPleasure;
  DreamData dreamData = DreamData(dreamText: '', dreamImagePath: '', dreamPleasure: 0.0);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    sen = TextEditingController(text: widget.initialText);
    _getDreams(); // Wywołaj metodę pobierania snów przy inicjalizacji
  }

  Future<void> _postDream() async {
    setState(() {
      _isLoading = true;
    });

    final Map<String, dynamic> body = {
      'dreamText': sen.text,
      'dreamPleasure': _dreamPleasure,
      'dreamImagePath': widget.user.imagePath, // Przykładowe pole z danymi użytkownika
    };

    final response = await http.post(
      Uri.parse('http://localhost:8888/dreams'), // Zmień na właściwy URL API
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      print('Dream posted successfully!');
      print('Response: ${response.body}');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => History(
            text: sen.text,
            user: widget.user,
            dreamData: DreamData(
              dreamText: sen.text,
              dreamPleasure: _dreamPleasure,
              dreamImagePath: widget.user.imagePath,
            ),
          ),
        ),
      );
    } else {
      print('Failed to post dream. Status code: ${response.statusCode}');
      print('Response: ${response.body}');
    }

    setState(() {
      _isLoading = false; // Wyłączamy animację ładowania po zakończeniu
    });
  }

  Future<void> _getDreams() async {
    final response = await http.get(
      Uri.parse('http://localhost:8888/dreams'), // Zmień na właściwy URL API
    );

    if (response.statusCode == 200) {
      List<dynamic> dreams = json.decode(response.body);
      print('Dreams retrieved successfully!');
      print('Response: $dreams');
      // Możesz przetworzyć te dane i wyświetlić je w UI lub w inny sposób
    } else {
      print('Failed to retrieve dreams. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: onyx,
      body: _isLoading // Jeśli jest ładowanie, pokazujemy animację
          ? Center(
        child: SpinKitFadingCube(
          color: Colors.blue,
          size: 50.0,
        ),
      )
          : SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: indian_red),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.all(10.0),
                      shape: CircleBorder(),
                      backgroundColor: raisin_black,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: _postDream,
                    style: TextButton.styleFrom(
                      backgroundColor: raisin_black,
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text(
                      'Posted',
                      style: TextStyle(
                        color: indian_red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          backgroundImage: widget.user.imagePath != null && !kIsWeb
                              ? FileImage(File(widget.user.imagePath))
                              : widget.user.imagePath != null && kIsWeb
                              ? NetworkImage(widget.user.imagePath)
                              : AssetImage('assets/avatar.png') as ImageProvider,
                          radius: 20,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextField(
                            controller: sen,
                            maxLength: _charLimit,
                            decoration: InputDecoration(
                              hintText: 'Write your dream...',
                              hintStyle: TextStyle(color: Colors.white54),
                              filled: true,
                              fillColor: raisin_black,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              counterText: '',
                            ),
                            style: TextStyle(color: Colors.white),
                            maxLines: null,
                            onChanged: (text) {
                              setState(() {
                                dreamData.dreamText = text;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (sen.text.length >= _charLimit)
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        'You have reached the character limit!',
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How good was your dream?',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Slider.adaptive(
                          value: _dreamPleasure,
                          min: 1,
                          max: 10,
                          divisions: 9,
                          label: _dreamPleasure.round().toString(),
                          activeColor: indian_red,
                          inactiveColor: Colors.grey,
                          onChanged: (double newValue) {
                            setState(() {
                              _dreamPleasure = newValue;
                              dreamData.dreamPleasure = newValue;
                            });
                          },
                        ),
                        Text(
                          'Pleasure rating: ${_dreamPleasure.toStringAsFixed(1)}',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
