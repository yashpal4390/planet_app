// ignore_for_file: prefer_const_constructors

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animator/Controller/Provider/galaxy_provider.dart';
import 'package:provider/provider.dart';
import 'package:animator/Controller/Provider/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
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
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Solar System",
          style: TextStyle(
            color: themeProvider.isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: MediaQuery.of(context).size.height / 6,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ListTile(
                              title: Text(
                                "Settings",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              leading: Icon(Icons.settings, size: 30),
                              onTap: () {
                                Navigator.pushNamed(context, "setting_page");
                              },
                            ),
                            ListTile(
                              title: Text(
                                "Favorites",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              leading: Icon(
                                Icons.favorite_border_outlined,
                                size: 30,
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, "favorite_page");
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          icon: Icon(Icons.menu,
              color: themeProvider.isDark ? Colors.white : Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (animationController.isAnimating) {
                animationController.stop();
              } else {
                animationController.repeat();
              }
              setState(() {});
            },
            icon: (animationController.isAnimating)
                ? Icon(
              Icons.stop,
              color: themeProvider.isDark ? Colors.white : Colors.black,
            )
                : Icon(Icons.play_arrow,
                color: themeProvider.isDark ? Colors.white : Colors.black),
          )
        ],
      ),
      body: Consumer<ThemeProvider>(
        builder: (BuildContext context, ThemeProvider value, Widget? child) =>
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: (value.isDark)
                      ? AssetImage("assets/gifs/BackgroundBlack.gif")
                      : AssetImage("assets/gifs/white.gif"),
                  fit: BoxFit.cover,
                ),
              ),
              child: FutureBuilder(
                future: gp.loadJson(),
                builder: (context, snapshot) {
                  return GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: gp.planetList.length,
                    itemBuilder: (context, index) {
                      var planet = gp.planetList[index];
                      // Generate a unique tag for each Hero
                      String heroTag = planet.image ?? "";

                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "detail_page",
                              arguments: [planet,heroTag]);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15),
                                  ),
                                  child: AnimatedBuilder(
                                    animation: animationController,
                                    child: Hero(
                                      tag: heroTag,
                                      child: Image.asset(
                                        planet.image ?? "",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    builder: (context, widget) {
                                      return Transform.rotate(
                                        angle: animationController.value,
                                        child: widget,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Center(
                                child: Text(
                                  planet.name ?? "",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 5),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    'Read More ==>',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
