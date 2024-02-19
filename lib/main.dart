// ignore_for_file: prefer_const_constructors
import 'package:animator/Controller/Provider/galaxy_provider.dart';
import 'package:animator/View/details_page.dart';
import 'package:animator/View/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Controller/Provider/theme_provider.dart';
import 'View/favorite_page.dart';
import 'View/home_page.dart';
import 'View/splash_screen.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(create: (context) => GalaxyProvider())
      ],
      child: Consumer<ThemeProvider>(
        builder: (BuildContext context, ThemeProvider value, Widget? child) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            themeMode: (value.isDark) ? ThemeMode.dark : ThemeMode.light,
            // themeMode: ThemeMode.dark,
            darkTheme: ThemeData.dark().copyWith(
              useMaterial3: true,
              // Customize dark theme properties as needed
            ),
            // Light theme (you can customize this as well)
            theme: ThemeData.light().copyWith(
                // Customize light theme properties as needed
                ),
            routes: {
              '/': (context) => SplashScreen(),
              'home_page': (context) => HomePage(),
              'detail_page': (context) => DetailsPage(),
              'favorite_page': (context) => FavoritePage(),
              'setting_page': (context) => SettingPage(),
            },
          );
        },
      ),
    );
  }
}
