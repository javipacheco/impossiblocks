import 'dart:async' show Future;
import 'package:impossiblocks/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferencesService {

  Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<bool> setUserId(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt('user_id', userId);
  }

  Future<int> getRecord(LeadboardGames leadboardGames) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id');
    String key = _getNameRecord(userId, leadboardGames);
    return prefs.getInt(key) ?? 0;
  }

  Future<int> getRecordByUser(LeadboardGames leadboardGames, int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = _getNameRecord(userId, leadboardGames);
    return prefs.getInt(key) ?? 0;
  }

  Future<bool> updateRecordIfNecessary(LeadboardGames leadboardGames, int record) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id');
    String key = _getNameRecord(userId, leadboardGames);
    int currentRecord = prefs.getInt(key) ?? 0;
    if (currentRecord < record) {
      prefs.setInt(key, record);
      return true;
    } else {
      return false;
    }
  }

  String _getNameRecord(int userId, LeadboardGames leadboardGames) {
    return "record_${leadboardGames}_$userId";
  }

}
