import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:travel/helper/sharedpreferences_helper.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class EthereumUtils {
  late http.Client _httpClient;
  late Web3Client ethClient;

  final int _chainId = 11155111; //It depends on test network

  final String _infuraUrl = dotenv.env["INFURA_HTTP"]!;
  final String _infuraWSS = dotenv.env["INFURA_WSS"]!;
  final EthereumAddress? _metamaskWalletAddress =
      SharedPreferencesHelper.getString(
                  SharedPreferencesHelper.metamaskWalletAddress) !=
              null
          ? EthereumAddress.fromHex(SharedPreferencesHelper.getString(
              SharedPreferencesHelper.metamaskWalletAddress)!)
          : null;
  final String _metamaskPrivateKey =
      SharedPreferencesHelper.getString(SharedPreferencesHelper.privateKey) ??
          "";

  final String contractName;
  late String _contractAbiJsonPath;

  EthereumUtils({
    required this.contractName,
    required contractAbiJsonPath,
  }) {
    _contractAbiJsonPath = contractAbiJsonPath;
    _httpClient = http.Client();
    ethClient = Web3Client(
      _infuraUrl,
      _httpClient,
      socketConnector: () =>
          IOWebSocketChannel.connect(_infuraWSS).cast<String>(),
    );
  }

  Future<String> _getABI() async {
    String abiStringFile = await rootBundle.loadString(_contractAbiJsonPath);
    final jsonAbi = jsonDecode(abiStringFile);
    String abi = jsonEncode(jsonAbi['abi']);
    return abi;
  }

  Future<DeployedContract> getDeployedContract(
      EthereumAddress contractAddress) async {
    String contractAbi = await _getABI();
    final contract = DeployedContract(
      ContractAbi.fromJson(contractAbi, contractName),
      contractAddress,
    );
    return contract;
  }

  Future<List<dynamic>> query(
      EthereumAddress contractAddress, String functionName,
      {List<dynamic> args = const [],
      EthereumAddress? metamaskWalletAddress}) async {
    final contract = await getDeployedContract(contractAddress);
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        sender: metamaskWalletAddress ?? _metamaskWalletAddress,
        contract: contract,
        function: ethFunction,
        params: args);
    return result;
  }

  Future<String> submit(
    EthereumAddress contractAddress,
    String functionName, {
    List<dynamic> args = const [],
    EtherAmount? etherValue,
    String? metamaskPrivateKey,
  }) async {
    EthPrivateKey credential =
        EthPrivateKey.fromHex(metamaskPrivateKey ?? _metamaskPrivateKey);
    DeployedContract contract = await getDeployedContract(contractAddress);
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(
        credential,
        Transaction.callContract(
          contract: contract,
          function: ethFunction,
          parameters: args,
          value: etherValue,
        ),
        chainId: _chainId);
    return result;
  }
}
