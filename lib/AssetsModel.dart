import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class AssetsModel extends ChangeNotifier {
  List<Asset> assets = [];
  bool isLoading = true;
  final String _rpcUrl = "http://192.168.43.226:7545";
  final String _wsUrl = "ws://192.168.43.226:7545/";

  final String _privateKey =
      "8792393247da0de7e4c98c56a3531f6d0a2d64cc872513c52e95ea8a364f64f9";

  int assetCount = 0;
  var data;

  Credentials _credentials;
  Web3Client _client;
  String _abiCode;
  EthereumAddress _contractAddress;
  EthereumAddress _ownerAddress;
  DeployedContract _contract;
  ContractFunction _assetCount;
  ContractFunction _assets;
  ContractFunction _createAsset;
  ContractEvent _AssetCreatedEvent;

  AssetsModel() {
    initiateSetup();
  }

  Future<void> initiateSetup() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("src/abis/AssetManager.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
    print(_contractAddress);
  }

  Future<void> getCredentials() async {
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
    _ownerAddress = await _credentials.extractAddress();
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "AssetManager"), _contractAddress);
    _assetCount = _contract.function("assetCount");
    _createAsset = _contract.function("createAsset");
    _assets = _contract.function("assets");
    _AssetCreatedEvent = _contract.event("AssetCreated");
    getTodos();
    // print("");
  }

  getTodos() async {
    List totalAssetsList = await _client
        .call(contract: _contract, function: _assetCount, params: []);
    BigInt totalAssets = totalAssetsList[0];
    assetCount = totalAssets.toInt();
    print(totalAssets);
    assets.clear();

    for (var i = 0; i < totalAssets.toInt(); i++) {
      var temp = await _client.call(
          contract: _contract, function: _assets, params: [BigInt.from(i)]);
      assets.add(Asset(assetCode: temp[0], assetName: temp[1]));
    }
    //print(todos[0].assetCode + " " + todos[0].taskName + " " + todos[0].theDate);
    //checkIfAssetExists("voke");
    isLoading = false;
    notifyListeners();
  }

  checkIfAssetExists(String value) {
    data = assets.where((row) => (row.assetCode == value));
    print(data.length);
    if (data.length >= 1) {
      print("true");
      return true;
    } else {
      print("false");
      return false;
    }
  }

  addAsset(String assetCodeData, String taskNameData) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _createAsset,
            parameters: [assetCodeData, taskNameData]));
    getTodos();
  }
}

class Asset {
  String assetCode;
  String assetName;
  Asset({this.assetCode, this.assetName});
}
