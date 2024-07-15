import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel/screen/ride_requests/widgets/requests_list.dart';
import '../../models/ride.dart';
import '../../provider/ride_provider.dart';

class RideRequestsScreen extends StatefulWidget {
  const RideRequestsScreen({super.key});
  static const String routeName = '/ride-requests';
  @override
  State<RideRequestsScreen> createState() => _RideRequestsScreenState();
}

class _RideRequestsScreenState extends State<RideRequestsScreen> {
  Ride? _currentRide;

  @override
  void initState() {
    super.initState();
    reloadCurrentRide();
  }

  Future<void> reloadCurrentRide() async {
    setState(() {
      _currentRide = null;
    });
    final rideProvider = Provider.of<RideProvider>(context, listen: false);
    var rideAddress = rideProvider.currentRide.rideAddress;

    _currentRide = await rideProvider.getDetails(rideAddress);
    setState(() {});
  }

  void acceptRideRequestLocally(int index) {
    setState(() {
      final removedRideRequest = _currentRide!.rideRequests.removeAt(index);
      _currentRide!.riders.add(removedRideRequest);
    });
  }

  void rejectRideRequestLocally(int index) {
    setState(() {
      _currentRide!.riders.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Ride Requests")),
        body: _currentRide == null
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  backgroundColor: Colors.grey,
                  strokeWidth: 4,
                ),
              )
            : _currentRide!.rideRequests.isEmpty && _currentRide!.riders.isEmpty
                ? const Center(
                    child: Text("No requests available yet!"),
                  )
                : _currentRide!.complete
                    ? const Center(
                        child: Text("This ride is completed!",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2)),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Text(
                                "Accepted Requests",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            RequestsList(
                              currentRide: _currentRide!,
                              requestsList: _currentRide!.riders,
                              type: "accepted",
                              acceptRideRequestLocally:
                                  acceptRideRequestLocally,
                              rejectRideRequestLocally:
                                  rejectRideRequestLocally,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Text(
                                "Pending Requests",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            RequestsList(
                              currentRide: _currentRide!,
                              requestsList: _currentRide!.rideRequests,
                              type: "pending",
                              acceptRideRequestLocally:
                                  acceptRideRequestLocally,
                              rejectRideRequestLocally:
                                  rejectRideRequestLocally,
                            )
                          ],
                        ),
                      ));
  }
}
