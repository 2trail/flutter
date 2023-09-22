import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../firebase/fireBringer.dart';

class LineChartWidget extends StatefulWidget{
  //todo: For every chart we need, it need to create dynamically
  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  double counter =0;
  List<String> listOfKeys = ["-","-","-","-"];

  @override
  Widget build(BuildContext context) {
    return Consumer<FireBringer?>(
        builder: (context, objectIndex, child) => LineChart(
        LineChartData(


          minX: 0,//todo: calculate min max
          maxX: (() {
            counter = objectIndex!.fireCounter.toDouble();
            listOfKeys[0]=objectIndex.date[(counter*1)~/12];
            listOfKeys[1]=objectIndex.date[(counter*4)~/12];
            listOfKeys[2]=objectIndex.date[(counter*8)~/12];
            listOfKeys[3]=objectIndex.date[(counter*11)~/12];
            return objectIndex?.fireCounter.toDouble();
          }()),
          minY: objectIndex!.lux.reduce(min)-10,
          maxY: objectIndex!.lux.reduce(max)+10,
          gridData: FlGridData(
            show: true,
            //drawVerticalLine: true,
            //horizontalInterval: 1,  //yatay/dikey ekstra cizgi
            //verticalInterval: 1,
            getDrawingHorizontalLine: (value){
              return FlLine(
                color: const Color(0xff37434d),
                strokeWidth: 0.5,
              );
            },
            getDrawingVerticalLine: (value){
              return FlLine(
                color: const Color(0xff37434d),
                strokeWidth: 0.5,
              );
            },
          ),


            titlesData: FlTitlesData(
              show: true,
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 1,
                  getTitlesWidget: bottomTitleWidgets,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,//sol yazilar icin true yap
                  interval: 1,
                  getTitlesWidget: leftTitleWidgets,
                  reservedSize: 32,
                ),
              ),
            ),



          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 0.5),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: objectIndex?.returnFlSpots(),
              isCurved: true,
              gradient: LinearGradient(
                colors: gradientColors
              ),
              barWidth: 5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false,      //dot noktalarini gormek icin true yap
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: gradientColors
                      .map((color) => color.withOpacity(0.3))
                      .toList(),
                ),
              )

            ),
          ]
        ),
      ),
    );
  }

  //ALT TABAKA YAZILARI




  Widget bottomTitleWidgets(double value, TitleMeta meta) {

    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );


    Widget text;

    if(value.toInt() == (counter*1)~/12){text = Text(listOfKeys[0].substring(5), style: style); }
    else if(value.toInt() == (counter*4)~/12){text = Text(listOfKeys[1].substring(5), style: style); }
    else if(value.toInt() == (counter*8)~/12){text = Text(listOfKeys[2].substring(5), style: style); }
    else if(value.toInt() == (counter*11)~/12){text = Text(listOfKeys[3].substring(5), style: style); }
    else {
      text = const Text('', style: style);
    }
    /*switch (value.toInt()) {
      case 1:
        text = const Text('TMUZ', style: style);
        break;
      case 5:
        text = const Text('OCAK', style: style);
        break;
      case 8:
        text = const Text('MART', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }*/

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  //SOL TABAKA YAZILARI
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1';
        break;
      case 3:
        text = '3';
        break;
      case 5:
        text = '5';
        break;
      default:
        return Container();
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }
}