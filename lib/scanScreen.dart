import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:eth_sig_util/util/bytes.dart';
import 'package:eth_sig_util/util/keccak.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return HomePage();
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool scanned = false;
  bool scanButtonClicked = true;
  bool flashIcon = true;
  bool approved = false;

  Uint8List getPersonalMessage(Uint8List message) {
    final prefix =
        '\u0019Ethereum Signed Message:\n' + message.length.toString();
    final prefixBytes = ascii.encode(prefix);
    return keccak256(Uint8List.fromList(prefixBytes + message));
  }

  verifySignature(String object) {

    final res = json.decode(object);
    Map info = {};
    print("hi");


    try {
      for (String key in res.keys) {
        String signature = res[key][0];
        String msg = res[key][1];
        print("hi1");

        Uint8List msghash = getPersonalMessage(toBuffer(msg));

        print(msghash.toString());
        print("signature");
        print(signature.toString());

        String address =
        EthSigUtil.ecRecover(signature: signature, message: msghash);
        print("hi2");

        print(address.toUpperCase());
        if (address.toUpperCase() ==
            "0X3B9048522B3C91F213e3Aa98454502e545AD7f3B".toUpperCase()) {
          info[key] = msg;
        }
      }
    }

    catch(e){

    }
    print(info);
    return info;
    // verifier.verifySignature(value, signature);
  }

  Map qrCodeResult = {};

  @override
  Widget build(BuildContext context) {
    return !scanned
        ? Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.all(50),
                    color: Colors.white,
                  ),
                  Center(
                    child: Icon(Icons.document_scanner_outlined, size: 60),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              child: Text("Scan QR"),
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(50, 100),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 30),
                  textStyle: const TextStyle(
                    fontSize: 24,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
              onPressed: () async {
                scanButtonClicked = true;
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ResultScreen("jpt try", true)),
                // );

                String barcodeScanRes =
                await FlutterBarcodeScanner.scanBarcode(
                    "Red", "Cancel", true, ScanMode.QR);
                setState(() {
                  print("BArcode result");
                  print("hi"+barcodeScanRes);
                  if (barcodeScanRes != "-1") {
                    scanned = true;
                    qrCodeResult = verifySignature(barcodeScanRes);
                    if (qrCodeResult.isEmpty){
                      approved = false;
                    }
                    else approved = true;
                  }
                  else {
                    scanButtonClicked = false;
                  }
                });
              },
            ),
            SizedBox(
              height: 15,
            )
          ],
        ))
        : Stack(children: [
      approved
          ? Container(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(children: [
              ProfileHeader(
                avatar: AssetImage("assets/profile_page.jpg"),
              ),
              UserInfo(qrCodeResult),
            ]),
          ))
          : Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.exclamation,
                  size: 80,
                ),
                Text(
                    "The provided information is not found \n to be approved by any known authority"),
                Text(qrCodeResult.toString())
              ])),
      Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              textStyle: const TextStyle(
                fontSize: 36,
              ),
            ),
            child: Icon(Icons.home),
            onPressed: () {
              setState(() {
                scanned = false;
              });
            },
          ))
    ]);
  }
// Uint8List keccak256(Uint8List uint8list) {}
}

//
// class ResultScreen extends StatelessWidget {
//   final String qrCodeResult;
//   final bool approved;
//
//
//   ResultScreen(this.qrCodeResult, this.approved);
//
//   List getInfo(qrCode){
//     return ["a", "b"];
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//           children:[approved?Container(
//               padding: EdgeInsets.all(10),
//               child: SingleChildScrollView(
//               child: Column(
//                   children: [
//                     ProfileHeader(
//                       avatar: AssetImage("/assets/profilepage.jpg"),
//                     ),
//
//                     UserInfo(getInfo(qrCodeResult)),
//         TextButton(
//         child: Text("Go home"),
//     onPressed: ()=>HomePage(),
//     )
//
//                   ]
//               ),
//             )
//
//           ):Center(
//           child:Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//
//             children: [
//               FaIcon(FontAwesomeIcons.exclamation,
//               size: 80,),
//               Text("The provided information is not found \n to be approved by any known authority"),
//               TextButton(
//                 child: Text("Go home"),
//                 onPressed: ()=>{HomePage()},
//               )
//             ]
//           )
//         ),
//
//
//     ]
//     );
//
//   }
// }
//

class UserInfo extends StatelessWidget {
  final Map qrCodeResult;

  UserInfo(this.qrCodeResult);

  List<ListTile> getTiles() {
    List<ListTile> tiles = [];
    qrCodeResult.forEach((key, value) {
      tiles.add(
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            // leading: Icon(Icons.my_location),
            title: Text(key),
            subtitle: Text(value),
          )
      );
    });
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            alignment: Alignment.topLeft,
          ),
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ...ListTile.divideTiles(color: Colors.grey, tiles:
                      getTiles().toList(),
                        //     [
                        //   ListTile(
                        //     contentPadding:
                        //         EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        //     // leading: Icon(Icons.my_location),
                        //     title: Text("Name"),
                        //     subtitle: Text("Simran KC"),
                        //   ),
                        //   ListTile(
                        //     contentPadding:
                        //         EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        //     // leading: Icon(Icons.my_location),
                        //     title: Text("Location"),
                        //     subtitle: Text("Kathmandu"),
                        //   ),
                        //   ListTile(
                        //     contentPadding:
                        //         EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        //     // leading: Icon(Icons.my_location),
                        //     title: Text("Citizenship Number"),
                        //     subtitle: Text("12345"),
                        //   )
                        // ]
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final ImageProvider<dynamic> avatar;

  const ProfileHeader({Key? key, required this.avatar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 60),
          child: Column(
            children: <Widget>[
              CircleAvatar(
                radius: 45,
                backgroundColor: Theme.of(context).primaryColor,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: avatar as ImageProvider<Object>?,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}