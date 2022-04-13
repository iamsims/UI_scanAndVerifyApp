import 'package:flutter/material.dart';
import 'package:UI_scanAndVerifyApp/profile.dart';
import 'package:UI_scanAndVerifyApp/verify.dart';
import 'package:UI_scanAndVerifyApp/Register.dart';
import 'package:UI_scanAndVerifyApp/data.dart' as globals;
import 'package:UI_scanAndVerifyApp/scanScreen.dart';

//TODO: safe area add

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  bool userRegistered = globals.userRegistered;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptions = <Widget>[
    ProfileScreen(),
    VerifyScreen(),
    ScanScreen(),
  ];

  void performUserRegistered(){
    setState(() {
      userRegistered = true;
      globals.userRegistered = true;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return userRegistered?Scaffold(
      appBar: AppBar(
        title: const Text('App Name'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.details),
            label: 'Verify',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'Scan',
          ),

        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    ): RegisterScreen(performUserRegistered);
  }
}