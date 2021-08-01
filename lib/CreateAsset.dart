import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:dsc_dapp/AssetsModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateAsset extends StatelessWidget {
  String barcode = "Not Scanned";
  TextEditingController bCodeValue = new TextEditingController();
  TextEditingController name = new TextEditingController();

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
          iconTheme: new IconThemeData(color: Color(0xFFA2C0B6))),
      body: Container(
        width: double.infinity,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
                  child: new Text(
                    "Asset Registration",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Color(0xFFD17E18)),
                  ),
                )
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
              child: new TextField(
                decoration: new InputDecoration(labelText: 'Asset Name'),
                controller: name..text,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
              child: new TextField(
                decoration: new InputDecoration(labelText: 'Barcode value'),
                controller: bCodeValue..text,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: GestureDetector(
                onTap: () {
                  //Navigator.push(
                  //context,
                  //MaterialPageRoute(
                  //builder: (context) => HomePage()));
                  scanBarcode();
                },
                child: new Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    decoration: new BoxDecoration(
                        color: Color(0xFFD17E18),
                        borderRadius: new BorderRadius.circular(9.0)),
                    child: new Text("Scan Barcode",
                        style: new TextStyle(
                            fontSize: 20.0, color: Colors.white))),
              ),
            ),
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

                        if (listModel.checkIfAssetExists(name.text) == true) {
                          trackMessage = "ERROR! ASSET ALREADY REGISTERED";
                        } else {
                          try {
                            listModel.addAsset(barcode, name.text);
                            trackMessage = "asset created";
                          } catch (e) {
                            trackMessage = "ERROR REGISTERING THE ASSET!";
                          }
                          //listModel.addAsset(bCodeValue.text, name.text);
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
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(); // dismisses only the dialog and returns nothing
                                  },
                                  child: new Text('OK'),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: new Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          decoration: new BoxDecoration(
                              color: Color(0xFF18D191),
                              borderRadius: new BorderRadius.circular(9.0)),
                          child: new Text("Save",
                              style: new TextStyle(
                                  fontSize: 20.0, color: Colors.white))),
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

  Future<void> scanBarcode() async {
    try {
      FlutterBarcodeScanner.scanBarcode("#2A99CF", "Cancel", true, ScanMode.QR)
          .then((value) {
        barcode = value;
        bCodeValue..text = barcode;
      });
    } catch (e) {
      barcode = "ERROR! unable to read the barcode!!";
    }
  }
}
