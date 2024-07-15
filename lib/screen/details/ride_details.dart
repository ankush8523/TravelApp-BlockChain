import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:travel/helper/notification_helper.dart';
import 'package:travel/helper/sharedpreferences_helper.dart';
import 'package:travel/provider/ride_provider.dart';
import 'package:travel/screen/details/widgets/key_value_row.dart';
import 'package:travel/screen/driver_details/driver_details_screen.dart';
import 'package:web3dart/json_rpc.dart';
import 'package:web3dart/web3dart.dart';
import '../../helper/currency_convert.dart';
import '../../models/ride.dart';
import '../../provider/user_details_provider.dart';
import '../ride_requests/ride_requests_screen.dart';
import 'package:geocoding/geocoding.dart';

class RideDetails extends StatefulWidget {
  const RideDetails({super.key});
  static const String routeName = '/ride-details';

  @override
  State<RideDetails> createState() => _RideDetailsState();
}

class _RideDetailsState extends State<RideDetails> {
  bool isAccepted = false;
  bool isFinalized = false;
  bool isCompleted = false;
  bool isLoaded = false;
  Ride? _currentRide;
  String pickupPlacemark = "";
  String dropPlacemark = "";

  @override
  void initState() {
    super.initState();
    reloadCurrentRide();
  }

  Future<void> reloadCurrentRide() async {
    final rideProvider = Provider.of<RideProvider>(context, listen: false);
    var rideAddress = rideProvider.currentRide.rideAddress;

    List<Future> futures = [
      rideProvider.getDetails(rideAddress).then((value) {
        setState(() {
          _currentRide = value;
        });
      }),
      rideProvider
          .isRequestAccepted(rideProvider.currentRide.rideAddress)
          .then((value) => setState(() => {
                isLoaded = true,
                isAccepted = value,
              })),
      rideProvider
          .isFinalizedBy(rideProvider.currentRide.rideAddress,
              EthereumAddress.fromHex(walletAddress))
          .then((value) => setState(() => {
                isLoaded = true,
                isFinalized = value,
              })),
      rideProvider
          .isCompletedBy(rideProvider.currentRide.rideAddress,
              EthereumAddress.fromHex(walletAddress))
          .then((value) => setState(() => {
                isLoaded = true,
                isCompleted = value,
              }))
    ];
    await Future.wait(futures);
  }

  final String walletAddress = SharedPreferencesHelper.getString(
      SharedPreferencesHelper.metamaskWalletAddress)!;

  final String userContractAddress = SharedPreferencesHelper.getString(
      SharedPreferencesHelper.userContractAddress)!;

