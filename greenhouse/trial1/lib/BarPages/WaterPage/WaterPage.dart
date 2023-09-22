
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
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FixedLineChartWidget4Water(),
                  ),
                ),
              ),

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
                                      child: Text("Nem sensörü 1",
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




                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0,top: 0.0,bottom: 0.0),
                    child: Card(
                        shape:RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ) ,
                      child: SizedBox(
                        height: screenHeight/7,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 18.0,left: 18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0,bottom: 2.0),
                                child: SizedBox(
                                  width: 45,
                                  height: 35,
                                  child: ToggleButtons(
                                      borderRadius: BorderRadius.circular(10),
                                      constraints: BoxConstraints(minWidth:45,maxWidth: 60,minHeight:35,maxHeight:60),
                                      renderBorder: false,
                                      isSelected: [
                                        autoSwitchValue
                                      ],
                                      onPressed:(value){
                                        autoSwitchValue=!autoSwitchValue;
                                        print(autoSwitchValue);
                                        setState(() {
                                        });
                                      },
                                      children: [
                                        Icon(autoSwitchValue? Icons.check_box:Icons.check_box_outline_blank_rounded,
                                        ),
                                      ]
                                  ),
                                ),
                              ),
                              Text("El ile")
                            ],
                          ),
                        ),
                      )
                    ),
                  ),
                ],
              ),
              //CARD1
              Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 0.0,bottom: 0.0),
                child: Card(
                  shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ) ,
                  child: SizedBox(
                    height: screenHeight/7,
                    child: Row(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(left: 18.0,right: 18),
                          child: Center(
                              child: Icon(
                                Icons.water_drop_rounded,
                                size: 28.0, //default:24
                                color: Colors.grey,
                              )
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:const <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 2.0),
                              child: Text("Pompa 1",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black
                                ),
                              ),
                            ),

                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CupertinoSwitch(
                                  value: switchValue,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      print("test");
                                      switchValue = value ?? false;
                                    });
                                  }),
                              Text("Acık")
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0,bottom: 2.0),
                                child: SizedBox(
                                  width: 45,
                                  height: 35,
                                  child: ToggleButtons(
                                    borderRadius: BorderRadius.circular(10),
                                    constraints: BoxConstraints(minWidth:45,maxWidth: 60,minHeight:35,maxHeight:60),
                                    renderBorder: false,
                                      isSelected: [
                                        autoSwitchValue
                                      ],
                                      onPressed:(value){
                                        autoSwitchValue=!autoSwitchValue;
                                        print(autoSwitchValue);
                                        setState(() {
                                        });
                                      },
                                      children: [
                                        Icon(autoSwitchValue? Icons.check_box:Icons.check_box_outline_blank_rounded,
                                        ),
                                      ]
                                  ),
                                ),
                              ),
                              Text("El ile")
                            ],
                          ),
                        )

                      ],),
                  ),
                ),
              ),

              //CARD2
              Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 0.0,bottom: 0.0),
                child: Card(
                  shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ) ,
                  child: SizedBox(
                    height: screenHeight/7,
                    child: Row(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(left: 18.0,right: 18),
                          child: Center(
                              child: Icon(
                                Icons.water_drop_rounded,
                                size: 28.0, //default:24
                                color: Colors.grey,
                              )
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:const <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 2.0),
                              child: Text("Pompa 2",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black
                                ),
                              ),
                            ),

                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CupertinoSwitch(
                                  value: switchValue,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      print("test");
                                      switchValue = value ?? false;
                                    });
                                  }),
                              Text("Acık")
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0,bottom: 2.0),
                                child: SizedBox(
                                  width: 45,
                                  height: 35,
                                  child: ToggleButtons(
                                      borderRadius: BorderRadius.circular(10),
                                      constraints: BoxConstraints(minWidth:45,maxWidth: 60,minHeight:35,maxHeight:60),
                                      renderBorder: false,
                                      isSelected: [
                                        autoSwitchValue
                                      ],
                                      onPressed:(value){
                                        autoSwitchValue=!autoSwitchValue;
                                        print(autoSwitchValue);
                                        setState(() {
                                        });
                                      },
                                      children: [
                                        Icon(autoSwitchValue? Icons.check_box:Icons.check_box_outline_blank_rounded,
                                        ),
                                      ]
                                  ),
                                ),
                              ),
                              Text("El ile")
                            ],
                          ),
                        )

                      ],),
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
