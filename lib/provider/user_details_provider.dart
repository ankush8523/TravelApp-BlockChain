import 'package:flutter/foundation.dart';
import 'package:travel/contracts/ride_share_contract.dart';
import 'package:travel/helper/sharedpreferences_helper.dart';
import 'package:web3dart/web3dart.dart';
import '../contracts/ride_contract.dart';
import '../contracts/user_contract.dart';
import '../models/ride.dart';
import '../models/user.dart';

class UserDetailsProvider extends ChangeNotifier {
  User? currentUser;
  User? otherUser;
  EthereumAddress? driverAddress;
  bool isLoading = false;

  Future<String> updateUserDetails(EthereumAddress userContractAddress,
      String firstName, String lastName, String phone) async {
    isLoading = true;
    notifyListeners();

    var userContract = UserContract();
    String result = await userContract.updateUserDetails(
        userContractAddress, firstName, lastName, phone);

    isLoading = false;
    notifyListeners();
    return result;
  }

  Future<User> setUser(EthereumAddress accountAddress) async {
    var rideShareContract = RideShareContract();
    var userContract = UserContract();
    var rideContract = RideContract();

    var contractAddress = await rideShareContract.findUser(accountAddress);
    var userInfo = await userContract.userDetails(contractAddress);
    List<dynamic> previousRidesAddress = userInfo[6];
    List<Ride> result = [];

    int completedRide = 0;

    for (var rideAddress in previousRidesAddress) {
      var value = await rideContract.getDetails(rideAddress);
      if (value[6]) completedRide++;

      result.add(Ride(
          index: result.length + 1,
          pickupLocation: value[0],
          dropLocation: value[1],
          rideDate: value[2],
          landmark: value[3],
          costToRide: value[4],
          driver: value[5],
          complete: value[6],
          finalized: value[7],
          rideRequests: value[8],
          riders: value[9],
          completeAgreeCount: value[10],
          riderCountWhoFinalized: value[11],
          rideAddress: rideAddress));
    }

    isLoading = false;
    return User(
        userId: contractAddress,
        firstName: userInfo[0],
        lastName: userInfo[1],
        email: userInfo[2],
        verifed: userInfo[3],
        successfullRideCount: BigInt.from(completedRide),
        lastLoginTime: userInfo[5],
        previousRides: result,
        firebaseToken: userInfo[7]);
  }

  Future<void> setCurrentUser() async {
    String walletAddressStr = SharedPreferencesHelper.getString(
        SharedPreferencesHelper.metamaskWalletAddress)!;
    EthereumAddress accountAddress = EthereumAddress.fromHex(walletAddressStr);
    currentUser = await setUser(accountAddress);
    notifyListeners();
  }

  void setOtherUserAddress(EthereumAddress? address) async {
    driverAddress = address;
  }

  Future<void> setOtherUser() async {
    if (driverAddress == null) return;
    otherUser = await setUser(driverAddress!);
    notifyListeners();
  }

  void clearOtherUser() {
    driverAddress = null;
    otherUser = null;
  }

  Future<String> getFirebaseToken(EthereumAddress userWalletAddress) async {
    final userContractAddress =
        await RideShareContract().findUser(userWalletAddress);
    return await UserContract().getFirebaseToken(userContractAddress);
  }
}
