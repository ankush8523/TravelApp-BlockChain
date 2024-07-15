import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:travel/contracts/eth_utils.dart';
import 'package:web3dart/web3dart.dart';

class RideShareContract extends EthereumUtils {
  final EthereumAddress _contractAddress =
      EthereumAddress.fromHex(dotenv.env["RIDE_SHARE_CONTRACT_ADDRESS"]!);

  RideShareContract()
      : super(
          contractName: "RideShare",
          contractAbiJsonPath: "build/contracts/RideShare.json",
        );

  Future<List<dynamic>> queryWithoutAddress(String functionName,
      {List<dynamic> args = const [], EthereumAddress? metamaskWalletAddress}) {
    return super.query(
      _contractAddress,
      functionName,
      args: args,
      metamaskWalletAddress: metamaskWalletAddress,
    );
  }

  Future<String> submitWtihboutAddress(
    String functionName, {
    List<dynamic> args = const [],
    EtherAmount? etherValue,
    String? metamaskPrivateKey,
  }) {
    return super.submit(
      _contractAddress,
      functionName,
      args: args,
      etherValue: etherValue,
      metamaskPrivateKey: metamaskPrivateKey,
    );
  }

  // Contract functions
  Future<EthereumAddress> getManager() async {
    String functionName = "manager";
    List<dynamic> addressList = await queryWithoutAddress(functionName);
    return addressList[0];
  }

  Future<String> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String firebaseToken,
    required String metamaskPrivateKey,
  }) {
    String functionName = "createUser";
    return submitWtihboutAddress(
      functionName,
      args: [firstName, lastName, email, firebaseToken],
      metamaskPrivateKey: metamaskPrivateKey,
    );
  }

  Future<String> createRide(
      {required String pickup,
      required String drop,
      required String landmark,
      required String date,
      required BigInt cost,
      required EthereumAddress userContractAddress}) {
    String functionName = "createRide";
    return submitWtihboutAddress(functionName,
        args: [pickup, drop, landmark, date, cost, userContractAddress]);
  }

  Future<EthereumAddress> findUser(EthereumAddress userAddress) async {
    String functionName = "findUser";
    List<dynamic> addressList = await queryWithoutAddress(
      functionName,
      args: [userAddress],
      metamaskWalletAddress: userAddress,
    );
    return addressList[0];
  }

  Future<List<dynamic>> getRidesFrom(String rideFrom) async {
    String functionName = "getRidesFrom";
    List<dynamic> response =
        await queryWithoutAddress(functionName, args: [rideFrom]);
    return response[0];
  }

  Future<List<dynamic>> getRidesTo(String rideTo) async {
    String functionName = "getRidesTo";
    List<dynamic> response =
        await queryWithoutAddress(functionName, args: [rideTo]);
    return response[0];
  }

  Future<List<dynamic>> getRidesOn(String date) async {
    String functionName = "getRidesOn";
    List<dynamic> response =
        await queryWithoutAddress(functionName, args: [date]);
    return response[0];
  }
}
