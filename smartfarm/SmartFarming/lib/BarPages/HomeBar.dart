
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:SmartFarming/BarPages/LightPage/LightPage.dart';
import 'package:SmartFarming/BarPages/TempPage/TempPage.dart';
import 'package:SmartFarming/BarPages/WaterPage/WaterPage.dart';

import '../firebase/fireBringer.dart';
import 'LiveControlPage/LiveControlPage.dart';


class HomeBar extends StatefulWidget {
  const HomeBar({Key? key}) : super(key: key);

  @override
  State<HomeBar> createState() => _HomeBarState();
}

class _HomeBarState extends State<HomeBar> with TickerProviderStateMixin {



  //todo: this function and variable is used in many places, so it should be in a global file or in a provider !!!!!!!!!!!!!!!!!!!!!! devicemanagerbar.dart
  Map<String,List<LatLng>> mapOfCustomPolygons  =<String,List<LatLng>>{};
  void getLocationList()async{

    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('konumlar').get();

    if (snapshot.exists) {
      print(snapshot.value);
    } else {
      print('No data available.');
    }

    (snapshot.value as Map).forEach((key, value) {
      print('-----> $key');
      print('--------------------->$value');


      value.forEach((element) {
        if(mapOfCustomPolygons[key] == null){
          mapOfCustomPolygons[key] = [];
        }
        mapOfCustomPolygons[key]!.add(LatLng(element["lat"],element["long"]));
        print(element.runtimeType);
        print(element["lat"]);
        print("---------------------------------------------->$element");
      });

    });

    print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa>$mapOfCustomPolygons');
    print(snapshot.value.runtimeType);


  }

  String selectedLocation = "Unknown";


  void getSelectedLocation()async{
    var fireTest = FirebaseDatabase.instance.ref("Config/selectedLocation/");
    //a=fireTest.ref.child("ssss");
    final snapshot = await fireTest.get();
    if (snapshot.exists) {
      print(snapshot.value);
      setState(() {
        selectedLocation = snapshot.value.toString();
      });
    } else {
      print('No data available.');
    }


  }

  //String selectedLocation = "Unknown";
  int status = 2;                               //if 0 then device is off, if 1 then device is on if 2 status is unknown
  int statusChangeTo = 0;                       //if 0 then device will be off, if 1 then device will be on
  int command = 0;                              //if 0 no live command, if 1 then go straight, if 2 then turn right, if 3 then turn left, if 4 then go back so on...

  num batteryLevel = 0;                         //battery level of the device
  num luxLevel = 0;                             //lux level of the device
  num moistureLevel = 0;                        //moisture level of the device
  num temperatureLevel = 0;                     //temperature level of the device

  int remainingWater = 0;                       //remaining water of the device
  int remainingSeed = 0;                        //remaining seed of the device
  String startClock = "--:--:--";                           //start clock of the device
  int percentageOfProgress = 0;                 //percentage of progress of the device
  int numberOfSeeding = 0;                      //number of seeding of the device

  List <StreamSubscription<DatabaseEvent>> _subscription=[];






