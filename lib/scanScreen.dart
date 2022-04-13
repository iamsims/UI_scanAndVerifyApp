import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:eth_sig_util/util/bytes.dart';
import 'package:eth_sig_util/util/signature.dart';
import 'package:eth_sig_util/util/keccak.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';



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
  Uint8List getPersonalMessage(Uint8List message) {
    final prefix =
        '\u0019Ethereum Signed Message:\n' + message.length.toString();
    final prefixBytes = ascii.encode(prefix);
    return keccak256(Uint8List.fromList(prefixBytes + message));
  }

  verifySignature(String object) {
    final res = json.decode(object);
    for (String key in res.keys) {
      String signature = res[key][0];
      String msg = res[key][1];
      // print(signature);

      Uint8List msghash = getPersonalMessage(toBuffer(msg));
      // print(msghash);
      // String sig = EthSigUtil.signPersonalMessage(
      //     privateKey:
      //         '0x556ea9f6abff39f133a43158e0860d543e7f7d7d186d24a2e8627e3dc803686e',
      //     message: msghash);

      // print(sig);
      final ecdsa = SignatureUtil.fromRpcSig(signature);
      // print(ecdsa);

      String address =
      EthSigUtil.ecRecover(signature: signature, message: msghash);

      print(address.toUpperCase());
      if (address.toUpperCase() !=
          "0X3B9048522B3C91F213e3Aa98454502e545AD7f3B".toUpperCase()) {
        setState(() {
          qrCodeResult = "Not Authentic";
        });
        return;
      }
      qrCodeResult = "Authentic";
      // verifier.verifySignature(value, signature);
    }
  }

  String qrCodeResult = "Not Yet Scanned";
  bool flashIcon = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR Code"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Message displayed over here
            const Text(
              "Result",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              qrCodeResult,
              style: const TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20.0,
            ),

            //Button to scan QR code
            TextButton(
                onPressed: () async {
                  String barcodeScanRes =
                  await FlutterBarcodeScanner.scanBarcode(
                      "Red", "Cancel", true, ScanMode.QR);
                  setState(() {
                    qrCodeResult = barcodeScanRes;
                  });
                  verifySignature(barcodeScanRes);
                },
                child: Text(
                  "Open Scanner",
                  style: TextStyle(color: Colors.indigo[900]),
                ),
                //Button having rounded rectangle border
                style: const ButtonStyle()),
          ],
        ),
      ),
    );
  }

  // Uint8List keccak256(Uint8List uint8list) {}
}



// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:UI_scanAndVerifyApp/pendingAttributes.dart';
// import 'package:UI_scanAndVerifyApp/data.dart' as globals;
// import 'package:UI_scanAndVerifyApp/designData.dart' as designData;
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:flutter/foundation.dart';
// import 'dart:developer';
// import 'dart:io';
//
// class QRViewExample extends StatefulWidget {
//   const QRViewExample({Key? key}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => _QRViewExampleState();
// }
//
// class _QRViewExampleState extends State<QRViewExample> {
//   Barcode? result;
//   QRViewController? controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//
//   // In order to get hot reload to work we need to pause the camera if the platform
//   // is android, or resume the camera if the platform is iOS.
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller!.pauseCamera();
//     }
//     controller!.resumeCamera();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Expanded(flex: 4, child: _buildQrView(context)),
//           Expanded(
//             flex: 1,
//             child: FittedBox(
//               fit: BoxFit.contain,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   if (result != null)
//                     Text(
//                         'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
//                   else
//                     const Text('Scan a code'),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                         margin: const EdgeInsets.all(8),
//                         child: ElevatedButton(
//                             onPressed: () async {
//                               await controller?.toggleFlash();
//                               setState(() {});
//                             },
//                             child: FutureBuilder(
//                               future: controller?.getFlashStatus(),
//                               builder: (context, snapshot) {
//                                 return Text('Flash: ${snapshot.data}');
//                               },
//                             )),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.all(8),
//                         child: ElevatedButton(
//                             onPressed: () async {
//                               await controller?.flipCamera();
//                               setState(() {});
//                             },
//                             child: FutureBuilder(
//                               future: controller?.getCameraInfo(),
//                               builder: (context, snapshot) {
//                                 if (snapshot.data != null) {
//                                   return Text(
//                                       'Camera facing ${describeEnum(snapshot.data!)}');
//                                 } else {
//                                   return const Text('loading');
//                                 }
//                               },
//                             )),
//                       )
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                         margin: const EdgeInsets.all(8),
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             await controller?.pauseCamera();
//                           },
//                           child: const Text('pause',
//                               style: TextStyle(fontSize: 20)),
//                         ),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.all(8),
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             await controller?.resumeCamera();
//                           },
//                           child: const Text('resume',
//                               style: TextStyle(fontSize: 20)),
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildQrView(BuildContext context) {
//     // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
//     var scanArea = (MediaQuery.of(context).size.width < 400 ||
//             MediaQuery.of(context).size.height < 400)
//         ? 150.0
//         : 300.0;
//     // To ensure the Scanner view is properly sizes after rotation
//     // we need to listen for Flutter SizeChanged notification and update controller
//     return QRView(
//       key: qrKey,
//       onQRViewCreated: _onQRViewCreated,
//       overlay: QrScannerOverlayShape(
//           borderColor: Colors.red,
//           borderRadius: 10,
//           borderLength: 30,
//           borderWidth: 10,
//           cutOutSize: scanArea),
//       onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
//     );
//   }
//
//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         result = scanData;
//       });
//     });
//   }
//
//   void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
//     log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
//     if (!p) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('no Permission')),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }
