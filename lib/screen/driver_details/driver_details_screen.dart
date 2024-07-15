import 'package:flutter/material.dart';
import 'package:travel/screen/user_details/user_details_screen.dart';

class DriverDetailsScreen extends StatefulWidget {
  static const String routeName = '/driver-details';

  const DriverDetailsScreen({super.key});

  @override
  State<DriverDetailsScreen> createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
      ),
      body: const UserDetailsScreen(
        isDriver: true,
      ),
    );
  }
}
