import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fourth_app/bar%20graph/bar_data.dart';

class MyBarGraph extends StatelessWidget {
  final double? maxY;
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thurAmount;
  final double friAmount;
  final double satAmount;

  const MyBarGraph({
    super.key,
    required this.maxY,
    required this.sunAmount,
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thurAmount,
    required this.friAmount,
    required this.satAmount,
  });

  @override
  Widget build(BuildContext context) {

    // initialise the bar data
    BarData myBarData = BarData(
      sunAmount: sunAmount, 
      monAmount: monAmount, 
      tueAmount: tueAmount, 
      wedAmount: wedAmount, 
      thurAmount: thurAmount, 
      friAmount: friAmount, 
      satAmount: satAmount
    );
    myBarData.initialiseBarData();

    return BarChart(
      BarChartData(
        maxY: maxY,
        minY: 0,
        barGroups: myBarData.barData.map(
          (data) => BarChartGroupData(
            x: data.x,
            barRods: [
              BarChartRodData(
                toY: data.y,
              )
            ],
          )
        ).toList(),
      )
    );
  }
}