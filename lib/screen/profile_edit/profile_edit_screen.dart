import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

import '../../helper/sharedpreferences_helper.dart';
import '../../provider/user_details_provider.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});
  static const String routeName = '/edit-profile';

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final currentUser =
          Provider.of<UserDetailsProvider>(context, listen: false).currentUser;
      firstNameController.text = currentUser!.firstName;
      lastNameController.text = currentUser.lastName;
      phoneController.text = currentUser.email;
    });
  }

  Future<void> updateProfile() async {
    final userContractAddress = SharedPreferencesHelper.getString(
        SharedPreferencesHelper.userContractAddress)!;
    final userDetailsProvider =
        Provider.of<UserDetailsProvider>(context, listen: false);
    await userDetailsProvider.updateUserDetails(
        EthereumAddress.fromHex(userContractAddress),
        firstNameController.text,
        lastNameController.text,
        phoneController.text);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final userDetailsProvider = Provider.of<UserDetailsProvider>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(title: const Text("Profile Edit")),
          body: SingleChildScrollView(
              child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.edit_note_outlined,
                    size: 125,
                    color: Colors.blue.shade500,
                  ),
                ),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15.0,
                          ),
                          const Text(
                            'First Name :',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins"),
                          ),
                          TextFormField(
                            autofocus: false,
                            controller: firstNameController,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.person,
                                ),
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 15.0, 20.0, 15.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          const Text(
                            'Last Name :',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins"),
                          ),
                          TextFormField(
                            autofocus: false,
                            controller: lastNameController,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.person_2_outlined,
                                ),
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 15.0, 20.0, 15.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          const Text(
                            'Phone :',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins"),
                          ),
                          TextFormField(
                            autofocus: false,
                            controller: phoneController,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.phone_android,
                                ),
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 15.0, 20.0, 15.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ]),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  onPressed:
                      userDetailsProvider.isLoading ? null : updateProfile,
                  textColor: Colors.black,
                  color: Colors.blue,
                  height: 45,
                  minWidth: 600,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      userDetailsProvider.isLoading
                          ? "Please Wait..."
                          : "Update",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Montserrat"),
                    ),
                  ),
                )
              ],
            ),
          ))),
    );
  }
}