  var fireTest2 = FirebaseDatabase.instance.ref();
  void getDeviceStatusAll()async {

    var fireConfig = fireTest2.child("Config");
    var fireDevice = fireTest2.child("Device");


    _subscription.add(fireConfig.child("selectedLocation").onValue.listen((event) {
      setState(() {
        if(event.snapshot.value != null){
          selectedLocation = event.snapshot.value.toString();
          print("selectedLocation: $selectedLocation");
        }
        else{
          selectedLocation = "Unknown";
        }
      });
    }));

    fireConfig.child('status').get().then((snapshot) {
      setState(() {
        if(snapshot.value != null){
          statusChangeTo = snapshot.value as int;
          print("statusChangeTo: $statusChangeTo");
        }
      });
    });

    _subscription.add(fireConfig.child("status").onValue.listen((event) {
      setState(() {
        if(event.snapshot.value != null){
          status = event.snapshot.value as int;
          print("status: $status");
        }
      });
    }));

    _subscription.add(fireDevice.child("bataryaSarji").onValue.listen((event) {
      setState(() {
        if(event.snapshot.value != null){
          batteryLevel = event.snapshot.value as num;
          print("batteryLevel: $batteryLevel");
        }
      });
    }));
    _subscription.add(fireDevice.child("isik").onValue.listen((event) {
      setState(() {
        if(event.snapshot.value != null){
          luxLevel = event.snapshot.value as num;
          print("luxLevel: $luxLevel");
        }
      });
    }));
    _subscription.add(fireDevice.child("nem").onValue.listen((event) {
      setState(() {
        if(event.snapshot.value != null){
          moistureLevel = event.snapshot.value as num;
          print("moistureLevel: $moistureLevel");
        }
      });
    }));
    _subscription.add(fireDevice.child("sicaklik").onValue.listen((event) {
      setState(() {
        if(event.snapshot.value != null){
          temperatureLevel = event.snapshot.value as num;
          print("temperatureLevel: $temperatureLevel");
        }
      });
    }));
    _subscription.add(fireDevice.child("kalanSu").onValue.listen((event) {
      setState(() {
        if(event.snapshot.value != null){
          remainingWater = event.snapshot.value as int;
          print("remainingWater: $remainingWater");
        }
      });
    }));
    _subscription.add(fireDevice.child("kalanTohum").onValue.listen((event) {
      setState(() {
        if(event.snapshot.value != null){
          remainingSeed = event.snapshot.value as int;
          print("remainingSeed: $remainingSeed");
        }
      });
    }));
    _subscription.add(fireDevice.child("saat").onValue.listen((event) {
      setState(() {
        if(event.snapshot.value != null){
          startClock = event.snapshot.value.toString();
          print("startClock: $startClock");
        }
      });
    }));
    _subscription.add(fireDevice.child("yuzde").onValue.listen((event) {
      setState(() {
        if(event.snapshot.value != null){
          percentageOfProgress = event.snapshot.value as int;
          print("percentageOfProgress: $percentageOfProgress");
        }
      });
    }));
    _subscription.add(fireDevice.child("yapilanEkim").onValue.listen((event) {
      setState(() {
        if(event.snapshot.value != null){
          numberOfSeeding = event.snapshot.value as int;
          print("numberOfSeeding: $numberOfSeeding");
        }
      });
    }));
  }




  void disposeListener(){
    for (var element in _subscription) {
      element.cancel();
    }
  }




