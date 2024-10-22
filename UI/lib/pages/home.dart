import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:untitled/pages/new_night.dart';
import 'package:untitled/pages/settings.dart';
import 'package:untitled/pages/user_data.dart';
import 'package:untitled/pages/user_profile.dart';


class HomePage extends StatefulWidget {
  UserData user;
  HomePage({super.key, required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  DateTime _choosenDate = DateTime.now();
  int _countOfDays = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _countOfDays = numberOfLisView(DateTime.now().month, DateTime.now().year);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDay(_choosenDate.day);
    });
  }

  int numberOfLisView(int month, int year)
  {
    if(month == 1 || month == 3 || month == 5 || month == 7
        || month == 8 || month == 10 || month == 12) { return 31; }
    else if(month == 4 || month == 6 || month == 9 || month == 11) { return 30; }
    else if(month == 2)
    {
      if(year % 4 == 0 && year % 100 != 0) { return 29; }
      else { return 28; }
    }
    else { return 0; }
  }

  void _showDatePickerAndDayButtons()
  {
    showDatePicker(
        context: context, initialDate: DateTime.now(),
        firstDate: DateTime(2024), lastDate: DateTime(2050)
    ).then((value) {
      setState(() {
        if(value != null) {
          _choosenDate = value;
          _countOfDays = numberOfLisView(value.month, value.year);
          if(_countOfDays == 0) { print('Error: numberOfListView function'); }
          _scrollToSelectedDay(value.day);
        }
        else {
          //_choosenDate = DateTime.now();
          //_countOfDays = numberOfLisView(DateTime.now().month);
        }
      });
    });
  }

  void _scrollToSelectedDay(int day) {
    final index = day - 1; // Index of the selected day
    final buttonDiameter = 129.0;
    int temp = 50; //+30
    if(index + 1 > 3)
    {
      temp += ((index+1) - 3) * 30;
    }
    final position = index * buttonDiameter; // Assuming each button has a width of 100 pixels

    // Center the selected item in the view
    _scrollController.animateTo(
      position - (MediaQuery.of(context).size.width / 2) + temp, // Adjust for centering
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: const Color(0xff403f4c),
        elevation: 0,
        toolbarHeight: 170.0,
        title: Column(children: <Widget>[
          const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                    Icons.local_fire_department,
                    color: Color(0xffb76d68),
                    size: 45.0,
                    semanticLabel: 'FireIcon'),
                SizedBox(width: 8.0),
                Text('1',
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))
              ]),
          const SizedBox(height: 10.0),
          const Divider(
            thickness: 2.0,
            color: Color.fromARGB(255, 46, 45, 55),
            indent: 0,
            endIndent: 0,
          ),
          const SizedBox(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <
              Widget>[
            Text(
                DateFormat('MMMM yyyy').format(_choosenDate).toString(),
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            MaterialButton(
                elevation: 10.0,
                color: Color(0xff403f4c),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Color(0xffb76d68), width: 2.0),
                ),
                onPressed: _showDatePickerAndDayButtons,
                child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(Icons.calendar_month,
                        color: Colors.white,
                        size: 30.0,
                        semanticLabel: 'CalendarIcon')))
          ])
        ]),
      ),
      body: Container(
        height: 600.0,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _countOfDays,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            int buttonNumber = index + 1;  // Start numbering from 1 (not 0)

            bool isSelected = buttonNumber == _choosenDate.day;

            return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Writer(user: widget.user, initialText: 'hehehehe', initialPleasure: 2.0)));
                    },
                    child: Text('$buttonNumber', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0)),
                    style: ElevatedButton.styleFrom(
                      //side: BorderSide(color: Colors.grey, width: 2.0),
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(45),
                        backgroundColor: isSelected ? Color(0xffb76d68) : Color(0xff403f4c)
                    )
                )
            );
          },
        )
      ),
      bottomNavigationBar: Container(
        color: Color(0xff403f4c),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
              backgroundColor: Color(0xff403f4c),
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Color(0xffb76d68),
              padding: EdgeInsets.all(20),
              gap: 10.0,
              tabs: [
                GButton(icon: Icons.home, text: 'Home'),
                GButton(icon: Icons.favorite_border, text: 'Likes'),
                GButton(
                    icon: Icons.settings,
                    text: 'Settings',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Settings()),
                      );
                    }),
                GButton(icon: Icons.supervisor_account, text: 'User',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfile(user: widget.user)),
                      );
                    }),
              ]),
        ),
      ),
    );
  }
}
