
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trial1/BarPages/LightPage/LightPage.dart';
import 'package:trial1/BarPages/TempPage/TempPage.dart';
import 'package:trial1/BarPages/WaterPage/WaterPage.dart';

import '../firebase/fireBringer.dart';


class HomeBar extends StatefulWidget {
  const HomeBar({Key? key}) : super(key: key);

  @override
  State<HomeBar> createState() => _HomeBarState();
}

class _HomeBarState extends State<HomeBar> {

  bool _switchValue = false;//todo: read from firebase


  @override
  void initState() {
    Provider.of<FireBringer>(context, listen: false).fireStarter();
    print("object");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    var screenSize=MediaQuery.of(context);
    final double screenHeight = screenSize.size.height;
    final double screenWidth = screenSize.size.width;


      return SingleChildScrollView(
        child: SafeArea(
        child: Column(

          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 0.0,bottom: 0.0),
              child: PopupMenuButton(
                //position: PopupMenuPosition.under,
                offset: const Offset(0, 0) , //todo: need calculation
                shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                ) ,
                child: Container(
                  width: screenWidth,
                  height: screenHeight/5,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:  const [
                      Text('Sera1',style: TextStyle(fontSize: 30), ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: RotatedBox(quarterTurns: 1,
                        child: Icon(Icons.arrow_forward_ios)),
                      )
                    ],
                  ),
                ),
                itemBuilder: (context)=> [//menu items
                const PopupMenuItem(
                  value: 1,
                  child: Center(child: Text("Sera2")),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Center(child: Text("yeni cihaz ekle",))
                ),
              ],),
            ),

            //ECENIN PART
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 4.0,bottom: 4.0),
              child: Card(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ) ,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    print("123");
                    Navigator.push(context,MaterialPageRoute(builder: (context)=> const LightPage(),));
                  },


                  child: SizedBox(
                    height: screenHeight/7,
                    child: Row(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(left: 18.0,right: 18),
                          child: Center(
                              child: Icon(
                                Icons.eco,
                                size: 28.0, //default:24
                                color: Colors.grey,
                              )
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(bottom: 2.0),
                              child: Text("Hasat durumu",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: Consumer<FireBringer?>(
                                builder: (context, objectIndex, child) {
                                  if(objectIndex?.cropLastKnownStatus == 0){
                                    return const Text("Mahsul yok",
                                      style:TextStyle(color: Colors.red) ,
                                    );
                                  }
                                  if(objectIndex?.cropLastKnownStatus == 1){
                                    return const Text("Mahsul toplanmaya hazir !",
                                      style:TextStyle(color: Colors.green) ,
                                    );
                                  }
                                  else {
                                    return const Text("Yukleniyor...",
                                      style:TextStyle(color: Colors.yellow) ,
                                    );
                                  }
                                }

                              ),
                            ),

                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 28.0,),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_circle_outline,color: Colors.grey,size: 42,),
                              Text("Canlı")
                            ],
                          ),
                        ),


                      ],),
                  ),
                ),
              ),
            ),


            //CARD 1
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 4.0,bottom: 4.0),
              child: Card(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ) ,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: (){
                    print("LIGHT");
                    Navigator.push(context,MaterialPageRoute(builder: (context)=> const LightPage(),));
                    },


                  child: SizedBox(
                    height: screenHeight/7,
                    child: Row(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(left: 18.0,right: 18),
                          child: Center(
                              child: Icon(
                                Icons.sunny,
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
                              child: Text("Işık durumu",
                                style: TextStyle(
                                  fontSize: 18,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: Text("Işıklar kapalı",
                                style:TextStyle(color: Colors.grey) ,
                              ),
                            ),

                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CupertinoSwitch(
                                  value: _switchValue,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      print("test");
                                      _switchValue = value ?? false;
                                    });
                                  }),
                              Text("Auto")
                            ],
                          ),
                        ),


                    ],),
                  ),
                ),
              ),
            ),



            //CARD 2
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 4.0,bottom: 4.0),
              child: Card(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ) ,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: (){
                    print("WATER");
                    Navigator.push(context,MaterialPageRoute(builder: (context)=> const WaterPage(),));
                  },
                  child: SizedBox(
                    height: screenHeight/7,
                    child: Row(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(left: 18.0,right: 18),
                          child: Center(
                              child: Icon(
                                Icons.water_drop,
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
                              child: Text("Sulama durumu",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: Text("Damla sulama kapalı",
                                style:TextStyle(color: Colors.grey) ,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CupertinoSwitch(
                                  value: _switchValue,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _switchValue = value ?? false;
                                    });
                                  }),
                              Text("Auto")
                            ],
                          ),
                        ),


                      ],),
                  ),
                ),
              ),
            ),



            //CARD 3
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 4.0,bottom: 4.0),
              child: Card(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ) ,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: (){
                    print("TEMP");
                    Navigator.push(context,MaterialPageRoute(builder: (context)=> const TempPage(),));
                  },
                  child: SizedBox(
                    height: screenHeight/7,
                    child: Row(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(left: 18.0,right: 18),
                          child: Center(
                              child: Icon(
                                Icons.thermostat,
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
                              child: Text("Sıcaklık durumu",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: Text("Sıcaklık: 28°C",
                                style:TextStyle(color: Colors.grey) ,
                              ),
                            ),

                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CupertinoSwitch(
                                  value: _switchValue,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _switchValue = value ?? false;
                                    });
                                  }),
                              Text("Auto")
                            ],
                          ),
                        ),


                      ],),
                  ),
                ),
              ),
            ),



            //CARD 4
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 4.0,bottom: 4.0),
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
                              Icons.sunny,
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
                            child: Text("Isik durumu",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.0),
                            child: Text("Işıklar kapalı",
                              style:TextStyle(color: Colors.grey) ,
                            ),
                          ),

                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CupertinoSwitch(
                                value: _switchValue,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _switchValue = value ?? false;
                                  });
                                }),
                            Text("Auto")
                          ],
                        ),
                      ),


                    ],),
                ),
              ),
            ),





            //CARD 5
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 4.0,bottom: 4.0),
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
                              Icons.sunny,
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
                            child: Text("Isik durumu",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.0),
                            child: Text("Isiklar kapali",
                              style:TextStyle(color: Colors.grey) ,
                            ),
                          ),

                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CupertinoSwitch(
                                value: _switchValue,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _switchValue = value ?? false;
                                  });
                                }),
                            Text("Auto")
                          ],
                        ),
                      ),


                    ],),
                ),
              ),
            ),








          ],
        ),
    ),
      );
  }
}


