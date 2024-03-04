import 'dart:collection';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';


import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:SmartFarming/FlutterMapPlugin/currentLocation_Plugin.dart';
import 'package:SmartFarming/FlutterMapPlugin/zoombuttons_plugin.dart';
import 'package:SmartFarming/firebase/DataBaseLocationClass.dart';

import '../FlutterMapPlugin/goToCurrentLocationButton_Plugin.dart';
import '../firebase/DataBaseClass.dart';
import '../firebase/fireBringer.dart';


class DeviceManagerBar extends StatefulWidget {
  const DeviceManagerBar({Key? key}) : super(key: key);


  @override
  State<DeviceManagerBar> createState() => _DeviceManagerBarState();
}

class _DeviceManagerBarState extends State<DeviceManagerBar> with TickerProviderStateMixin {



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

  //calculation of center of map to move the camera to the center of the polygon
  
  LatLng calculateCenter(List<LatLng> polygonPoints) {
    if (polygonPoints.isEmpty) {
      return LatLng(0, 0);
    }

    double minLat = polygonPoints.first.latitude;
    double maxLat = polygonPoints.first.latitude;
    double minLong = polygonPoints.first.longitude;
    double maxLong = polygonPoints.first.longitude;

    for (var point in polygonPoints) {
      if (point.latitude < minLat) {
        minLat = point.latitude;
      }
      if (point.latitude > maxLat) {
        maxLat = point.latitude;
      }
      if (point.longitude < minLong) {
        minLong = point.longitude;
      }
      if (point.longitude > maxLong) {
        maxLong = point.longitude;
      }
    }

    double centerLat = (minLat + maxLat) / 2;
    double centerLong = (minLong + maxLong) / 2;

    return LatLng(centerLat, centerLong);
  }
  //calculation of zoom level to fit the polygon to the screen

  double calculateZoomLevel(List<LatLng> polygonPoints) {
    const double coefficient = 0.90;

    if (polygonPoints.isEmpty) {
      return 1;
    }

    double minLat = polygonPoints.first.latitude;
    double maxLat = polygonPoints.first.latitude;
    double minLong = polygonPoints.first.longitude;
    double maxLong = polygonPoints.first.longitude;

    for (var point in polygonPoints) {
      if (point.latitude < minLat) {
        minLat = point.latitude;
      }
      if (point.latitude > maxLat) {
        maxLat = point.latitude;
      }
      if (point.longitude < minLong) {
        minLong = point.longitude;
      }
      if (point.longitude > maxLong) {
        maxLong = point.longitude;
      }
    }
    double deltaLat = maxLat - minLat;
    double deltaLong = maxLong - minLong;
    double zoomLat = log(360/ deltaLat) / log(2);
    double zoomLong = log(360/ deltaLong) / log(2);
    double zoomLevel = ((zoomLat+zoomLong)/2)*coefficient;


    return zoomLevel;
  }



  static const _startedId = 'AnimatedMapController#MoveStarted';
  static const _inProgressId = 'AnimatedMapController#MoveInProgress';
  static const _finishedId = 'AnimatedMapController#MoveFinished';



