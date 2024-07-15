import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel/models/ride.dart';
import 'package:travel/screen/details/ride_details.dart';

import '../../../provider/ride_provider.dart';

class PreviousRideCard extends StatelessWidget {
  final Icon displayIcon;
  final Ride ride;

  const PreviousRideCard(
      {super.key, required this.displayIcon, required this.ride});

  @override
  Widget build(BuildContext context) {
    final rideProvider = Provider.of<RideProvider>(context);
    return Card(
      child: InkWell(
        onTap: () {
          rideProvider.setCurrentRideFormPreviousRideCard(ride);
          Navigator.pushNamed(context, RideDetails.routeName);
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                child: displayIcon,
              ),
              const SizedBox(
                width: 40,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TileRow(tag: "From:", value: ride.pickupLocation),
                      TileRow(tag: "To:", value: ride.dropLocation),
                      TileRow(tag: "Date:", value: ride.rideDate)
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TileRow extends StatelessWidget {
  final String tag;
  final String value;
  const TileRow({super.key, required this.tag, required this.value});

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 45,
          child: Text(
            tag,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        Text(capitalize(value)),
      ],
    );
  }
}
