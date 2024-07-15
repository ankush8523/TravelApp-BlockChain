import 'package:flutter/material.dart';
import 'package:travel/helper/notification_helper.dart';
import 'package:travel/screen/create/ride.dart';
import 'package:travel/screen/dashboard/ride_screen.dart';
import 'package:travel/screen/user_details/user_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _bodyWidgetOptions = const <Widget>[
    CreateRide(),
    RideScreen(),
    UserDetailsScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavigationBarItemList =
      const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.add),
      label: 'Create Ride',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'Find Rides',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'User',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Travel"),
      ),
      body: _bodyWidgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavigationBarItemList,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        selectedLabelStyle: const TextStyle(
            color: Color(0xFFA67926), fontFamily: 'Poppins', fontSize: 14.0),
        onTap: _onItemTapped,
      ),
    );
  }
}
