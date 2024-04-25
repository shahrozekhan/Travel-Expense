import 'dart:convert';

import 'package:flutter/services.dart';

class JsonReader {
  static Future<Map<String, dynamic>> loadData(String path) async {
    final String jsonString = await rootBundle.loadString(path);
    return jsonDecode(jsonString);
  }
}