  late DateTime startTime;
  late Duration difference;
  late StreamController<String> _controller;
  late Stream<String> _stream;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }







  late final AnimationController _controllerLottie;
  bool _isAnimating = false;

  void lottieAnimation(){

    _controllerZZZFade= AnimationController(vsync: this);
    _controllerZZZFade.duration = const Duration(milliseconds: 1000);
    _controllerZZZFade.value=_controllerZZZFade.lowerBound;

    _controllerLottie= AnimationController(vsync: this);
    _controllerLottie.addStatusListener(_lottieAnimationStatusListener);

    _controllerZZZ= AnimationController(vsync: this);
    _controllerZZZ.addStatusListener(_zzzAnimationStatusListener);
  }
  void _lottieAnimationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed && _isAnimating) {
      _controllerLottie.reset();
      _controllerLottie.forward();
    }
  }

  static const totalFrame = 180;
  void _jumpToFrame(double frame) {
    _controllerLottie.value = (_controllerLottie.upperBound - _controllerLottie.lowerBound)/totalFrame*frame;
  }


  late final AnimationController _controllerZZZFade;

  late final AnimationController _controllerZZZ;
  void _zzzAnimationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_isAnimating) {
      _controllerZZZ.reset();
      _controllerZZZ.forward();
    }
  }





  @override
  void initState() {
    Provider.of<FireBringer>(context, listen: false).fireStarter();
    getLocationList();
    getSelectedLocation();
    getDeviceStatusAll();


    _isAnimating = false;
    lottieAnimation();

    super.initState();
  }

  @override
  void dispose() {
    disposeListener();
    _controllerLottie.removeStatusListener(_lottieAnimationStatusListener);
    _controllerLottie.dispose();
    _controllerZZZ.removeStatusListener(_zzzAnimationStatusListener);
    _controllerZZZ.dispose();
    _controllerZZZFade.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    var screenSize=MediaQuery.of(context);
    final double screenHeight = screenSize.size.height;
    final double screenWidth = screenSize.size.width;


    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: screenHeight/10),
            child: Container(
              //color: Colors.red,
              height: screenHeight/3,
              width: screenWidth,
              child: Stack(
                children: [
                  FadeTransition(
                    opacity: Tween<double>(begin: 1, end: 0).animate(_controllerZZZFade),
                    child: Align(
                      alignment: Alignment.topCenter - const Alignment(-0.05, 0.4),
                      child: SizedBox(
                        height: screenHeight/10,
                        width: screenWidth/5,
                        child: Lottie.asset("images/zzz.json",
                          controller: _controllerZZZ,
                          onLoaded: (composition) {
                            _controllerZZZ
                              ..duration = composition.duration
                              ..forward();
                          },
                        ),
                      ),
                    ),
                  ),
                  Align(
                     alignment: Alignment.topCenter - const Alignment(0, 0),
                      child: Lottie.asset("images/test2.json",
                        controller: _controllerLottie,
                        onLoaded: (composition) {
                          _isAnimating = true;

                          // Configure the AnimationController with the duration of the
                          // Lottie file and start the animation.
                          _controllerLottie
                            ..duration = composition.duration 
                            ..forward();
                        },
                      ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(startClock,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text("%$percentageOfProgress",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            
            ),
          )
        ),
        SliverList(
          delegate: SliverChildListDelegate([






            //CARD 0
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 2.0,bottom: 2.0),
              child: Card(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ) ,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    print("tapped on card 0");
                  },
                  child: SizedBox(
                    height: screenHeight/7,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 12.0,right: 12),
                          child: Center(
                              child: Ink(
                                decoration: ShapeDecoration(
                                  color: (() {
                                    if(status ==0 && statusChangeTo == 0){
                                      return Colors.white;
                                    }
                                    else if(status ==1 && statusChangeTo == 1){
                                      return Theme.of(context).colorScheme.secondary;
                                    }
                                    return Colors.orangeAccent;


                                  }()),
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  onPressed: (){
                                    setState(() {
                                      statusChangeTo = statusChangeTo == 0 ? 1 : 0;
                                      fireTest2.child("Config/statusChangeTo").set(statusChangeTo);
                                      print("statusChangeTo changed to $statusChangeTo");

                                    });
                                    },
                                  icon: Icon(
                                    Icons.power_settings_new_rounded,
                                    size: 28.0, //default:24
                                    color: (() {
                                      if(status ==1 && statusChangeTo == 1){
                                        return Theme.of(context).colorScheme.background;
                                      }

                                      return Colors.grey;
                                    }())
                                  ),
                                ),
                              ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(bottom: 2.0),
                              child: Text("Aracın Durumu",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: (() {
                                if(status == 0 && statusChangeTo == 0){

                                  _isAnimating =false;
                                  _controllerLottie.isAnimating ? _controllerLottie.stop(): null;
                                  _jumpToFrame(97);
                                  _controllerZZZFade.isDismissed ? null: _controllerZZZFade.reverse();


                                  //todo: wtf i am doing i don't know
                                  _controllerZZZ.reset();
                                  _controllerZZZ.forward();
                                  return const Text("Araç pasif",
                                    style:TextStyle(color: Colors.red) ,
                                  );
                                }
                                else if(status == 1 && statusChangeTo == 0){

                                  _isAnimating =true;
                                  _controllerLottie.isAnimating ? null: _controllerLottie.forward();
                                  return const Text("Araç kapatılıyor...",
                                    style:TextStyle(color: Colors.orange) ,
                                  );
                                }
                                else if(status == 0 && statusChangeTo == 1){

                                  _isAnimating =false;
                                  _controllerLottie.isAnimating ? _controllerLottie.stop(): null;
                                  _jumpToFrame(97);
                                  return const Text("Araç açılıyor...",
                                    style:TextStyle(color: Colors.orange) ,
                                  );
                                }
                                else if(status == 1 && statusChangeTo == 1){
                                  _isAnimating =true;
                                  _controllerLottie.isAnimating ? null: _controllerLottie.forward();

                                  _controllerZZZFade.isCompleted ? null: _controllerZZZFade.forward();

                                  return const Text("Araç aktif",
                                    style:TextStyle(color: Colors.green) ,
                                  );
                                }
                                else {
                                  return const Text("Yukleniyor...",
                                    style:TextStyle(color: Colors.grey) ,
                                  );
                                }
                              }()),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],),
                  ),
                ),
              ),
            ),

            //CARD 1
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 2.0,bottom: 2.0),
              child: Card(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ) ,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    print("tapped on card 1");
                  },
                  child: SizedBox(
                    height: screenHeight/7,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 12.0,right: 12),
                          child: Center(
                            child: Ink(
                              decoration: ShapeDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                onPressed: (){
                                  print("23");
                                },
                                icon: Icon(
                                  Icons.map,
                                  size: 28.0, //default:24
                                  color: Theme.of(context).colorScheme.background,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(bottom: 2.0),
                              child: Text("Seçili Tarla",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: Text(selectedLocation,
                                style:TextStyle(color: Colors.grey) ,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 24.0,),
                          child: PopupMenuButton(
                              position: PopupMenuPosition.under,
                              //offset: const Offset(-17, 5),
                              color: Theme.of(context).colorScheme.surface,
                              shadowColor: Colors.black,
                              surfaceTintColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: const Icon(
                                Icons.dehaze_rounded,
                                size: 48.0, //default:24
                                color: Colors.grey,
                              ),
                              //icon: Icon(Icons.more_vert, color: Theme.of(context).iconTheme.color),
                              // initialValue: ,
                              onSelected: (String itemLocation) {

                                print('---------- $itemLocation--------');
                                setState(() {
                                  var fireTest = FirebaseDatabase.instance.ref("Config/selectedLocation/");
                                  fireTest.set(itemLocation);
                                  selectedLocation = itemLocation;

                                });

                                print("===========================================>${mapOfCustomPolygons[itemLocation]!}");
                              },
                              itemBuilder: (BuildContext context) {
                                return mapOfCustomPolygons.keys.map((String location) {

                                  //todo: add a divider between locations
                                  return PopupMenuItem<String>(
                                    value: location,
                                    child: Row(
                                      children: [
                                        Text(location),
                                        const Spacer(),
                                        IconButton(onPressed: (){
                                          showCupertinoDialog(
                                              context: context,
                                              builder: (BuildContext context){
                                                return CupertinoAlertDialog(
                                                  title: Text(location),
                                                  content: Text("Bu konumu silmek istediğinize emin misiniz?"),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                      child: Text("İptal"),
                                                      onPressed: (){
                                                        Navigator.pop(context);
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    CupertinoDialogAction(
                                                      child: Text("Sil"),
                                                      onPressed: (){
                                                        Navigator.pop(context);
                                                        Navigator.of(context).pop();
                                                        mapOfCustomPolygons.remove(location);
                                                        var fireTest = FirebaseDatabase.instance.ref("konumlar/$location");
                                                        fireTest.remove();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              }
                                          );
                                        }, icon: Icon(Icons.delete, color: Theme.of(context).iconTheme.color,)),
                                      ],
                                    ),
                                  );
                                }).toList();
                              }
                          ),
                        ),
                      ],),
                  ),
                ),
              ),
            ),



            //CARD 2
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 2.0,bottom: 2.0),
              child: Card(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ) ,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),

                  onTap: () {
                    print("tapped on card 2");
                  },
                  child: SizedBox(
                    height: screenHeight/7,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 12.0,right: 12),
                          child: Center(
                            child: Ink(
                              decoration: ShapeDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                onPressed: (){
                                  print("23");
                                },
                                icon: Icon(
                                  Icons.spa_rounded,
                                  size: 28.0, //default:24
                                  color: Theme.of(context).colorScheme.background,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(bottom: 2.0),
                              child: Text("Yapılan Ekim",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: Text("$numberOfSeeding",
                                style:TextStyle(color: Colors.grey) ,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),

                      ],),
                  ),
                ),
              ),
            ),



            //CARD 3
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 2.0,bottom: 2.0),
              child: Card(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ) ,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),

                  onTap: () {
                    print("tapped on card 3");
                  },
                  child: SizedBox(
                    height: screenHeight/4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Temel Parametreler',style: TextStyle(fontSize: 18),),
                        Divider(
                          height: 12,
                          thickness: 2,
                          indent: 18,
                          endIndent: 18,
                          color: Colors.grey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: (screenWidth-24)/3,
                              //color: Colors.blueGrey,
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    Text( "Kalan Tohum",style: TextStyle(color: Colors.grey),),
                                    Ink(
                                      decoration: ShapeDecoration(
                                        color: Theme.of(context).colorScheme.secondary,
                                        shape: CircleBorder(),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 4.0,bottom: 4.0,),
                                        child: IconButton(
                                          onPressed: (){
                                            print("23");
                                          },
                                          icon: Icon(
                                            Icons.spa_rounded,
                                            size: 28.0, //default:24
                                            color: Theme.of(context).colorScheme.background,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text( "%$remainingSeed",style: TextStyle(color: Colors.grey),),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: (screenWidth-24)/3,
                              //color: Colors.white70,
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    Text( "Kalan Su",style: TextStyle(color: Colors.grey),),
                                    Ink(
                                      decoration: ShapeDecoration(
                                        color: Theme.of(context).colorScheme.secondary,
                                        shape: CircleBorder(),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 4.0,bottom: 4.0),
                                        child: IconButton(
                                          onPressed: (){
                                            print("23");
                                          },
                                          icon: Icon(
                                            Icons.water_drop,
                                            size: 28.0, //default:24
                                            color: Theme.of(context).colorScheme.background,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text( "%$remainingWater",style: TextStyle(color: Colors.grey),),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: (screenWidth-24)/3,
                              //color: Colors.amber,
                              child: Padding(
                                padding: EdgeInsets.only(left: 12.0,right: 12),
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Text( "Batarya sarjı",style: TextStyle(color: Colors.grey),),
                                      Ink(
                                        decoration: ShapeDecoration(
                                          color: Theme.of(context).colorScheme.secondary,
                                          shape: CircleBorder(),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 4.0,bottom: 4.0),
                                          child: IconButton(
                                            onPressed: (){
                                              print("23");
                                            },
                                            icon: Icon(
                                              Icons.battery_charging_full,
                                              size: 28.0, //default:24
                                              color: Theme.of(context).colorScheme.background,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text( "${batteryLevel.toStringAsFixed(2)} V",style: TextStyle(color: Colors.grey),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],),
                      ],
                    ),
                  ),
                ),
              ),
            ),




            //CARD 4
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 2.0,bottom: 2.0),
              child: Card(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ) ,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),

                  onTap: () {
                    print("tapped on card 4");
                    print("tapped on card 4");
                  },
                  child: SizedBox(
                    height: screenHeight/4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Sensör Ölçümleri',style: TextStyle(fontSize: 18),),
                        Divider(
                          height: 12,
                          thickness: 2,
                          indent: 18,
                          endIndent: 18,
                          color: Colors.grey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: (screenWidth-24)/3,
                              //color: Colors.blueGrey,
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    Text( "Sıcaklık",style: TextStyle(color: Colors.grey),),
                                    Ink(
                                      decoration: ShapeDecoration(
                                        color: Theme.of(context).colorScheme.secondary,
                                        shape: CircleBorder(),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 4.0,bottom: 4.0,),
                                        child: IconButton(
                                          onPressed: (){
                                            print("SICAKLIK");
                                            Navigator.push(context,MaterialPageRoute(builder: (context)=> const TempPage(),));
                                          },
                                          icon: Icon(
                                            Icons.thermostat,
                                            size: 28.0, //default:24
                                            color: Theme.of(context).colorScheme.background,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text( "$temperatureLevel°C",style: TextStyle(color: Colors.grey),),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: (screenWidth-24)/3,
                              //color: Colors.white70,
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    Text( "Nem",style: TextStyle(color: Colors.grey),),
                                    Ink(
                                      decoration: ShapeDecoration(
                                        color: Theme.of(context).colorScheme.secondary,
                                        shape: CircleBorder(),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 4.0,bottom: 4.0),
                                        child: IconButton(
                                          onPressed: (){
                                            print("NEM");
                                            Navigator.push(context,MaterialPageRoute(builder: (context)=> const WaterPage(),));
                                          },
                                          icon: Icon(
                                            Icons.water_drop,
                                            size: 28.0, //default:24
                                            color: Theme.of(context).colorScheme.background,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text( "%$moistureLevel",style: TextStyle(color: Colors.grey),),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: (screenWidth-24)/3,
                              //color: Colors.amber,
                              child: Padding(
                                padding: EdgeInsets.only(left: 12.0,right: 12),
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Text( "Işık",style: TextStyle(color: Colors.grey),),
                                      Ink(
                                        decoration: ShapeDecoration(
                                          color: Theme.of(context).colorScheme.secondary,
                                          shape: CircleBorder(),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 4.0,bottom: 4.0),
                                          child: IconButton(
                                            onPressed: (){
                                              print("IŞIK");
                                              Navigator.push(context,MaterialPageRoute(builder: (context)=> const LightPage(),));
                                            },
                                            icon: Icon(
                                              Icons.sunny,
                                              size: 28.0, //default:24
                                              color: Theme.of(context).colorScheme.background,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text( "${luxLevel.toStringAsFixed(2)}k Lux",style: TextStyle(color: Colors.grey),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            //CARD 5
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 2.0,bottom: 2.0),
              child: Card(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ) ,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),

                  onTap: () {
                    print("tapped on card 5");
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>  LiveControlPage(),));
                  },
                  child: SizedBox(
                    height: screenHeight/7,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 12.0,right: 12),
                          child: Center(
                            child: Ink(
                              decoration: ShapeDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                onPressed: (){
                                  print("Canlı Kontrol");
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=> LiveControlPage(),));
                                },
                                icon: Icon(
                                  Icons.play_circle,
                                  size: 28.0, //default:24
                                  color: Theme.of(context).colorScheme.background,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(bottom: 2.0),
                              child: Text("Canlı Kontrol",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: Text("Cihazı kontrol etmek için dokunun.",
                                style:TextStyle(color: Colors.grey) ,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),

                      ],),
                  ),
                ),
              ),
            ),

            //EMPTY SPACE FOR BOTTOM NAVIGATION BAR
            SizedBox(
              height: screenHeight/8,
            )



          ],
          ),
        ),
      ],
    );


  }
}


