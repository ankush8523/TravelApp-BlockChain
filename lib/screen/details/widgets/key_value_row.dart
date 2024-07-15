import 'package:flutter/material.dart';

class KeyValueRow extends StatelessWidget {
  final String keyName;
  final String keyValue;
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  const KeyValueRow({super.key, required this.keyName, required this.keyValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(keyName,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
                fontFamily: 'Poppins',
              )),
          const SizedBox(
            height: 5,
          ),
          Text(
            capitalize(keyValue),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, fontFamily: "Roboto"),
          ),
        ],
      ),
    );
  }
}
