import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animator/Controller/Provider/galaxy_provider.dart';
import 'package:provider/provider.dart';
import 'package:animator/Controller/Provider/theme_provider.dart'; // Import the theme provider

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
    var themeProvider =
        Provider.of<ThemeProvider>(context); // Get the theme provider

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Solar System",
          style: TextStyle(
            color: themeProvider.isDark
                ? Colors.white
                : Colors
                    .black, // Change text color dynamically based on the theme
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
              return ListView.builder(
                itemCount: gp.planetList.length,
                itemBuilder: (context, index) {
                  var planet = gp.planetList[index];
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "detail_page",
                          arguments: planet);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 6,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
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
                                    ),
                                  ),
                                  Text(
                                    'Distance from Sun: ${planet.distance}',
                                  ),
                                  Text(
                                    'Radius: ${planet.radius}',
                                  ),
                                  Text(
                                    'velocity: ${planet.velocity}',
                                  ),
                                  Text(
                                    'Gravity: ${planet.gravity}',
                                  ),
                                ],
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
