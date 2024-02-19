import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Modal/planet_modal.dart';
import '../../main.dart';

class GalaxyProvider extends ChangeNotifier {
  List<Planet> planetList = [];
  List<Planet> favoriteList = [];
  String favoriteListJson = "";

  bool isFavorite(Planet obj) {
    return favoriteList.any((element) => element.name == obj.name);
  }

  void addFavorite(Planet planet) {
    if (isFavorite(planet)) {
      print("ALREADY");
    } else {
      favoriteList.add(planet);
      notifyListeners();
      print("LEGNTH ==>  ${favoriteList.length}");
    }
  }

  Future<void> loadJson() async {
    var fileData = await rootBundle.loadString("lib/json/planet_details.json");
    jsonDecode(fileData);
    planetList = planetFromJson(fileData);
    notifyListeners();
  }

  void removeFavorite(int index) {
    favoriteList.removeAt(index);
    notifyListeners();
  }

  void saveData() {
    favoriteListJson =
        jsonEncode(favoriteList.map((product) => product.toJson()).toList());
    prefs.setString("cart", favoriteListJson);
    print("SAVED LOCALLY");
    notifyListeners();
  }

  void getData() async {
    print("GET DATA FROM LOCAL");
    prefs = await SharedPreferences
        .getInstance(); // Obtain SharedPreferences instance
    String? cartListJson = prefs.getString('cart');
    if (cartListJson != null) {
      List<dynamic> decodedList = jsonDecode(cartListJson);
      favoriteList = decodedList.map((json) => Planet.fromJson(json)).toList();
      print(favoriteList.length);
    }
    notifyListeners();
  }
}