  void showSnackBar(BuildContext ctx, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void finalizeRide(BuildContext ctx, RideProvider rideProvider) async {
    final userDetailsProvider =
        Provider.of<UserDetailsProvider>(context, listen: false);
    try {
      await rideProvider.finalizeRide(
          rideProvider.currentRide.rideAddress,
          EtherAmount.fromBigInt(
              EtherUnit.wei, rideProvider.currentRide.costToRide));

      final driverToken =
          await userDetailsProvider.getFirebaseToken(_currentRide!.driver);

      setState(() {
        isFinalized = true;
      });

      NotificationHelper.sendNotificationTo(
        driverToken,
        "Ride finalized by ${userDetailsProvider.currentUser!.firstName}",
        "Ride from ${_currentRide!.pickupLocation} to ${_currentRide!.dropLocation} is finalized by ${userDetailsProvider.currentUser!.firstName}",
      );
    } on RPCError catch (e) {
      showSnackBar(ctx, e.message);
    }
  }

  void sendRideRequest(BuildContext ctx, RideProvider rideProvider) async {
    final userDetailsProvider =
        Provider.of<UserDetailsProvider>(context, listen: false);
    try {
      await rideProvider.sendRideRequest(rideProvider.currentRide.rideAddress,
          EthereumAddress.fromHex(userContractAddress));
      final driverToken =
          await userDetailsProvider.getFirebaseToken(_currentRide!.driver);
      setState(() {
        _currentRide!.isRequested = true;
      });
      NotificationHelper.sendNotificationTo(
        driverToken,
        "You got a new ride request from ${userDetailsProvider.currentUser!.firstName}",
        "Confirm ride from ${_currentRide!.pickupLocation} to ${_currentRide!.dropLocation}",
      );
    } on RPCError catch (e) {
      showSnackBar(ctx, e.message);
    }
  }

  void completeRide(BuildContext ctx, RideProvider rideProvider) async {
    final userDetailsProvider =
        Provider.of<UserDetailsProvider>(context, listen: false);
    try {
      await rideProvider.completeRide(rideProvider.currentRide.rideAddress);

      final currentUserAddress = SharedPreferencesHelper.getString(
          SharedPreferencesHelper.metamaskWalletAddress)!;

      if (currentUserAddress == _currentRide!.driver.hexEip55) {
        for (var rider in _currentRide!.riders) {
          final riderToken = await userDetailsProvider.getFirebaseToken(rider);
          NotificationHelper.sendNotificationTo(
            riderToken,
            "Ride completed by ${userDetailsProvider.currentUser!.firstName}",
            "Completed ride from ${_currentRide!.pickupLocation} to ${_currentRide!.dropLocation} by ${userDetailsProvider.currentUser!.firstName}",
          );
        }
      } else {
        final driverToken =
            await userDetailsProvider.getFirebaseToken(_currentRide!.driver);
        NotificationHelper.sendNotificationTo(
          driverToken,
          "Ride completed by ${userDetailsProvider.currentUser!.firstName}",
          "Completed ride from ${_currentRide!.pickupLocation} to ${_currentRide!.dropLocation} by ${userDetailsProvider.currentUser!.firstName}",
        );
      }

      setState(() {
        isCompleted = true;
      });
    } on RPCError catch (e) {
      showSnackBar(ctx, e.message);
    }
  }

  void cancleRide(BuildContext ctx, RideProvider rideProvider) async {
    final userDetailsProvider =
        Provider.of<UserDetailsProvider>(context, listen: false);

    try {
      if (isAccepted) {
        await rideProvider
            .cancleAcceptedRideRequest(rideProvider.currentRide.rideAddress);
      } else {
        await rideProvider
            .cancleRideRequest(rideProvider.currentRide.rideAddress);
      }

      final driverToken =
          await userDetailsProvider.getFirebaseToken(_currentRide!.driver);
      setState(() {
        _currentRide!.isRequested = false;
      });

      NotificationHelper.sendNotificationTo(
        driverToken,
        "Ride cancelled by ${userDetailsProvider.currentUser!.firstName}",
        "Cancelled ride from ${_currentRide!.pickupLocation} to ${_currentRide!.dropLocation} by ${userDetailsProvider.currentUser!.firstName}",
      );
    } on RPCError catch (e) {
      showSnackBar(ctx, e.message);
    }
  }

  openMapsSheet(context) async {
    try {
      final rideProvider = Provider.of<RideProvider>(context, listen: false);
      List<String> coordinates = rideProvider.currentRide.landmark.split(",");
      final origin =
          Coords(double.parse(coordinates[0]), double.parse(coordinates[1]));
      final destination =
          Coords(double.parse(coordinates[2]), double.parse(coordinates[3]));
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Wrap(
                children: <Widget>[
                  for (var map in availableMaps)
                    ListTile(
                      onTap: () => map.showDirections(
                          destination: destination, origin: origin),
                      title: Text(map.mapName),
                      leading: SvgPicture.asset(
                        map.icon,
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rideProvider = Provider.of<RideProvider>(context);
    final userDetailsProvider = Provider.of<UserDetailsProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            _currentRide == null
                ? "Loading..."
                : "Ride From ${_currentRide!.pickupLocation} to ${_currentRide!.dropLocation}",
          ),
        ),
        body: _currentRide == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: reloadCurrentRide,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Card(
                    elevation: 5,
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            KeyValueRow(
                                keyName: "Ride from",
                                keyValue: _currentRide!.pickupLocation),
                            const SizedBox(
                              height: 10,
                            ),
                            KeyValueRow(
                                keyName: "Ride to",
                                keyValue: _currentRide!.dropLocation),
                            const SizedBox(
                              height: 10,
                            ),
                            KeyValueRow(
                              keyName: "Travel Date",
                              keyValue: _currentRide!.rideDate,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            KeyValueRow(
                              keyName: "Ride cost",
                              keyValue: convertToSmallestUnit(
                                  _currentRide!.costToRide),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            KeyValueRow(
                                keyName: "Driver Address",
                                keyValue: _currentRide!.driver.hexEip55),
                            const SizedBox(
                              height: 15,
                            ),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.map_rounded),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green, elevation: 5),
                              onPressed: () => openMapsSheet(context),
                              label: const Text('Show on Map',
                                  style: TextStyle(fontFamily: "Montserrat")),
                            ),
                            walletAddress != _currentRide!.driver.hexEip55
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.person),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            elevation: 5),
                                        onPressed: () {
                                          userDetailsProvider
                                              .setOtherUserAddress(
                                                  _currentRide!.driver);
                                          Navigator.pushNamed(context,
                                              DriverDetailsScreen.routeName);
                                        },
                                        label: const Text('Driver details',
                                            style: TextStyle(
                                                fontFamily: "Montserrat")),
                                      ),
                                      if (_currentRide!.isRequested)
                                        isFinalized
                                            ? ElevatedButton.icon(
                                                onPressed:
                                                    (rideProvider.isLoading ||
                                                            isCompleted)
                                                        ? null
                                                        : () {
                                                            completeRide(
                                                                context,
                                                                rideProvider);
                                                          },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                    elevation: 5),
                                                icon: rideProvider.isLoading
                                                    ? Container(
                                                        width: 24,
                                                        height: 24,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child:
                                                            const CircularProgressIndicator(
                                                          color: Colors.white,
                                                          strokeWidth: 3,
                                                        ),
                                                      )
                                                    : const Icon(
                                                        Icons.directions_car),
                                                label: const Text('Complete',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Montserrat")),
                                              )
                                            : ElevatedButton.icon(
                                                onPressed:
                                                    (rideProvider.isLoading ||
                                                            _currentRide!
                                                                .complete ||
                                                            !isAccepted ||
                                                            isFinalized)
                                                        ? null
                                                        : () {
                                                            finalizeRide(
                                                                context,
                                                                rideProvider);
                                                          },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                    elevation: 5),
                                                icon: rideProvider.isLoading
                                                    ? Container(
                                                        width: 24,
                                                        height: 24,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child:
                                                            const CircularProgressIndicator(
                                                          color: Colors.white,
                                                          strokeWidth: 3,
                                                        ),
                                                      )
                                                    : const Icon(
                                                        Icons.directions_car),
                                                label: const Text(
                                                    'Finalize Ride',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Montserrat")),
                                              ),
                                      if (!_currentRide!.isRequested)
                                        ElevatedButton.icon(
                                          onPressed: rideProvider.isLoading ||
                                                  _currentRide!.complete
                                              ? null
                                              : () {
                                                  sendRideRequest(
                                                      context, rideProvider);
                                                },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              elevation: 5),
                                          icon: rideProvider.isLoading
                                              ? Container(
                                                  width: 24,
                                                  height: 24,
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child:
                                                      const CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 3,
                                                  ),
                                                )
                                              : const Icon(
                                                  Icons.directions_car),
                                          label: const Text('Request ride',
                                              style: TextStyle(
                                                  fontFamily: "Montserrat")),
                                        ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                        ElevatedButton.icon(
                                          icon:
                                              const Icon(Icons.directions_car),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black,
                                              elevation: 5),
                                          onPressed: () {
                                            Navigator.pushNamed(context,
                                                RideRequestsScreen.routeName);
                                          },
                                          label: const Text(
                                            'Ride Requests',
                                            style: TextStyle(
                                                fontFamily: "Montserrat"),
                                          ),
                                        ),
                                        if (_currentRide!.finalized)
                                          ElevatedButton.icon(
                                            onPressed: (rideProvider
                                                        .isLoading ||
                                                    isCompleted)
                                                ? null
                                                : () {
                                                    completeRide(
                                                        context, rideProvider);
                                                  },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                elevation: 5),
                                            icon: rideProvider.isLoading
                                                ? Container(
                                                    width: 24,
                                                    height: 24,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child:
                                                        const CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 3,
                                                    ),
                                                  )
                                                : const Icon(
                                                    Icons.directions_car),
                                            label: const Text('Complete',
                                                style: TextStyle(
                                                    fontFamily: "Montserrat")),
                                          )
                                      ]),
                            if (!isFinalized &&
                                isLoaded &&
                                walletAddress !=
                                    _currentRide!.driver.hexEip55 &&
                                _currentRide!.isRequested)
                              ElevatedButton.icon(
                                icon: const Icon(Icons.car_crash),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red, elevation: 5),
                                onPressed: rideProvider.isLoading
                                    ? null
                                    : () {
                                        cancleRide(context, rideProvider);
                                      },
                                label: const Text('Cancle Ride',
                                    style: TextStyle(fontFamily: "Montserrat")),
                              ),
                            if (_currentRide!.complete && isLoaded)
                              Card(
                                color: Colors.lightGreen,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Center(
                                    child: Text(
                                      'This ride is completed!',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontFamily: "Montserrat"),
                                    ),
                                  ),
                                ),
                              ),
                            if (!isAccepted &&
                                isLoaded &&
                                walletAddress !=
                                    _currentRide!.driver.hexEip55 &&
                                _currentRide!.isRequested)
                              Card(
                                color: Colors.grey,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Center(
                                    child: Text(
                                      "Please wait while driver accpets your request",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontFamily: "Montserrat"),
                                    ),
                                  ),
                                ),
                              )
                          ],
                        )),
                  ),
                ),
              ));
  }
}
