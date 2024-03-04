import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:SmartFarming/BarPages/DeviceManagerBar.dart';
import 'package:SmartFarming/BarPages/HomeBar.dart';
import 'package:SmartFarming/BarPages/SettingsBar.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int barIndex = 0;
  var pagelist = [HomeBar(),DeviceManagerBar(),SettingsBar()];

  static const brown = 0XFFB99470;
  static const beige = 0XFFFEFAE0;
  static const greenL = 0XFFA9B388;
  static const greenD = 0XFF5F6F52;


  //bottom navigation bar parameters starts:

  var snakeBarStyle = SnakeBarBehaviour.floating;
  //var snakeBarStyle = SnakeBarBehaviour.pinned;

  var snakeShape = SnakeShape.circle;

  var padding = const EdgeInsets.all(12);
  //var padding = EdgeInsets.zero;

  var bottomBarShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
  //var bottomBarShape = const RoundedRectangleBorder();
  //var bottomBarShape = const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25),));

  var showSelectedLabels = false;
  var showUnselectedLabels = false;
  Color selectedColor = const Color(brown);
  Color unselectedColor = const Color(greenD);
  //bottom navigation bar parameters ends:
  //Color selectedColor = Colors.black;
  //   Color unselectedColor = const Color(0XFFF9B572);

//sdadad
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      //extendBodyBehindAppBar: true,
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors:[
              Color(greenL),
              Color(greenD),
            ],
            stops: [
              0.0,
              1.2,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
            //end: Alignment.bottomCenter,
          ),
        ),
        child: pagelist[barIndex],
      ),

      bottomNavigationBar:SnakeNavigationBar.color(
        // height: 80,
        backgroundColor: const Color(beige),
        behaviour: snakeBarStyle,
        snakeShape: snakeShape,
        shape: bottomBarShape,
        padding: padding,


        ///configuration for SnakeNavigationBar.color
        snakeViewColor: selectedColor,
        selectedItemColor:
        snakeShape == SnakeShape.indicator ? selectedColor : null,
        unselectedItemColor: unselectedColor,

        ///configuration for SnakeNavigationBar.gradient
        // snakeViewGradient: selectedGradient,
        // selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
        // unselectedItemGradient: unselectedGradient,

        showUnselectedLabels: showUnselectedLabels,
        showSelectedLabels: showSelectedLabels,

        currentIndex: barIndex,
        onTap: (index) => setState(() => barIndex = index),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        selectedLabelStyle: const TextStyle(fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
      ),
    );
  }
}


