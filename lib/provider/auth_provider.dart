import 'package:flutter/material.dart';
import 'package:travel/contracts/ride_share_contract.dart';
import 'package:travel/contracts/user_contract.dart';
import 'package:travel/helper/notification_helper.dart';
import 'package:travel/helper/sharedpreferences_helper.dart';
import 'package:web3dart/json_rpc.dart';
import 'package:web3dart/web3dart.dart';

class AuthProvider extends ChangeNotifier {
  bool get isLoggedIn =>
      SharedPreferencesHelper.getString(
          SharedPreferencesHelper.userContractAddress) !=
      null;

  Future<void> loginIfUserExist(String walletAddress, String privateKey) async {
    RideShareContract rideshare = RideShareContract();
    UserContract userContract = UserContract();
    final userAddress = EthereumAddress.fromHex(walletAddress);
    final firebaseToken = await NotificationHelper.getToken();
    try {
      EthereumAddress userContractAddress =
          await rideshare.findUser(userAddress);
      await userContract.setFirebaseToken(
          userContractAddress, firebaseToken, privateKey);
      SharedPreferencesHelper.setString(
          SharedPreferencesHelper.metamaskWalletAddress, walletAddress);
      SharedPreferencesHelper.setString(
          SharedPreferencesHelper.privateKey, privateKey);
      SharedPreferencesHelper.setString(
          SharedPreferencesHelper.userContractAddress,
          userContractAddress.hexEip55);
    } on RPCError catch (_) {
      rethrow;
    }
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String metamaskWalletAddress,
    required String metamaskPrivateKey,
  }) async {
    RideShareContract rideshare = RideShareContract();
    try {
      final firebaseToken = await NotificationHelper.getToken();
      await rideshare.createUser(
        firstName: firstName,
        lastName: lastName,
        email: email,
        firebaseToken: firebaseToken,
        metamaskPrivateKey: metamaskPrivateKey,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> logout() async {
    return await SharedPreferencesHelper.clear();
  }
}