  void _animatedMapMove(LatLng destLocation, double destZoom,mapController) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final camera = mapController.camera;
    final latTween = Tween<double>(
        begin: camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
        duration: const Duration(milliseconds: 2500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation =
    CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    // Note this method of encoding the target destination is a workaround.
    // When proper animated movement is supported (see #1263) we should be able
    // to detect an appropriate animated movement event which contains the
    // target zoom/center.
    final startIdWithTarget =
        '$_startedId#${destLocation.latitude},${destLocation.longitude},$destZoom';
    bool hasTriggeredMove = false;

    controller.addListener(() {
      final String id;
      if (animation.value == 1.0) {
        id = _finishedId;
      } else if (!hasTriggeredMove) {
        id = startIdWithTarget;
      } else {
        id = _inProgressId;
      }

      hasTriggeredMove |= mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
        id: id,
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });
    controller.forward();
  }

  late TextEditingController _controller;
  Marker buildPin(LatLng point) => Marker(
    point: point,
    child: const Icon(Icons.location_pin, size: 60, color: Colors.black),
    width: 60,
    height: 60,
  );

  late final customMarkers = <Marker>[];
  late List<LatLng> customPolygon = <LatLng>[];
  Map<String,List<LatLng>> mapOfCustomPolygons  =<String,List<LatLng>>{};

  List<String> specialCharacters = ['.', ',', r'\$', '#', '[', ']', '/'];


  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    getLocationList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    bool counterRotate = false;
    Alignment selectedAlignment = Alignment.topCenter;


    return FlutterMap(
        options: MapOptions(
          onTap: (_, p) => setState(() {
            customMarkers.add(buildPin(p));
            customPolygon.add(p);


          }),
          interactionOptions: const InteractionOptions(
            flags: ~InteractiveFlag.doubleTapZoom,
          ),
          keepAlive: false,
          initialCenter: const LatLng(41.008264,28.988428),
          initialZoom: 10.0 ,

        ),
        children: <Widget>[
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.SmartFarming.app',
          ),
          CurrentLocationLayer(),
          PolygonLayer(
              polygons: [
                Polygon(

                  points:customPolygon,
                  isDotted: true,
                  borderColor: Colors.blueGrey,
                  borderStrokeWidth: 4,
                  isFilled: true,
                  color: Colors.blue.withOpacity(0.5),
                )
              ]
          ),
          for (var element in customMarkers)...[
            GestureDetector(//ontap show a snackbar saying "to delete, long press"
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  //backgroundColor: Theme.of(context).colorScheme.secondary,
                  content: Text('To delete, long press'),
                  duration: Duration(seconds: 1),
                ),
              ),
              onLongPress: () => setState(() {
                customMarkers.remove(element);
                customPolygon.remove(element.point);

              }),
              child: MarkerLayer(
                markers: [element],
                rotate: counterRotate,
                alignment: selectedAlignment,
              ),
            ),

          ],
          /*
          MarkerLayer(
            markers: customMarkers,
            rotate: counterRotate,
            alignment: selectedAlignment,
          ),
           */
          SafeArea(
              child:
              Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: FloatingActionButton(
                        heroTag: 'Save Button',
                        mini: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        onPressed: () {
                          showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context){
                              return CupertinoAlertDialog(
                                title: Material(
                                  child: TextField(
                                    controller: _controller,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Konumu ismlendirin:'
                                    ),
                                  ),
                                ),

                                actions: [
                                  CupertinoDialogAction(
                                    child: Text("İptal"),
                                    onPressed: (){
                                      _controller.clear();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: Text("Kaydet"),
                                    onPressed: (){

                                      if(customPolygon.length < 3){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            //backgroundColor: Theme.of(context).colorScheme.secondary,
                                            content: Text('Alan oluşturmak için en az 3 nokta ekleyin.'),
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                        return;
                                      }
                                      if(specialCharacters.any((char) => _controller.text.contains(char))){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            //backgroundColor: Theme.of(context).colorScheme.secondary,
                                            content: Text('Konum ismi " . , \$ # [ ] / " içeremez.'),
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                        return;
                                      }
                                      if(_controller.text.length > 10){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            //backgroundColor: Theme.of(context).colorScheme.secondary,
                                            content: Text('Konum ismi 10 karakterden uzun olamaz.'),
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                        return;
                                      }
                                      if(_controller.text.isEmpty){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            //backgroundColor: Theme.of(context).colorScheme.secondary,
                                            content: Text('Konum ismi boş olamaz.'),
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                        return;
                                      }


                                      //todo: add controller to textfield and get the name of the location

                                      String konumAdi = "deneme";
                                      var fireTest = FirebaseDatabase.instance.ref("konumlar/${_controller.text}");
                                      int temp = 0;
                                      var veriler = HashMap<int,HashMap<String,double>>();
                                      for (var element in customPolygon) {
                                        veriler[temp] = HashMap<String,double>();
                                        veriler[temp]!["lat"] = element.latitude;
                                        veriler[temp]!["long"] = element.longitude;
                                        temp++;
                                      }
                                      print(veriler);
                                      fireTest.set(veriler);

                                      mapOfCustomPolygons[_controller.text.toString()] = List.from(customPolygon);
                                      //mapOfCustomPolygons[_controller.text.toString()] = customPolygon; // you are actually assigning a reference to customPolygon to the map. Therefore, when you modify customPolygon, the change is reflected in the map as well.
                                      _controller.clear();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );

                          setState(() {
                            //counterRotate = !counterRotate;
                          });
                        },
                        child: Icon(Icons.save, color: Theme.of(context).iconTheme.color),
                      ),
                    ),

                    //this popup menu button will show saved locations and when clicked on them user will be able to see them. if user clicks on create new location, user will be able to create a new location.
                    Builder(
                      builder: (context) {
                        return PopupMenuButton(
                          position: PopupMenuPosition.under,
                          offset: const Offset(-17, 5),
                          color: Theme.of(context).colorScheme.surface,
                          shadowColor: Colors.black,
                          surfaceTintColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: Container(
                            //height: 50,
                            margin: const EdgeInsets.only(top: 5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).colorScheme.surface,

                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Locations",
                                  style: Theme.of(context).textTheme.bodyLarge

                                ),

                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Icon(Icons.clear_all),
                                )
                              ],
                            ),
                          ),
                          //icon: Icon(Icons.more_vert, color: Theme.of(context).iconTheme.color),
                         // initialValue: ,
                          onSelected: (String itemLocation) {
                            print('---------- $itemLocation--------');
                            setState(() {
                              customPolygon = List.from(mapOfCustomPolygons[itemLocation]!);
                              _controller.text = itemLocation;
                              //calculation of center of map to move the camera to the center of the polygon
                              //calculation of zoom level to fit the polygon to the screen
                              _animatedMapMove(calculateCenter(customPolygon), calculateZoomLevel(customPolygon),MapController.of(context));
                              //MapController.of(context).move(calculateCenter(customPolygon), calculateZoomLevel(customPolygon));
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








                            /*=> <PopupMenuEntry<Alignment>>[


                               PopupMenuItem<Alignment>(
                                //height: 20,
                                child:Row(

                                  children: [
                                    Text('Tarlam -1'),
                                    const Spacer(),
                                    IconButton(onPressed: (){
                                      showCupertinoDialog(
                                        context: context,
                                          builder: (BuildContext context){
                                            return CupertinoAlertDialog(
                                              title: Text("Tarlam -1"),
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
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                      );
                                      },
                                      icon: Icon(Icons.delete)
                                    )
                                  ],
                                ),
                              ),
                              const PopupMenuDivider(),
                              PopupMenuItem<Alignment>(
                                value: Alignment.topCenter,
                                child: Row(
                                  children: [
                                    Text('Yeni konum'),
                                    const Spacer(),
                                    IconButton(onPressed: (){print("add clicked");Navigator.of(context).pop();},
                                        icon: Icon(Icons.add)
                                    )
                                  ],
                                ),
                              ),
                            ],*/
                        );
                      }
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: FloatingActionButton(
                        heroTag: 'Clear Button',
                        mini: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        onPressed: () {
                          setState(() {
                            customMarkers.clear();
                            customPolygon.clear();
                          });
                        },
                        child: Icon(Icons.cleaning_services, color: Theme.of(context).iconTheme.color),
                      ),
                    ),
                  ],
                )
              )
          ),

          FlutterMapZoomButtons(
            minZoom: 4,
            maxZoom: 19,
            mini: true,
            padding: 10,
            alignment: Alignment(Alignment.bottomRight.x , Alignment.bottomRight.y-0.30 ),
          ),

          Builder(
            builder: (context) {
              return GoToCurrentLocationButton(
                  mini: true,
                  padding: 10,
                  alignment: Alignment(Alignment.bottomLeft.x , Alignment.bottomLeft.y-0.30 ),
                  onPressed:(){
                    Geolocator.getCurrentPosition().then((value) => {
                    _animatedMapMove(LatLng(value.latitude, value.longitude), 10,MapController.of(context))

                    });

                  }
              );
            }
          ),



        ]
    );
  }
}
