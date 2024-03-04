import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'dPad_Plugin.dart';

class LiveControlPage extends StatefulWidget {
  const LiveControlPage({
    super.key
  });

@override
_LiveControlPageState createState() => _LiveControlPageState();
}

class _LiveControlPageState extends State<LiveControlPage>{

  static void _defaultOnTap() {
    print("Default onTap");
  }


  // 0=auto, 1=forward, 2=backward, 3=left, 4=right, 5=stop, 6=drill, 7=water, 8=seed

  static const brown = 0XFFB99470;
  static const beige = 0XFFFEFAE0;
  static const greenL = 0XFFA9B388;
  static const greenD = 0XFF5F6F52;

  var fireTest = FirebaseDatabase.instance.ref("Config/command");
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Image(
                  image: NetworkImage('${'https://firebasestorage.googleapis.com/v0/b/bitirmeje.appspot.com/o/detectedImages?alt=media&token=53d26f43-9dc6-4e82-815e-272c5747b6a1'}?${DateTime.now().millisecondsSinceEpoch.toString()}'),
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                color: Colors.transparent,
                child: Stack(

                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 48.0),
                        // 0=auto, 1=forward, 2=backward, 3=left, 4=right, 5=stop, 6=drill, 7=water, 8=seed
                        child: DPad(
                          onTapUp:      () => fireTest.set(1),
                          onTapDown:    () => fireTest.set(2),
                          onTapLeft:    () =>fireTest.set(3),
                          onTapRight:   () =>fireTest.set(4),
                          onTapMiddle:  () =>fireTest.set(5),
                          backgroundColor: Color(brown),
                          iconColor: Color(beige),
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Material(
                            color: Color(brown),
                            shape: const CircleBorder(),
                            child: InkWell(
                              onTap: () => fireTest.set(0),
                              customBorder: const CircleBorder(),
                              child: Icon(
                                Icons.play_arrow_rounded,
                                size: 50,
                                color:  Color(beige),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Material(
                            color: Color(brown),
                            shape: const CircleBorder(),
                            child: InkWell(
                              onTap: () => fireTest.set(6),
                              customBorder: const CircleBorder(),
                              child: Icon(
                                Icons.tornado,
                                size: 50,
                                color:  Color(beige),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Material(
                            color: Color(brown),
                            shape: const CircleBorder(),
                            child: InkWell(
                              onTap: () => fireTest.set(7),
                              customBorder: const CircleBorder(),
                              child: Icon(
                                Icons.water_drop_rounded,
                                size: 50,
                                color:  Color(beige),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Material(
                            color: Color(brown),
                            shape: const CircleBorder(),
                            child: InkWell(
                              onTap: () => fireTest.set(8),
                              customBorder: const CircleBorder(),
                              child: Icon(
                                Icons.spa_rounded,
                                size: 50,
                                color:  Color(beige),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          
          ),
        )
      ),

    );
  }
}
