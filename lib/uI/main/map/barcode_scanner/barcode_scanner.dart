import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../../widget/home_screen_widget/home_button.dart';

class BarcodeScanDeliveryItem extends StatefulWidget {
  const BarcodeScanDeliveryItem({
    super.key,
  });

  @override
  State<BarcodeScanDeliveryItem> createState() =>
      _BarcodeScanDeliveryItemState();
}

class _BarcodeScanDeliveryItemState extends State<BarcodeScanDeliveryItem> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  List barcodeList = [];
  List pendingList = [];
  int x = 100;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Consumer<ProviderS>(
      builder: (context, pValue, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: appliteBlue,
          title: Text(
            'Scan Orders',
            style: TextStyle(
              fontSize: 18.dp,
              color: white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: white,
              )),
        ),
        backgroundColor: const Color.fromARGB(255, 6, 57, 99),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Card(
                    elevation: 40,
                    color: Color.fromARGB(255, 29, 41, 50),
                    child: Container(
                        alignment: Alignment.center,
                        height: h / 6.5,
                        width: w / 2.5,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              'Count',
                              style: TextStyle(fontSize: 14, color: white),
                            ),
                            Text(
                              barcodeList.length.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 50,
                                color: white,
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: QRView(
                  onPermissionSet: (p0, p1) {},
                  overlay: QrScannerOverlayShape(borderRadius: 15),
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: (result != null)
                    ? Text(
                        '  Data: ${pValue.barcodeListGoogleMap}',
                        style: TextStyle(color: white, fontSize: 22),
                      )
                    : Text(
                        'Scan a code',
                        style: TextStyle(color: white, fontSize: 22),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: HomeButton(
                onTap: () {
                  Navigator.pop(context);
                },
                text: 'Save',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    List data = [];
    this.controller = controller;
    await controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;

        data = [result!.code];
      });
      if (barcodeList.contains(result!.code)) {
        FlutterRingtonePlayer().play(
          android: AndroidSounds.notification,
          ios: IosSounds.glass,
          looping: true, // Android only - API >= 28
          volume: 0.9, // Android only - API >= 28
          asAlarm: false, // Android only - all APIs
        );
        log('aaaaaaaaaaaaaaaaaaaaaadddddddddddaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
        notification().warning(
            context, 'Scan item ${result!.code} already exists in the list.');
      } else {
        log('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
        FlutterRingtonePlayer().play(
          android: AndroidSounds.notification,
          ios: IosSounds.glass,
          looping: true, // Android only - API >= 28
          volume: 0.9, // Android only - API >= 28
          asAlarm: false, // Android only - all APIs
        );
        setState(() {
          x = x - 1;
          barcodeList.add(result!.code);
          Provider.of<ProviderS>(context, listen: false).scanQnt.text =
              barcodeList.length.toString();
          Provider.of<ProviderS>(context, listen: false).barcodeListGoogleMap =
              barcodeList;
        });
      }

      // Function to add a value to the list if it doesn't already exist
    });
  }

  void addToListIfNotExists(List list, value) {
    if (list.contains(value)) {
      setState(() {
        barcodeList.add(value);
      });
    } else {}
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
