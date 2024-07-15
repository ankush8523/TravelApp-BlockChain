import 'package:flutter/material.dart';
import 'package:travel/helper/sharedpreferences_helper.dart';
import 'package:travel/models/ride.dart';
import 'package:web3dart/web3dart.dart';
import '../contracts/ride_contract.dart';
import '../contracts/ride_share_contract.dart';
import 'package:intl/intl.dart';

class RideProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Ride> rideList = [];
  late Ride currentRide;
  bool isRequested = true;

  Future<Ride> getDetails(EthereumAddress rideAddress) async {
    RideContract contract = RideContract();
    var value = await contract.getDetails(rideAddress);
    return Ride(
        index: rideList.length + 1,
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
        rideAddress: rideAddress);
  }

  void fetchRides(String from, String to, String on) async {
    isLoading = true;
    notifyListeners();
    rideList = [];
    RideShareContract rideShare = RideShareContract();
    var ridesFrom = await rideShare.getRidesFrom(from);
    var ridesTo = await rideShare.getRidesTo(to);

    final intersection = ridesFrom.toSet()..retainAll(ridesTo.toSet());

    final availableRides = intersection.toList();
    RideContract contract = RideContract();
    for (var rideAddress in availableRides) {
      var value = await contract.getDetails(rideAddress);
      if ((value[2] as String).contains(on)) {
        rideList.add(Ride(
            index: rideList.length + 1,
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
    }
    isLoading = false;
    notifyListeners();
  }

  void setCurrentRideIndex(int index) {
    currentRide = rideList[index - 1];
    notifyListeners();
  }

  void setCurrentRideFormPreviousRideCard(Ride ride) {
    currentRide = ride;
    notifyListeners();
  }

  Future<void> sendRideRequest(
      EthereumAddress rideAddress, EthereumAddress userContractAddress) async {
    isLoading = true;
    notifyListeners();
    isRequested = true;
    var rideContract = RideContract();
    await rideContract.sendRideRequest(
        currentRide.rideAddress, userContractAddress);
    isLoading = false;
    notifyListeners();
  }

  Future<dynamic> createRide(String pickup, String drop, String landmark,
      String date, String cost, EthereumAddress userContractAddress) async {
    isLoading = true;
    notifyListeners();

    var result = await RideShareContract().createRide(
        pickup: pickup,
        drop: drop,
        landmark: landmark,
        date: date,
        cost: BigInt.from(int.parse(cost)),
        userContractAddress: userContractAddress);

    isLoading = false;
    notifyListeners();
    return result;
  }

  Future<void> acceptRideRequest(EthereumAddress rideAddress, int index) async {
    var rideContract = RideContract();
    await rideContract.acceptRideRequest(rideAddress, BigInt.from(index));
  }

  Future<void> finalizeRide(
      EthereumAddress rideAddress, EtherAmount value) async {
    isLoading = true;
    notifyListeners();

    try {
      var rideContract = RideContract();
      await rideContract.finalizeRide(rideAddress, value);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> completeRide(EthereumAddress rideAddress) async {
    isLoading = true;
    notifyListeners();

    try {
      var rideContract = RideContract();
      await rideContract.completeRide(rideAddress);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancleRideRequest(EthereumAddress rideAddress) async {
    isLoading = true;
    notifyListeners();

    try {
      var rideContract = RideContract();
      final userContractAddress = SharedPreferencesHelper.getString(
          SharedPreferencesHelper.userContractAddress)!;
      await rideContract.cancleRideRequest(
          rideAddress, EthereumAddress.fromHex(userContractAddress));
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancleAcceptedRideRequest(EthereumAddress rideAddress) async {
    isLoading = true;
    notifyListeners();

    try {
      var rideContract = RideContract();
      final userContractAddress = SharedPreferencesHelper.getString(
          SharedPreferencesHelper.userContractAddress)!;
      await rideContract.cancleAcceptedRideRequest(
          rideAddress, EthereumAddress.fromHex(userContractAddress));
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> rejectAcceptedRideRequest(
      EthereumAddress rideAddress, EthereumAddress riderAddress) async {
    isLoading = true;
    notifyListeners();

    try {
      var rideContract = RideContract();
      var rideShareContract = RideShareContract();
      final riderContractAddress =
          await rideShareContract.findUser(riderAddress);
      await rideContract.rejectAcceptedRideRequest(
          rideAddress, riderAddress, riderContractAddress);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> isFinalizedBy(
      EthereumAddress rideAddress, EthereumAddress riderAddress) async {
    var rideContract = RideContract();
    var res = await rideContract.isFinalizedBy(rideAddress, riderAddress);
    return res;
  }

  Future<bool> isRequestAccepted(EthereumAddress rideAddress) async {
    var rideContract = RideContract();
    var res = await rideContract.isRequestAccepted(rideAddress);
    return res;
  }

  Future<bool> isCompletedBy(
      EthereumAddress contractAddress, EthereumAddress riderAddress) async {
    var rideContract = RideContract();
    var res = await rideContract.isCompletedBy(contractAddress, riderAddress);
    return res;
  }
}
