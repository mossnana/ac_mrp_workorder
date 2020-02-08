import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QrCodeScreen extends StatefulWidget {
  State<QrCodeScreen> createState() => _QrCodeScreen();
}

class _QrCodeScreen extends State<QrCodeScreen> {
  String barcode = "";

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this.barcode = barcode;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        // The user did not grant the camera permission.
      } else {
        // Unknown error.
      }
    } on FormatException {
      // User returned using the "back"-button before scanning anything.
    } catch (e) {
      // Unknown error.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('My Barcode Scanner'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.camera_alt), onPressed: scan)
          ],
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8.0),
              ),
              Text(barcode,
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            ],
          ),
        ));
  }
}
