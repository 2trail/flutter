import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:SmartFarming/firebase/DataBaseClass.dart';


class FireBringer extends ChangeNotifier {
//firebase initialization:
  var fireTest = FirebaseDatabase.instance.ref().child("veriler");

  late Future<int> fireLength;
  int fireCounter = 0;

  bool isFireOn = false;

  List<String> date=[];
  List<int> crop=[];
  List<double> lux=[];
  List<double> moisture=[];
  List<double> temperature=[];
  List<double> voltage=[];
  int cropLastKnownStatus = 2;

  void cleanAll(){
    if(date.isNotEmpty){
      date.clear();
      crop.clear();
      lux.clear();
      moisture.clear();
      temperature.clear();
      voltage.clear();
    }
  }


  Future<void> fireStarter() async {

    print("fireStarter():");
    if (isFireOn==false){
      cleanAll();
      isFireOn = true;
      fireTest.onValue.listen((event) {


        Map<dynamic, dynamic> gelenDegerlersnap= event.snapshot.value as Map;


        var gelenDegerler = Map.fromEntries(
            gelenDegerlersnap.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
        //todo: bu kod verimsiz calistigini dusunmekteim.
        // Firebase zaten sirali bir bicimde verileri gonderebilme kapasitesine sahiptir.
        // Bunun icin "event.snapshot.children.elementAt(0).key"  ve
        // " event.snapshot.children.elementAt(0).value as Map" kullanilarak listeleme yapilmalidir

        if(gelenDegerler != null){
          fireCounter= 0;
          gelenDegerler.forEach((key,nesne){
            var gelenDeger = DataBaseClass.fromJson(nesne);

            print("***************************");
            print("key: $key");
            /*
            if (gelenDeger.crop==1){
              print("crop: TOPLAMAYA HAZIR");
            }
            else{print("crop: ÜRÜN YOK");}
            */
            print("crop: ${gelenDeger.crop}");
            print("lux: ${gelenDeger.lux}");
            print("moisture: ${gelenDeger.moisture}");
            print("temperature: ${gelenDeger.temperature}");
            print("voltage: ${gelenDeger.voltage}");

            date.add(key);
            crop.add(gelenDeger.crop);
            lux.add(gelenDeger.lux);
            moisture.add(gelenDeger.moisture);
            temperature.add(gelenDeger.temperature);
            voltage.add(gelenDeger.voltage);
            fireCounter=fireCounter+1;
          });

        }

        print("----------------------------");
        print("snapshot.children: ${event.snapshot.children.elementAt(0).key}");
        print("snapshot.children.elementAt(0): ${event.snapshot.children.elementAt(0).value as Map}");
        print("----------------------------");



        cropLastKnownStatus=crop.last;
        notifyListeners();
      });

    }
    else {
      print("already running");
    }
    }


  void fireStopper(){
    fireTest.onValue.listen((event) { }).cancel();
    isFireOn = false;
  }
  
  void test(){
    var veriler = HashMap<String,dynamic>();
    veriler["test"]="deneme";
    fireTest.push().set(veriler);
  }

  List<FlSpot> returnFlSpots(){//for light data point
    List<FlSpot> listOfSpots =[];
    for(int i = 0; i<fireCounter ;i++){
      listOfSpots.add(FlSpot(i.toDouble(), lux[i]));
    }
    print("------------------------------------------------------");
    print(listOfSpots.length);
    print(fireCounter);
    return listOfSpots;
  }

  List<FlSpot> returnFlSpots4Temp(){//for temp data point
    List<FlSpot> listOfSpots =[];
    for(int i = 0; i<fireCounter ;i++){
      listOfSpots.add(FlSpot(i.toDouble(), temperature[i]));
    }
    print("------------------------------------------------------");
    print(listOfSpots.length);
    print(fireCounter);
    return listOfSpots;
  }

  List<FlSpot> returnFlSpots4Water(){//for light data point
    List<FlSpot> listOfSpots =[];
    for(int i = 0; i<fireCounter ;i++){
      listOfSpots.add(FlSpot(i.toDouble(), moisture[i]));
    }
    print("------------------------------------------------------");
    print(listOfSpots.length);
    print(fireCounter);
    return listOfSpots;
  }



}


