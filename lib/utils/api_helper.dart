import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ApiHelper {
  static Future<Map<String, dynamic>> loadConfig() async {
    //-----json with custom appbar as given in reference image-----
    String jsonString = await rootBundle.loadString('assets/jsons/config.json');

    //----UnComment below for get response from json with dynamic appbar of scaffold----
    // String jsonString =
    //     await rootBundle.loadString('assets/jsons/appbar_json.json');

    var response = json.decode(jsonString);
    debugPrint("Response=>$response");
    return response;
  }
}
