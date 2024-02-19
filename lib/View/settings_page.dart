// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Controller/Provider/theme_provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPAgeState();
}

class _SettingPAgeState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(15
          )
        ),
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Dark Appearance"),
            Consumer<ThemeProvider>(
              builder: (context, ThemeProvider value, child) => Switch(
                  value: value.isDark,
                  onChanged: (val) {
                    value.changeTheme(val);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
