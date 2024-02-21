// ignore_for_file: prefer_const_constructors
import 'dart:math';
import 'package:animator/Controller/Provider/theme_provider.dart';
import 'package:animator/Modal/planet_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Controller/Provider/galaxy_provider.dart';

class DetailsPage extends StatefulWidget {
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Planet modal;
  late String hero;
  @override
  void initState() {
    super.initState();
    var gp = Provider.of<GalaxyProvider>(context, listen: false);
    gp.getData();
  }

  @override
  void didChangeDependencies() {
    final List args = ModalRoute.of(context)!.settings.arguments as List;
    modal = args[0];
    hero = args[1];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<ThemeProvider>(
          builder: (BuildContext context, ThemeProvider value, Widget? child) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: (value.isDark)
                      ? AssetImage("assets/gifs/BackgroundBlack.gif")
                      : AssetImage("assets/gifs/white.gif"),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Consumer<ThemeProvider>(
                          builder:
                              (BuildContext context, value, Widget? child) {
                            return IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                                print("BACK==>");
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                              ),
                            );
                          },
                        ),
                        Consumer<GalaxyProvider>(
                          builder:
                              (BuildContext context, value, Widget? child) {
                            return IconButton(
                              onPressed: () {
                                if (value.isFavorite(modal)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Already in favorites'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Added to favorites'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                                value.addFavorite(modal);
                                value.saveData();
                              },
                              icon: (value.isFavorite(modal))
                                  ? Icon(Icons.favorite)
                                  : Icon(Icons.favorite_border_outlined),
                            );
                          },
                        ),
                      ],
                    ),
                    TweenAnimationBuilder(
                      tween: Tween<double>(
                        begin: 0,
                        end: 2 * pi,
                      ),
                      duration: const Duration(seconds: 16),
                      child: Hero(
                        tag: hero,
                        child: Image.asset(
                          modal.image ?? "",
                        ),
                      ),
                      builder: (context, value, widget) {
                        return Transform.rotate(
                          angle: value,
                          child: widget,
                        );
                      },
                    ),
                    Container(
                      height: MediaQuery.sizeOf(context).height / 4,
                      width: MediaQuery.sizeOf(context).width / 1.2,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              "${modal.name}",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              "${modal.type}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              "Radius:~ ${modal.radius}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              "Orbital Period:~ ${modal.orbitalPeriod}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              "Gravity:~ ${modal.gravity}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              "Velocity:~ ${modal.velocity}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, bottom: 5),
                            child: Text(
                              "Distance:~ ${modal.distance}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "Details :~ ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "${modal.description}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
