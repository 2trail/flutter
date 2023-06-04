

class DataBaseClass{
  int crop;
  double lux;
  double moisture;
  double temperature;
  double voltage;

  DataBaseClass(
      this.crop, this.lux, this.moisture, this.temperature, this.voltage);
  
  factory DataBaseClass.fromJson(Map<dynamic,dynamic>json){
    return DataBaseClass( json["crop"] as int, json["lux"] as double, json["moisture"] as double,json["temperature"] as double , json["voltage"] as double);
  }
}