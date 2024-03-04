

class DataBaseLocationClass{

  double moisture;
  double temperature;


  DataBaseLocationClass(
      this.moisture, this.temperature);

  factory DataBaseLocationClass.fromJson(Map<dynamic,dynamic>json){
    return DataBaseLocationClass( json["lat"] as double, json["long"] as double);
  }
}