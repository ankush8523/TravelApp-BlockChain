// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/json_rpc.dart';
import '../../../helper/notification_helper.dart';
import '../../../helper/sharedpreferences_helper.dart';
import '../../../models/ride.dart';
import '../../../provider/ride_provider.dart';
import '../../../provider/user_details_provider.dart';
import '../../driver_details/driver_details_screen.dart';

class RequestsList extends StatefulWidget {
  final List<dynamic> requestsList;
  final String type;
  final String walletAddress = SharedPreferencesHelper.getString(
      SharedPreferencesHelper.metamaskWalletAddress)!;
  final Ride currentRide;
  final Function acceptRideRequestLocally;
  final Function rejectRideRequestLocally;

  RequestsList(
      {super.key,
      required this.requestsList,
      required this.type,
      required this.currentRide,
      required this.acceptRideRequestLocally,
      required this.rejectRideRequestLocally});

  @override
  State<RequestsList> createState() => _RequestsListState();
}

class _RequestsListState extends State<RequestsList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: widget.requestsList.isEmpty
          ? Center(
              child: Text(
                "No Requests",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return RequestCard(
                  riderAddress: widget.requestsList[index],
                  index: index,
                  type: widget.type,
                  currentRide: widget.currentRide,
                  requestsList: widget.requestsList,
                  acceptRideRequestLocally: widget.acceptRideRequestLocally,
                  rejectRideRequestLocally: widget.rejectRideRequestLocally,
                );
              },
              itemCount: widget.requestsList.length,
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
    );
  }
}

class RequestCard extends StatefulWidget {
  final EthereumAddress riderAddress;
  final int index;
  final String type;
  final Ride currentRide;
  final List<dynamic> requestsList;
  final Function acceptRideRequestLocally;
  final Function rejectRideRequestLocally;

  const RequestCard({
    super.key,
    required this.riderAddress,
    required this.index,
    required this.type,
    required this.currentRide,
    required this.requestsList,
    required this.acceptRideRequestLocally,
    required this.rejectRideRequestLocally,
  });

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  bool isFinalized = false;

  @override
  void initState() {
    super.initState();
    isFinalizedBy();
  }

  void showSnackBar(BuildContext ctx, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  Future<void> isFinalizedBy() async {
    final rideProvider = Provider.of<RideProvider>(context, listen: false);
    isFinalized = await rideProvider.isFinalizedBy(
        rideProvider.currentRide.rideAddress, widget.riderAddress);
    setState(() {});
  }

  Future<void> acceptRide(RideProvider rideProvider, Ride currentRide,
      int index, BuildContext ctx) async {
    final userDetailsProvider =
        Provider.of<UserDetailsProvider>(context, listen: false);
    try {
      await rideProvider.acceptRideRequest(currentRide.rideAddress, index);
      final riderToken = await userDetailsProvider
          .getFirebaseToken(currentRide.rideRequests[index]);
      widget.acceptRideRequestLocally(index);

      NotificationHelper.sendNotificationTo(
        riderToken,
        "Your ride request accepted by ${userDetailsProvider.currentUser!.firstName}",
        "Request accepted for ride from ${currentRide.pickupLocation} to ${currentRide.dropLocation} by driver",
      );
    } on RPCError catch (e) {
      print("accept ride fail");
      showSnackBar(ctx, e.message);
    }
  }

  Future<void> rejectRide(RideProvider rideProvider, Ride currentRide,
      BuildContext ctx, int index) async {
    final userDetailsProvider =
        Provider.of<UserDetailsProvider>(context, listen: false);
    try {
      await rideProvider.rejectAcceptedRideRequest(
          currentRide.rideAddress, currentRide.riders[index]);
      final riderToken = await userDetailsProvider
          .getFirebaseToken(currentRide.rideRequests[index]);

      widget.rejectRideRequestLocally(index);

      NotificationHelper.sendNotificationTo(
        riderToken,
        "Your ride request rejected by ${userDetailsProvider.currentUser!.firstName}",
        "Request rejected for ride from ${currentRide.pickupLocation} to ${currentRide.dropLocation} by driver",
      );
    } on RPCError catch (e) {
      showSnackBar(ctx, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rideProvider = Provider.of<RideProvider>(context);
    final userDetailsProvider = Provider.of<UserDetailsProvider>(context);

    return Card(
      color: Colors.white,
      borderOnForeground: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(widget.riderAddress.hexEip55),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              widget.type == "accepted"
                  ? !isFinalized
                      ? ElevetedReloadButton(
                          buttonName: "Reject",
                          handlerFunction: () async {
                            await rejectRide(rideProvider, widget.currentRide,
                                context, widget.index);
                          },
                        )
                      : Container()
                  : ElevetedReloadButton(
                      buttonName: "Accept",
                      handlerFunction: () async {
                        await acceptRide(rideProvider, widget.currentRide,
                            widget.index, context);
                      },
                    ),
              const SizedBox(width: 8),
              MaterialButton(
                  textColor: Colors.white,
                  color: Colors.black,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  onPressed: () {
                    userDetailsProvider
                        .setOtherUserAddress(widget.requestsList[widget.index]);
                    Navigator.pushNamed(context, DriverDetailsScreen.routeName);
                  },
                  child: const Text("Rider Details")),
              const SizedBox(width: 5),
            ],
          )
        ],
      ),
    );
  }
}

class ElevetedReloadButton extends StatefulWidget {
  final Function handlerFunction;
  final String buttonName;
  const ElevetedReloadButton(
      {super.key, required this.handlerFunction, required this.buttonName});

  @override
  State<ElevetedReloadButton> createState() => _ElevetedReloadButtonState();
}

class _ElevetedReloadButtonState extends State<ElevetedReloadButton> {
  bool isLoadingLocal = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoadingLocal
          ? null
          : () async {
              setState(() {
                isLoadingLocal = true;
              });

              await widget.handlerFunction();

              setState(() {
                isLoadingLocal = false;
              });
            },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            widget.buttonName == "Reject" ? Colors.red : Colors.green),
      ),
      icon: isLoadingLocal
          ? Container(
              width: 24,
              height: 24,
              padding: const EdgeInsets.all(2.0),
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
          : const Icon(Icons.directions_car),
      label: Text(widget.buttonName),
    );
  }
}
