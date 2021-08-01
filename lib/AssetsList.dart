import 'package:dsc_dapp/AssetsModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(AssetsList());

class AssetsList extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Duara SC dApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DemAssets(),
    );
  }
}

class DemAssets extends StatefulWidget {
  @override
  _DemAssets createState() => _DemAssets();
}

class _DemAssets extends State<DemAssets> {
  List<Assets> availableAssets;
  List<Assets> selectedAssets;
  bool sort;

  @override
  void initState() {
    sort = false;
    selectedAssets = [];
    super.initState();
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        availableAssets.sort((a, b) => a.taskName.compareTo(b.taskName));
      } else {
        availableAssets.sort((a, b) => b.taskName.compareTo(a.taskName));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var listModel = Provider.of<AssetsModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Duara SC - Registered Assets"),
        centerTitle: true,
      ),
      body: listModel.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: DataTable(
                    sortAscending: sort,
                    sortColumnIndex: 0,
                    columns: [
                      DataColumn(
                          label: Text("Name", style: TextStyle(fontSize: 14)),
                          numeric: false,
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              sort = !sort;
                            });
                            onSortColum(columnIndex, ascending);
                          }),
                      DataColumn(
                        label: Text("Code", style: TextStyle(fontSize: 14)),
                        numeric: false,
                      ),
                    ],
                    rows: listModel.assets
                        .map(
                          (asset) => DataRow(
                              selected: selectedAssets.contains(asset),
                              cells: [
                                DataCell(
                                  Text(asset.assetName),
                                ),
                                DataCell(
                                  Text(asset.assetCode),
                                ),
                              ]),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
    );
  }
}

class Assets {
  String taskName;
  String theDate;
  bool isCompleted;
  Assets({
    this.taskName,
    this.theDate,
    this.isCompleted,
  });
}
