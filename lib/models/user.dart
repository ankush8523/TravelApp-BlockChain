import 'package:travel/models/ride.dart';
import 'package:web3dart/web3dart.dart';

class User {
  final EthereumAddress userId;
  final String firstName;
  final String lastName;
  final String email;
  final bool verifed;
  final BigInt successfullRideCount;
  final String lastLoginTime;
  final List<Ride> previousRides;
  final String firebaseToken;

  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.verifed,
    required this.successfullRideCount,
    required this.lastLoginTime,
    required this.previousRides,
    required this.firebaseToken,
  });
}
