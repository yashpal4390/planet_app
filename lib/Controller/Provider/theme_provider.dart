import 'package:animator/main.dart';
import 'package:flutter/foundation.dart';

class ThemeProvider extends ChangeNotifier{
  bool isDark = prefs.getBool('isDark') ?? false;

  void changeTheme(bool val) async{
    isDark = val;
    await prefs.setBool('isDark', val);
    print("==>${prefs.getBool('isDark')}");
    notifyListeners();
  }

}