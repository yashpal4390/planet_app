// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Controller/Provider/galaxy_provider.dart';
import '../Controller/Provider/theme_provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
      lowerBound: 0,
      upperBound: 2 * pi,
    );
    animationController.repeat();
    var gp = Provider.of<GalaxyProvider>(context, listen: false);
    gp.getData();
  }

  @override
  Widget build(BuildContext context) {
    var gp = Provider.of<GalaxyProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites Planet"),
        centerTitle: true,
      ),
      body: (gp.favoriteList.isNotEmpty)
          ? Column(
        children: [
          Expanded(
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Consumer<GalaxyProvider>(
                  builder: (BuildContext context, value, Widget? child) {
                    return ListView.builder(
                      itemCount: gp.favoriteList.length,
                      itemBuilder: (context, index) {
                        var planet = gp.favoriteList[index];
                        return Container(
                          height: MediaQuery.of(context).size.height / 6,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: themeProvider.isDark
                                ? Colors.black
                                : Colors.white, // Change the color based on the theme
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedBuilder(
                                animation: animationController,
                                child: Image.asset(
                                  planet.image ?? "",
                                  height: MediaQuery.of(context).size.height / 5,
                                  width: MediaQuery.of(context).size.width / 5,
                                ),
                                builder: (context, widget) {
                                  return Transform.rotate(
                                    angle: animationController.value,
                                    child: widget,
                                  );
                                },
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        planet.name ?? "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: themeProvider.isDark
                                              ? Colors.white
                                              : Colors.black, // Change the text color based on the theme
                                        ),
                                      ),
                                      Text(
                                        'Distance from Sun: ${planet.distance}',
                                      ),
                                      Text('Radius: ${planet.radius}'),
                                      Text('velocity: ${planet.velocity}'),
                                    ],
                                  ),
                                ),
                              ),
                              Center(
                                  child: IconButton(
                                      onPressed: () {
                                        value.removeFavorite(index);
                                        value.saveData();
                                      },
                                      icon: Icon(Icons.delete)))
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      )
          : Center(child: Text("You Still not added any Planet to Favorite")),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
