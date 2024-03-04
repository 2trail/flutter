
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../WaterPage/FixedLightChart4Water.dart';

class WaterPage extends StatefulWidget {
  const WaterPage({Key? key}) : super(key: key);

  @override
  State<WaterPage> createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterPage> {

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
                    child: FixedLineChartWidget4Water(),
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
