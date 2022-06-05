import 'package:charts_flutter/flutter.dart ' as charts;

class ChartTimeseries{
  final DateTime date;
  final int price;
  final charts.Color barColor;
  ChartTimeseries({required this.date,required this.price,required this.barColor});
}