

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'FixedLightChart4Temp.dart';

class TempPage extends StatefulWidget {
  const TempPage({Key? key}) : super(key: key);

  @override
  State<TempPage> createState() => _TempPageState();
}

class _TempPageState extends State<TempPage> {

  bool switchValue=false;
  bool autoSwitchValue=false;




  @override
  Widget build(BuildContext context) {

    var screenSize=MediaQuery.of(context);
    final double screenHeight = screenSize.size.height;
    final double screenWidth = screenSize.size.width;

    return Scaffold(
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
        child: SafeArea(
          child: Column(
            children: [
              Card(
                color: Colors.white,
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ) ,
                child: SizedBox(//todo: calculate screen size
                  width: screenWidth-24,
                  height: screenHeight < screenWidth ? screenHeight-32 : 200,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FiexedLineChartWidget4Temp(),
                  ),
                ),
              ),


            ],
          ),
        )
      ),
    );
  }
}
