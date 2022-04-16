import 'package:flutter/material.dart';
import 'package:UI_scanAndVerifyApp/scanScreen.dart';

//TODO: safe area add

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Scan and Verify'),
          centerTitle: true,
        ),
        body: Center(
          child: ScanScreen(),
        ),
      ),
    );
  }
}
//
// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   // int _selectedIndex = 0;
//   bool userRegistered = globals.userRegistered;
//   static const TextStyle optionStyle =
//   TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
//   // final List<Widget> _widgetOptions = <Widget>[
//   //   // ProfileScreen(),
//   //   VerifyScreen(),
//   //   // ScanScreen(),
//   // ];
//
//   void performUserRegistered(){
//     setState(() {
//       userRegistered = true;
//       globals.userRegistered = true;
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Scan and Verify'),
//       ),
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//     );
//   }
// }