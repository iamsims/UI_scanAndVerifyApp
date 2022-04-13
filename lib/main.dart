// import 'package:UI_scanAndVerifyApp/walletSetup.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:UI_scanAndVerifyApp/profile.dart';
import 'package:UI_scanAndVerifyApp/addAtrributes.dart';
import 'package:UI_scanAndVerifyApp/approvedAttributes.dart';
import 'package:UI_scanAndVerifyApp/verify.dart';
import 'package:UI_scanAndVerifyApp/Register.dart';
import 'package:UI_scanAndVerifyApp/data.dart' as globals;
import 'package:UI_scanAndVerifyApp/walletGen.dart';
import 'package:provider/provider.dart';
import 'package:UI_scanAndVerifyApp/models/contractLinking.dart';
import 'package:UI_scanAndVerifyApp/home.dart';
import 'package:http/http.dart' as http;
//TODO: safe area add

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider.value(
          value:ContractLinking(),
        ),
      ],
    
      child: MaterialApp(
        routes: {
          '/': (context) => Home(),
          '/home': (context) => SHome(),
          '/newWallet': (context) => NewWallet(storage: WalletStorage()),
        },
      ),
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
  ];


  void postaoao() async{
    var files = {
      'file': ('Congrats! You have uploaded your file to IPFS!'),
    };

    http.MultipartRequest request = new http.MultipartRequest("POST", Uri.parse('https://ipfs.infura.io:5001/api/v0/add'));
    // var request =  http.post();
    http.MultipartFile multipartFile = await http.MultipartFile.fromString("files", "hello");
    request.files.add(multipartFile);
    http.StreamedResponse response = await request.send();

    // var p = jsonDecresponse);

    // var hash = p['Hash'];
    print(response);
    print(response.statusCode);
    final respStr = await response.stream.bytesToString();
    print(respStr);
  }

  void performUserRegistered() {
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Vaccination'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text('push IPFS'),
                        onPressed: () => {
                          // Navigator.pushNamed(context, '/vaccinationStatus');
                          postaoao()
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Registration'),
                        onPressed: () =>
                            {Navigator.pushNamed(context, '/registration')},
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Stats'),
                        onPressed: () =>
                            {Navigator.pushNamed(context, '/stats')},
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Wallet Setup'),
                        onPressed: () =>
                            {Navigator.pushNamed(context, '/newWallet')},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
