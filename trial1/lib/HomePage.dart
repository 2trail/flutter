import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:trial1/BarPages/DeviceManagerBar.dart';
import 'package:trial1/BarPages/HomeBar.dart';
import 'package:trial1/BarPages/SettingsBar.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int barIndex = 0;
  var pagelist = [HomeBar(),DeviceManagerBar(),SettingsBar()];



  //bottom navigation bar parameters starts:
  //var snakeBarStyle = SnakeBarBehaviour.floating;
  var snakeBarStyle = SnakeBarBehaviour.pinned;
  var snakeShape = SnakeShape.circle;
  //var padding = const EdgeInsets.all(12);
  var padding = EdgeInsets.zero;
  //var bottomBarShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
  var bottomBarShape = const RoundedRectangleBorder();
  //var bottomBarShape = const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25),));
  var showSelectedLabels = false;
  var showUnselectedLabels = false;
  Color selectedColor = Colors.black;
  Color unselectedColor = Colors.blueGrey;
  //bottom navigation bar parameters ends:



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
              Color(0XFFFFFFFF),
              Color(0XFFb6ccd1),
            ],
            stops: [
              0.0,
              0.4,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: pagelist[barIndex],
      ),

      bottomNavigationBar:SnakeNavigationBar.color(
        // height: 80,
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
              icon: Icon(Icons.dehaze), label: 'Devices'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        selectedLabelStyle: const TextStyle(fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
      ),
    );
  }
}




/*
bottomNavigationBar:BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        //https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_headline),
            label:  "Devices",
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,),
            label:  "Settings",
            backgroundColor: Colors.black,
          ),
        ],  //items



        currentIndex: barIndex,
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.black45,
        backgroundColor: Colors.white,
        onTap: (index){
          setState(() {
            barIndex = index;
          });

        },

      ),


*/