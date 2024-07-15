import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel/screen/previous_rides/widgets/previous_ride_card.dart';

import '../../provider/user_details_provider.dart';

class PreviousRidesScreen extends StatefulWidget {
  const PreviousRidesScreen({super.key});
  static const String routeName = '/previous-rides';
  @override
  State<PreviousRidesScreen> createState() => _PreviousRidesScreenState();
}

class _PreviousRidesScreenState extends State<PreviousRidesScreen> {
  @override
  Widget build(BuildContext context) {
    final userDetailsProvider = Provider.of<UserDetailsProvider>(context);
    return Scaffold(
        appBar: AppBar(title: const Text("My Rides")),
        body: RefreshIndicator(
          onRefresh: userDetailsProvider.setCurrentUser,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 10),
                  child: const Text(
                    "My Rides",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 123, 112, 112)),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                if (userDetailsProvider.currentUser!.previousRides.isEmpty)
                  SizedBox(
                    height: 620,
                    child: Card(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Text("No Rides Available"),
                      ),
                    ),
                  ),
                ...userDetailsProvider.currentUser!.previousRides
                    .map(
                      (ride) => PreviousRideCard(
                        displayIcon: ride.complete
                            ? const Icon(
                                Icons.check_circle_outlined,
                                size: 30,
                                color: Colors.green,
                              )
                            : const Icon(
                                Icons.pending_actions,
                                size: 30,
                                color: Colors.orange,
                              ),
                        ride: ride,
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ));
  }
}
