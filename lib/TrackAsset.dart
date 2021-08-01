import 'package:dsc_dapp/AssetsModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'stacked_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

class TrackAsset extends StatelessWidget {
  String barcode = "Not Scanned";
  TextEditingController bCodeValue = new TextEditingController();
  String trackMessage;

  @override
  Widget build(BuildContext context) {
    var listModel = Provider.of<AssetsModel>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.orange, //or set color with: Color(0xFF0000FF)
    ));
    return new Scaffold(
      appBar: new AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: new IconThemeData(color: Color(0xFF18D191))),
      body: Container(
        width: double.infinity,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new StakedIcons(),
            new SizedBox(
              height: 5.0,
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        //Navigator.push(
                        //context,
                        //MaterialPageRoute(
                        //builder: (context) => HomePage()));
                        //scanBarcode();

                        try {
                          FlutterBarcodeScanner.scanBarcode(
                                  "#2A99CF", "Cancel", true, ScanMode.QR)
                              .then((value) {
                            barcode = value;
                            bCodeValue..text = barcode;
                            if (listModel.checkIfAssetExists(barcode) == true) {
                              trackMessage = "asset exists";
                            } else {
                              trackMessage = "ERROR: ASSET DOES NOT EXIST";
                            }
                            showDialog(
                              context: context,
                              builder: (context) => new AlertDialog(
                                title: new Text('Message'),
                                content: Text(trackMessage),
                                actions: <Widget>[
                                  Center(
                                    child: new FlatButton(
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(); // dismisses only the dialog and returns nothing
                                      },
                                      child: new Text('OK'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                        } catch (e) {
                          barcode = "ERROR! unable to read the barcode!!";
                        }
                      },
                      child: new Container(
                          alignment: Alignment.center,
                          height: 40.0,
                          decoration: new BoxDecoration(
                              color: Color(0xFF18D191),
                              borderRadius: new BorderRadius.circular(9.0)),
                          child: new Text("Scan Barcode",
                              style: new TextStyle(
                                  fontSize: 16.0, color: Colors.white))),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // scanBarcode() async {
  //   try {
  //     FlutterBarcodeScanner.scanBarcode("#2A99CF", "Cancel", true, ScanMode.QR)
  //         .then((value) {
  //       barcode = value;
  //       bCodeValue..text = barcode;
  //     });
  //   } catch (e) {
  //     barcode = "ERROR! unable to read the barcode!!";
  //   }
  // }
}
