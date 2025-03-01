// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum CachedProperty {
  travelData('travelData'),
  userData('userData');

  final String name;
  const CachedProperty(this.name);
}

Map<CachedProperty, String> _cacheProperties = {
  CachedProperty.travelData: 'cachingTravelApi',
  CachedProperty.userData: 'cachingUserApi'
};

void setCachingTravelApi(
    CachedProperty key, Map<String, dynamic>? apiData) async {
  try {
    if (apiData != null) {
      String encodedJson = jsonEncode(apiData);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString(_cacheProperties[key]!, encodedJson);
    }
  } catch (error) {
    print(error);
  }
}

Future<List<Map<String, dynamic>>?> getCachingTravelApi(
    CachedProperty key) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? data = pref.getString(_cacheProperties[key]!);

  try {
    if (data != null) {
      Map<String, dynamic> jsonData = jsonDecode(data);
      List<Map<String, dynamic>> dataList =
          List<Map<String, dynamic>>.from(jsonData['data']);
      print('🔴 Cached Data => $dataList');
      return dataList;
    }
  } catch (error) {
    print("Cache Error: $error");
  }
  return null;
}
