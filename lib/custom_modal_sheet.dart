import 'package:flutter/material.dart';

import 'open_street_map.dart';

Future<dynamic> customBottomSheet(
    BuildContext context, String bottomText) async {
  var result = await showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 600,
        child: OpenStreetMapSearchAndPick(
          center: LatLong(19.8680502, 75.32410573190955),
          buttonColor: Colors.blue,
          buttonText: bottomText,
          onPicked: (pickedData) {
            Navigator.pop(context, pickedData);
          },
        ),
      );
    },
  );

  return result;
}
