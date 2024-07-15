import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static late SharedPreferences _pref;

  static const String metamaskWalletAddress = "metamask_wallet_address";
  static const String privateKey = "private_key";
  static const String userContractAddress = 'user_contract_address';

  static Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static void setString(String key, String value) async {
    await _pref.setString(key, value);
  }

  static String? getString(String key) {
    return _pref.getString(key);
  }

  static Future<bool> clear() async {
    return await _pref.clear();
  }
}
