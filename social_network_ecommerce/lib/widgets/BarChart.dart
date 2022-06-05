import 'package:flutter/material.dart';
import 'package:social_network_ecommerce/widgets/BarCharSeries.dart';
import 'package:charts_flutter/flutter.dart ' as charts;

class Timeseries extends StatelessWidget {
  final List<ChartTimeseries> data;
  Timeseries({required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ChartTimeseries,DateTime>> series=[
      charts.Series(
        id: "chart",
        data: data,
        domainFn: (ChartTimeseries series,_)=>series.date,
        measureFn: (ChartTimeseries series,_)=>series.price,
        colorFn: (ChartTimeseries series,_)=>series.barColor
      )
    ];
    return new charts.TimeSeriesChart(series,animate: true, dateTimeFactory: const charts.LocalDateTimeFactory(),);

  }
}



