
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../BarClasses/LineChartWidgetClasses.dart';

class LightPage extends StatefulWidget {
  const LightPage({Key? key}) : super(key: key);

  @override
  State<LightPage> createState() => _LightPageState();
}

class _LightPageState extends State<LightPage> {

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
                    child: LineChartWidget(),
                  ),
                ),
              ),

              /*
              //CARD graph info
              Row(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,top: 0.0,bottom: 0.0),
                    child: Card(
                        shape:RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ) ,
                        child: SizedBox(
                          height: screenHeight/7,
                          width: 244,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 0.0,left: 0.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 18.0,right: 18),
                                      child: Center(
                                          child: Icon(
                                            Icons.circle_outlined,
                                            size: 28.0, //default:24
                                            color: Color(0xff23b6e6),
                                          )
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 2.0),
                                      child: Text("Işık sensörü 1",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black
                                        ),
                                      ),
                                    ),
                                  ],
                                )

                              ],
                            ),
                          ),
                        )
                    ),
                  ),



                ],
              ),

              */
            ],
          ),
        )
      ),
    );
  }
}
