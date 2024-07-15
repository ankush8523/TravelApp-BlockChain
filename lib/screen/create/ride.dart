import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/credentials.dart';
import '../../custom_modal_sheet.dart';
import '../../helper/sharedpreferences_helper.dart';
import '../../helper/helpers.dart';
import '../../open_street_map.dart';
import '../../provider/ride_provider.dart';

class CreateRide extends StatefulWidget {
  const CreateRide({super.key});
  static String routeName = "/create-ride";

  @override
  State<CreateRide> createState() => _CreateRideState();
}

class _CreateRideState extends State<CreateRide> {
  final _formKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final pickupLandmarkController = TextEditingController();
  final dropLandmarkController = TextEditingController();
  final costController = TextEditingController();
  late LatLong fromCoordinates;
  late LatLong toCoordinates;

  @override
  Widget build(BuildContext context) {
    final rideProvider = Provider.of<RideProvider>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 500,
                  child: Card(
                    elevation: 5,
                    child: Container(
                      height: 500,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  onTap: () async {
                                    PickedData? location =
                                        await customBottomSheet(
                                            context, "Select Pickup Location");
                                    if (location != null) {
                                      fromController.text =
                                          Helpers.getControllerText(
                                              location.result);
                                      fromCoordinates = location.latLong;

                                      pickupLandmarkController.text =
                                          location.address;
                                    }
                                  },
                                  controller: fromController,
                                  validator: validateString,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    label: const Text(
                                      "From",
                                      style: TextStyle(fontFamily: "Poppins"),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10.0),
                                    prefixIcon: const Icon(Icons.location_on),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 2.0,
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 2.0,
                                      ),
                                    ),
                                    hintText: 'From',
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  width:
                                      5), // add some spacing between the text fields
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  onTap: () async {
                                    PickedData? location =
                                        await customBottomSheet(
                                            context, "Select Drop Location");
                                    if (location != null) {
                                      toController.text =
                                          Helpers.getControllerText(
                                              location.result);
                                      toCoordinates = location.latLong;
                                      dropLandmarkController.text =
                                          location.address;
                                    }
                                  },
                                  controller: toController,
                                  validator: validateString,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    label: const Text(
                                      "To",
                                      style: TextStyle(fontFamily: "Poppins"),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10.0),
                                    prefixIcon:
                                        const Icon(Icons.location_on_outlined),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 2.0,
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 2.0,
                                      ),
                                    ),
                                    hintText: 'To',
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: pickupLandmarkController,
                                  validator: validateString,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    label: const Text(
                                      "Pickup Landmark",
                                      style: TextStyle(fontFamily: "Poppins"),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10.0),
                                    prefixIcon:
                                        const Icon(Icons.location_city_sharp),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 2.0,
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 2.0,
                                      ),
                                    ),
                                    hintText: 'Landmark',
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: dropLandmarkController,
                                  validator: validateString,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    label: const Text(
                                      "Drop Landmark",
                                      style: TextStyle(fontFamily: "Poppins"),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10.0),
                                    prefixIcon:
                                        const Icon(Icons.location_city_sharp),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 2.0,
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 2.0,
                                      ),
                                    ),
                                    hintText: 'Drop Landmark',
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: costController,
                                  validator: validateString,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    label: const Text(
                                      "wei",
                                      style: TextStyle(fontFamily: "Poppins"),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10.0),
                                    prefixIcon:
                                        const Icon(Icons.currency_rupee),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 2.0,
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 2.0,
                                      ),
                                    ),
                                    hintText: 'wei',
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              controller: dateController,
                              validator: validateString,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                label: const Text(
                                  "Ride Date",
                                  style: TextStyle(fontFamily: "Poppins"),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 10.0),
                                prefixIcon:
                                    const Icon(Icons.calendar_month_outlined),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2.0,
                                  ),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              readOnly: true,
                              onTap: () async {
                                DatePicker.showDatePicker(
                                  context,
                                  dateFormat: 'dd MMMM yyyy HH:mm',
                                  initialDateTime: DateTime.now(),
                                  minDateTime: DateTime.now(),
                                  maxDateTime: DateTime(3000),
                                  onMonthChangeStartWithFirstDate: true,
                                  onConfirm: (dateTime, List<int> index) {
                                    DateTime selectdate = dateTime;
                                    final selIOS =
                                        DateFormat('dd MMM yyyy - HH:mm')
                                            .format(selectdate);
                                    setState(() {
                                      dateController.text = selIOS;
                                    });
                                  },
                                );
                              }),
                          const SizedBox(
                            height: 15,
                          ),
                          ElevatedButton.icon(
                            onPressed: rideProvider.isLoading
                                ? null
                                : () => create(rideProvider),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.green),
                            ),
                            icon: rideProvider.isLoading
                                ? Container(
                                    width: 24,
                                    height: 24,
                                    padding: const EdgeInsets.all(2.0),
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : const Icon(Icons.add_circle_outline),
                            label: const Text(
                              'Create Ride',
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validateString(String? value) {
    if (value!.isEmpty) {
      return 'Empty filled!!';
    } else {
      return null;
    }
  }

  void create(RideProvider rideProvider) async {
    String replyHeading = "Success";
    String replayBody = 'Ride succesfully created !';
    Color replyColor = Colors.green..shade500;
    IconData replyIcon = Icons.check_circle;
    String coordinates =
        "${fromCoordinates.latitude},${fromCoordinates.longitude},${toCoordinates.latitude},${toCoordinates.longitude}";
    if (_formKey.currentState!.validate()) {
      try {
        await rideProvider.createRide(
            fromController.text.trim(),
            toController.text.trim(),
            coordinates,
            dateController.text.toString(),
            costController.text.trim(),
            EthereumAddress.fromHex(SharedPreferencesHelper.getString(
                SharedPreferencesHelper.userContractAddress)!));
      } catch (e) {
        replyColor = Colors.red..shade500;
        replyIcon = Icons.close;
        replyHeading = "Failed";
        replayBody = 'Unable to create ride, Please try again!';
      } finally {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              // <-- SEE HERE
              title: Row(
                children: [
                  Icon(
                    replyIcon,
                    color: replyColor,
                  ),
                  Text(
                    replyHeading,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: replyColor),
                  )
                ],
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(replayBody),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }

      // ignore: use_build_context_synchronously
    }
  }
}
