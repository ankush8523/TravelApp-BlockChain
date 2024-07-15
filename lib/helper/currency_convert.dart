import 'dart:math';

String convertToSmallestUnit(BigInt wei) {
  if (wei >= BigInt.from(pow(10, 18))) {
    return '${wei ~/ BigInt.from(pow(10, 18))} ether';
  } else if (wei >= BigInt.from(pow(10, 15))) {
    return '${wei ~/ BigInt.from(pow(10, 15))} finney';
  } else if (wei >= BigInt.from(pow(10, 12))) {
    return '${wei ~/ BigInt.from(pow(10, 12))} szabo';
  } else if (wei >= BigInt.from(pow(10, 9))) {
    return '${wei ~/ BigInt.from(pow(10, 9))} Gwei';
  } else if (wei >= BigInt.from(pow(10, 6))) {
    return '${wei ~/ BigInt.from(pow(10, 6))} Mwei';
  } else if (wei >= BigInt.from(pow(10, 3))) {
    return '${wei ~/ BigInt.from(pow(10, 3))} kwei';
  } else {
    return '$wei wei';
  }
}
