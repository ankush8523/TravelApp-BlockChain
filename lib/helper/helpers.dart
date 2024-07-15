class Helpers {
  static String getControllerText(Map<dynamic, dynamic> result) {
    if (result['address']['city'] != null) {
      return result['address']['city'];
    } else if (result['address']['suburb'] != null) {
      return result['address']['suburb'];
    } else if (result['address']['town'] != null) {
      return result['address']['town'];
    } else if (result['address']['county'] != null) {
      return result['address']['county'];
    } else if (result['address']['village'] != null) {
      return result['address']['village'];
    }

    return "";
  }
}
