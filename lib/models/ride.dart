import 'package:web3dart/web3dart.dart';

import '../helper/sharedpreferences_helper.dart';

class Ride {
  final EthereumAddress driver;
  final String pickupLocation;
  final String dropLocation;
  final String landmark;
  final BigInt costToRide;
  final bool complete;
  final bool finalized;
  final List<dynamic> riders;
  final String rideDate;
  final List<dynamic> rideRequests;
  final BigInt completeAgreeCount;
  final int index;
  final EthereumAddress rideAddress;
  final BigInt riderCountWhoFinalized;
  bool isRequested = false;

  Ride(
      {required this.index,
      required this.pickupLocation,
      required this.dropLocation,
      required this.riders,
      required this.driver,
      required this.rideDate,
      required this.landmark,
      required this.costToRide,
      required this.complete,
      required this.finalized,
      required this.rideRequests,
      required this.completeAgreeCount,
      required this.riderCountWhoFinalized,
      required this.rideAddress}) {
    final String walletAddress = SharedPreferencesHelper.getString(
        SharedPreferencesHelper.metamaskWalletAddress)!;

    isRequested =
        rideRequests.contains(EthereumAddress.fromHex(walletAddress)) ||
            riders.contains(EthereumAddress.fromHex(walletAddress));
  }
}
