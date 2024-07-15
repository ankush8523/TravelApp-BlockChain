import 'package:travel/contracts/eth_utils.dart';
import 'package:web3dart/web3dart.dart';

class RideContract extends EthereumUtils {
  RideContract()
      : super(
          contractName: "Ride",
          contractAbiJsonPath: "build/contracts/Ride.json",
        );
  Future<List<dynamic>> getDetails(EthereumAddress contractAddress) async {
    String functionName = "getDetails";
    List<dynamic> rideDetails =
        await super.query(contractAddress, functionName);
    return rideDetails[0];
  }

  Future<dynamic> sendRideRequest(EthereumAddress contractAddress,
      EthereumAddress userContractAddress) async {
    String functionName = "sendRideRequest";
    var result = await super
        .submit(contractAddress, functionName, args: [userContractAddress]);
    return result[0];
  }

  Future<dynamic> acceptRideRequest(
      EthereumAddress contractAddress, BigInt requestIndex) async {
    String functionName = "acceptRideRequest";
    var result =
        await super.submit(contractAddress, functionName, args: [requestIndex]);
    return result[0];
  }

  Future<dynamic> finalizeRide(
      EthereumAddress contractAddress, EtherAmount value) async {
    String functionName = "finalizeRide";
    var result =
        await super.submit(contractAddress, functionName, etherValue: value);
    return result[0];
  }

  Future<dynamic> completeRide(EthereumAddress contractAddress) async {
    String functionName = "completeRide";
    var result = await super.submit(contractAddress, functionName);
    return result[0];
  }

  Future<dynamic> cancleRideRequest(EthereumAddress contractAddress,
      EthereumAddress userContractAddress) async {
    String functionName = "cancleRideRequest";
    var result = await super
        .submit(contractAddress, functionName, args: [userContractAddress]);
    return result[0];
  }

  Future<dynamic> cancleAcceptedRideRequest(EthereumAddress contractAddress,
      EthereumAddress userContractAddress) async {
    String functionName = "cancleAcceptedRideRequest";
    var result = await super
        .submit(contractAddress, functionName, args: [userContractAddress]);
    return result[0];
  }

  Future<dynamic> rejectAcceptedRideRequest(
      EthereumAddress contractAddress,
      EthereumAddress riderAddress,
      EthereumAddress riderContractAddress) async {
    String functionName = "rejectAcceptedRideRequest";
    var result = await super.submit(contractAddress, functionName,
        args: [riderAddress, riderContractAddress]);
    return result[0];
  }

  Future<dynamic> isFinalizedBy(
      EthereumAddress contractAddress, EthereumAddress riderAddress) async {
    String functionName = "isFinalizedBy";
    var result =
        await super.query(contractAddress, functionName, args: [riderAddress]);
    return result[0];
  }

  Future<dynamic> isRequestAccepted(EthereumAddress contractAddress) async {
    String functionName = "isRequestAccepted";
    var result = await super.query(contractAddress, functionName);
    return result[0];
  }

  Future<dynamic> isCompletedBy(
      EthereumAddress contractAddress, EthereumAddress riderAddress) async {
    String functionName = "isCompletedBy";
    var result =
        await super.query(contractAddress, functionName, args: [riderAddress]);
    return result[0];
  }
}
