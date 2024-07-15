import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel/provider/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/user.dart';
import '../../provider/user_details_provider.dart';
import '../previous_rides/previous_rides_screen.dart';
import '../profile_edit/profile_edit_screen.dart';
import 'package:avatars/avatars.dart';

class UserDetailsScreen extends StatefulWidget {
  final bool isDriver;
  const UserDetailsScreen({super.key, this.isDriver = false});
  static const String routeName = '/user-details';

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  User? user;
  late UserDetailsProvider userDetailsProvider;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      userDetailsProvider =
          Provider.of<UserDetailsProvider>(context, listen: false);
      if (widget.isDriver) {
        userDetailsProvider.setOtherUser();
      } else {
        userDetailsProvider.setCurrentUser();
      }
    });
  }

  @override
  void dispose() {
    userDetailsProvider.clearOtherUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userDetailsProvider = Provider.of<UserDetailsProvider>(context);
    if (widget.isDriver) {
      user = userDetailsProvider.otherUser;
    } else {
      user = userDetailsProvider.currentUser;
    }

    return user == null || userDetailsProvider.isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            onRefresh: userDetailsProvider.setCurrentUser,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: SizedBox(
                        child: Avatar(
                            name: "${user!.firstName} ${user!.lastName}",
                            elevation: 5,
                            shape: AvatarShape.circle(40),
                            backgroundColor: Colors.white,
                            placeholderColors: const [
                              Color.fromARGB(255, 207, 122, 66),
                            ]),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      elevation: 4,
                      child: Column(children: <Widget>[
                        ...ListTile.divideTiles(
                          color: Colors.grey,
                          tiles: [
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              leading: const Icon(Icons.numbers_outlined),
                              title: const Text(
                                "UserId",
                                style: TextStyle(fontFamily: "Poppins"),
                              ),
                              subtitle: Text(
                                user!.userId.hex,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 16, fontFamily: "Roboto"),
                              ),
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              leading: const Icon(Icons.person),
                              title: const Text(
                                "First Name",
                                style: TextStyle(fontFamily: "Poppins"),
                              ),
                              subtitle: Text(
                                user!.firstName,
                                style: const TextStyle(fontFamily: "Roboto"),
                              ),
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              leading: const Icon(Icons.person_2_outlined),
                              title: const Text(
                                "Last Name",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                ),
                              ),
                              subtitle: Text(
                                user!.lastName,
                                style: const TextStyle(fontFamily: "Roboto"),
                              ),
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              leading: const Icon(Icons.call),
                              title: const Text(
                                "Phone No",
                                style: TextStyle(fontFamily: "Poppins"),
                              ),
                              subtitle: Text(
                                user!.email,
                                style: const TextStyle(fontFamily: "Roboto"),
                              ),
                              trailing: TextButton(
                                  onPressed: () async {
                                    final Uri url =
                                        Uri(scheme: "tel", path: user!.email);

                                    await launchUrl(url);
                                  },
                                  child: const Text("Call")),
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              leading: const Icon(Icons.verified),
                              title: const Text(
                                "Verified",
                                style: TextStyle(fontFamily: "Poppins"),
                              ),
                              subtitle: Text(
                                user!.verifed ? "Yes" : "No",
                                style: const TextStyle(fontFamily: "Roboto"),
                              ),
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              leading: const Icon(Icons.car_repair),
                              title: const Text(
                                "Completed Rides",
                                style: TextStyle(fontFamily: "Poppins"),
                              ),
                              subtitle:
                                  Text(user!.successfullRideCount.toString()),
                            ),
                          ],
                        )
                      ]),
                    ),
                    if (!widget.isDriver)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => Navigator.pushNamed(
                                context, PreviousRidesScreen.routeName),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue, elevation: 5),
                            icon: const Icon(Icons.directions_car),
                            label: const Text(
                              'My Rides',
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => Navigator.pushNamed(
                                context, ProfileEditScreen.routeName),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green, elevation: 5),
                            icon: const Icon(Icons.edit),
                            label: const Text(
                              'Edit Profile',
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    if (!widget.isDriver)
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: _showAlertDialog,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red, elevation: 5),
                            icon: const Icon(Icons.logout),
                            label: const Text(
                              'Logout',
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      )
                  ],
                ),
              ),
            ),
          );
  }

  Future<void> _showAlertDialog() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure want to log out?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                await authProvider.logout();
                if (mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
