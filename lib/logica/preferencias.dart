import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
class Preferencias extends ChangeNotifier{

  Future<void> saveData(bool estado) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('gps_activo', estado);
  }

  Future<bool> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('gps_activo')??false;

  }
}
