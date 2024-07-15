import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:travel/helper/notification_helper.dart';
import 'package:travel/helper/sharedpreferences_helper.dart';
import 'package:travel/provider/auth_provider.dart';
import 'package:travel/provider/user_details_provider.dart';
import 'package:travel/screen/create/ride.dart';
import 'package:travel/screen/dashboard/ride_screen.dart';
import 'package:travel/screen/details/ride_details.dart';
import 'package:travel/screen/driver_details/driver_details_screen.dart';
import 'package:travel/screen/home/home_screen.dart';
import 'package:travel/screen/previous_rides/previous_rides_screen.dart';
import 'package:travel/screen/profile_edit/profile_edit_screen.dart';
import 'package:travel/screen/ride_requests/ride_requests_screen.dart';
import 'package:travel/screen/signup/signup_screen.dart';
import 'screen/login/login_screen.dart';
import 'screen/user_details/user_details_screen.dart';
import './provider/ride_provider.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  await SharedPreferencesHelper.init();
  await NotificationHelper.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<RideProvider>(create: (_) => RideProvider()),
        ChangeNotifierProvider<UserDetailsProvider>(
            create: (_) => UserDetailsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>
            authProvider.isLoggedIn ? const HomeScreen() : const LoginScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        SignupScreen.routeName: (context) => const SignupScreen(),
        CreateRide.routeName: (context) => const CreateRide(),
        RideScreen.routeName: (context) => const RideScreen(),
        RideDetails.routeName: (context) => const RideDetails(),
        UserDetailsScreen.routeName: (context) => const UserDetailsScreen(),
        DriverDetailsScreen.routeName: (context) => const DriverDetailsScreen(),
        PreviousRidesScreen.routeName: (context) => const PreviousRidesScreen(),
        ProfileEditScreen.routeName: (context) => const ProfileEditScreen(),
        RideRequestsScreen.routeName: (context) => const RideRequestsScreen()
      },
    );
  }
}
