import "package:flutter/material.dart";
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:travel/screen/dashboard/widgets/ride_card.dart';
import '../../custom_modal_sheet.dart';
import '../../helper/helpers.dart';
import '../../open_street_map.dart';
import '../../provider/ride_provider.dart';

class RideScreen extends StatefulWidget {
  const RideScreen({super.key});
  static const String routeName = '/ride_screen';

  @override
  State<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  final _formKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  final fromController = TextEditingController();
  final toController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final rideProvider = Provider.of<RideProvider>(context);
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 240,
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
                                PickedData? location = await customBottomSheet(
                                    context, "Select Pickup Location");
                                if (location != null) {
                                  fromController.text =
                                      Helpers.getControllerText(
                                          location.result);
                                }
                              },
                              controller: fromController,
                              validator: validateString,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 10.0),
                                label: const Text(
                                  "From",
                                  style: TextStyle(fontFamily: "Poppins"),
                                ),
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
                          const SizedBox(width: 5),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              onTap: () async {
                                PickedData? location = await customBottomSheet(
                                    context, "Select Drop Location");
                                if (location != null) {
                                  toController.text = Helpers.getControllerText(
                                      location.result);
                                }
                              },
                              controller: toController,
                              validator: validateString,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 10.0),
                                prefixIcon:
                                    const Icon(Icons.location_on_outlined),
                                label: const Text(
                                  "To",
                                  style: TextStyle(fontFamily: "Poppins"),
                                ),
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
                      TextFormField(
                          controller: dateController,
                          validator: validateString,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            prefixIcon:
                                const Icon(Icons.calendar_month_outlined),
                            label: const Text(
                              "Ride Date",
                              style: TextStyle(fontFamily: "Poppins"),
                            ),
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
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2101));
                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('dd MMM yyyy').format(pickedDate);

                              setState(() {
                                dateController.text = formattedDate;
                              });
                            }
                          }),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton.icon(
                        onPressed: () => find(rideProvider),
                        //  () {
                        //   rideProvider.fetchRides(
                        //     fromController.text,
                        //     toController.text,
                        //     dateController.text,
                        //   );
                        // },
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Find Rides",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                          shadowColor: Colors.grey,
                          backgroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            rideProvider.isLoading
                ? SingleChildScrollView(
                    // child: Expanded(
                    //     child: Center(child: CircularProgressIndicator())),
                    child: SizedBox(
                      height: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Center(child: CircularProgressIndicator())
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: SizedBox(
                      height: 200,
                      child: rideProvider.rideList.isEmpty
                          ? const Center(
                              child: Text("No Rides Available"),
                            )
                          : ListView.builder(
                              itemCount: rideProvider.rideList.length,
                              itemBuilder: (bCtx, index) {
                                return RideCard(
                                  ride: rideProvider.rideList[index],
                                );
                              },
                            ),
                    ),
                  )
          ],
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

  void find(RideProvider rideProvider) {
    if (_formKey.currentState!.validate()) {
      rideProvider.fetchRides(
        fromController.text.trim(),
        toController.text.trim(),
        dateController.text,
      );
    }
  }
}
