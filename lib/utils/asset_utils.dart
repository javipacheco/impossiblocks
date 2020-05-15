import 'package:flutter/services.dart' show rootBundle;

class AssetUtils {
  static Future<bool> exist(String asset) async {
    try {
      var jsonContent = await rootBundle.load(asset);
      return jsonContent != null;
    } catch (ex) {
      return false;
    }
  }
}
