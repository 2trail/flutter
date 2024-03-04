import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:SmartFarming/FlutterMapPlugin/zoombuttons_plugin.dart';

import '../firebase/fireBringer.dart';


class DeviceManagerBar extends StatefulWidget {
  const DeviceManagerBar({Key? key}) : super(key: key);


  @override
  State<DeviceManagerBar> createState() => _DeviceManagerBarState();
}

class _DeviceManagerBarState extends State<DeviceManagerBar> {




  late TextEditingController _controller;
  Marker buildPin(LatLng point) => Marker(
    point: point,
    child: const Icon(Icons.location_pin, size: 60, color: Colors.black),
    width: 60,
    height: 60,
  );

  late final customMarkers = <Marker>[
    buildPin(const LatLng(51.51868093513547, -0.12835376940892318)),
    buildPin(const LatLng(53.33360293799854, -6.284001062079881)),
  ];
  final notFilledPoints = <LatLng>[
    const LatLng(41.008264,28.988428),
    const LatLng(41.108264,28.888428),
    const LatLng(41.108264,28.788428),
  ];

  late List<LatLng> customPolygon = <LatLng>[];

  List<String> specialCharacters = ['.', ',', r'\$', '#', '[', ']', '/'];

  List<String> listOfLocations = <String>['location1', 'location2', 'location3'];


  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
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
          initialCenter: LatLng(41.008264,28.988428),
          initialZoom: 10.0 ,

        ),
        children: <Widget>[
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.SmartFarming.app',
          ),
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




                                      //fireTest.set({"dsad": 3});
                                      //veriler["test"]="deneme";
                                      //fireTest.push().set(veriler);

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
                    MenuAnchor(
                      builder: (BuildContext context, MenuController controller, Widget? child){
                        return GestureDetector(
                          onTap: () {
                            if (controller.isOpen) {
                              controller.close();
                            } else {
                              controller.open();
                            }
                          },
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
                        );
                      },
                      //icon: Icon(Icons.more_vert, color: Theme.of(context).iconTheme.color),

                      menuChildren: [
                        Row(

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
                        Row(
                          children: [
                            Text('Yeni konum'),
                            const Spacer(),
                            IconButton(onPressed: (){print("add clicked");Navigator.of(context).pop();},
                                icon: Icon(Icons.add)
                            )
                          ],
                        ),

                      ],

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
          CurrentLocationLayer(),
        ]
    );
  }
}
