import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:travel/helper/helpers.dart";
import "package:travel/models/ride.dart";
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import "package:travel/provider/ride_provider.dart";
import "package:travel/screen/previous_rides/widgets/previous_ride_card.dart";
import '../../../helper/currency_convert.dart';

class RideCard extends StatelessWidget {
  final Ride ride;
  const RideCard({super.key, required this.ride});

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    final rideProvider = Provider.of<RideProvider>(context);
    return InkWell(
      onTap: () {
        rideProvider.setCurrentRideIndex(ride.index);
        Navigator.pushNamed(context, "/ride-details");
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.all(7),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Text(
                convertToSmallestUnit(ride.costToRide),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                TileRow(tag: "From:", value: ride.pickupLocation),
                const SizedBox(
                  height: 5,
                ),
                TileRow(tag: "To:", value: ride.dropLocation),
                const SizedBox(
                  height: 5,
                ),
                TileRow(
                  tag: "Date",
                  value: ride.rideDate,
                ),
              ]),
            ]),
          ]),
        ),
      ),
    );
  }
}
