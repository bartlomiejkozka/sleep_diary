import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:untitled/pages/dream_data.dart';
import 'package:untitled/pages/home.dart';
import 'package:untitled/pages/mainApp.dart';
import 'package:untitled/pages/new_night.dart';
import 'package:flutter/material.dart';
import 'package:untitled/pages/colors.dart';
import 'package:untitled/pages/user_data.dart';

class History extends StatefulWidget {
  String text;
  UserData user;
  DreamData dreamData;

  History({required this.text, required this.user, required this.dreamData});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: onyx,
      appBar: AppBar(
        backgroundColor: onyx,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: indian_red),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) => MainApp(user: widget.user)));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Center(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.73,
                height: MediaQuery.of(context).size.height * 0.15,
                margin: EdgeInsets.only(top: 10.0),
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: raisin_black,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width * 0.55) / 2.1,
                      height: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: widget.user.imagePath != null
                            ? (!kIsWeb
                            ? Image.file(
                          File(widget.user.imagePath),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                            : Image.network(
                          widget.user.imagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ))
                            : Container(
                          color: Colors.white,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),


                    ),
                    Expanded(
                      child: Text(
                        'Tytuł Snu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.73,
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        'assets/hehe.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: MediaQuery.of(context).size.width * 0.14,
                    child: Container(
                      padding: EdgeInsets.all(2.0),
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: 135,
                      decoration: BoxDecoration(
                        color: rich_black.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        children: [
                          Text(
                            widget.text.length > 100
                                ? widget.text.substring(0, 70) + '...'
                                : widget.text,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              letterSpacing: 2,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Writer(
                                    user: widget.user,
                                    initialText: widget.text,
                                    initialPleasure: widget.dreamData.dreamPleasure,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.edit, color: indian_red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
