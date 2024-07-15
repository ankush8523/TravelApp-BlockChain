import 'package:travel/contracts/eth_utils.dart';
import 'package:web3dart/web3dart.dart';

class UserContract extends EthereumUtils {
  UserContract()
      : super(
          contractName: "User",
          contractAbiJsonPath: "build/contracts/User.json",
        );

  Future<List<dynamic>> userDetails(EthereumAddress contractAddress) async {
    String functionName = "userDetails";
    return super.query(contractAddress, functionName);
  }

  Future<String> updateUserDetails(EthereumAddress contractAddress,
      String firstName, String lastName, String phone) {
    String functionName = "updateUserDetails";
    return super.submit(contractAddress, functionName,
        args: [firstName, lastName, phone]);
  }

  Future<String> getFirebaseToken(EthereumAddress contractAddress) async {
    String functionName = "firebaseToken";
    List<dynamic> res = await super.query(contractAddress, functionName);
    return res[0];
  }

  Future<String> setFirebaseToken(
    EthereumAddress contractAddress,
    String firebaseToken,
    String metamaskPrivateKey,
  ) async {
    String functionName = "setFirebaseToken";
    return super.submit(
      contractAddress,
      functionName,
      args: [firebaseToken],
      metamaskPrivateKey: metamaskPrivateKey,
    );
  }
}
