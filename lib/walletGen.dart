import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:provider/provider.dart';
import 'package:UI_scanAndVerifyApp/models/contractLinking.dart';

// ignore: must_be_immutable
class NewWallet extends StatefulWidget {
  const NewWallet({Key? key, required this.storage}) : super(key: key);
  final WalletStorage storage;
  @override
  _NewWalletState createState() => _NewWalletState();
}

class _NewWalletState extends State<NewWallet> {
  final TextEditingController _passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loginfail = false;

  Future<String> getWalletInfo() async {
    String? json = await widget.storage.readWallet();
    return json;
  }

  void createWallet() async {
    print('Creating a new key');
    EthPrivateKey privateKey = EthPrivateKey.createRandom(Random.secure());
    var wallet = Wallet.createNew(privateKey, 'password123', Random.secure(),
        scryptN: 2);
    var walletJson = wallet.toJson();
    // print(privateKey.privateKey);
    await widget.storage.storeWallet(walletJson);
    Provider.of<ContractLinking>(context).setPrivateKey(bytesToHex(privateKey.privateKey), bytesToHex(privateKey.address.addressBytes));
    //original private key before locking to a filestore
    print(EthPrivateKey.fromHex(bytesToHex(privateKey.privateKey)));
  }

  void openRecentWallet() async {
    var walletJson = await widget.storage.readWallet();
    print(walletJson);
    Wallet wallet = Wallet.fromJson(walletJson, "password123");
    Credentials unlocked = wallet.privateKey;
    Provider.of<ContractLinking>(context).setPrivateKey(bytesToHex(wallet.privateKey.privateKey),bytesToHex(wallet.privateKey.address.addressBytes));
    //unlocking the filestore and getting the private key from the json file
    print(bytesToHex(wallet.privateKey.privateKey));
  }

  void checkPassword(BuildContext context) async {
    try{
      print(_passwordController.text);
      var walletJson = await widget.storage.readWallet();
      print(walletJson);
      Wallet wallet = Wallet.fromJson(walletJson, _passwordController.text);
      String privKey = bytesToHex(wallet.privateKey.privateKey);
      String pubKey = bytesToHex(wallet.privateKey.address.addressBytes);
      print("the public key is " + bytesToHex(wallet.privateKey.address.addressBytes));
      print("the private key is " + bytesToHex(wallet.privateKey.privateKey));
      Provider.of<ContractLinking>(context, listen:false).setPrivateKey(privKey, pubKey);
      Navigator.pushNamed(context, '/home');
      // Credentials unlocked = wallet.privateKey;
      // //unlocking the filestore and getting the private key from the json file
      // print(bytesToHex(wallet.privateKey.privateKey));
    }
    catch(e){
      // setState((){
      //   loginfail = true;
      // });
      print(e.toString());
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Password is incorrect!!"+ e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(future: getWalletInfo(),
      builder: (context, snapshot){
        print(snapshot);
        if(snapshot.connectionState==ConnectionState.done){
          if(snapshot.data==""){
            return MaterialApp(
              home: Scaffold(
                appBar: AppBar(
                  title: Text('Create new wallet'),
                ),
                body: Column(
                  children: [
                    ElevatedButton(
                        child: Text('Create Now'), onPressed: () => createWallet()),
                    ElevatedButton(
                        onPressed: () => {openRecentWallet()},
                        child: Text('Open Recent')),
                  ],
                ),
              ),
            );
          }
          else{
            // print("herer");
            return MaterialApp(
              home: Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  title: Text('Enter password '),
                ),
                body: Column(
                  children: [
                    Text('Enter the password for your existing account'),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        errorText: loginfail? "Password is incorrect":null,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () => {checkPassword(context)},
                        child: Text('Submit')),
                  ],
                ),
              ),
            );
          }
        }
        else{
          return CircularProgressIndicator();
        }
      });
    }
        
    // return MaterialApp(
    //   home: Scaffold(
    //     appBar: AppBar(
    //       title: Text('New Wallet'),
    //     ),
    //     body: Column(
    //       children: [
    //         ElevatedButton(
    //             child: Text('Create Now'), onPressed: () => createWallet()),
    //         ElevatedButton(
    //             onPressed: () => {openRecentWallet()},
    //             child: Text('Open Recent')),
    //       ],
    //     ),
    //   ),
    // );
  
}

class WalletStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    // print(path);
    return File('$path/counter.txt');
  }

  Future<String> readWallet() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return '';
    }
  }

  Future<File> storeWallet(String walletData) async {
    final file = await _localFile;
    
    // Write the file
    // print('writing $walletData');
    return file.writeAsString(walletData);
  }
}
