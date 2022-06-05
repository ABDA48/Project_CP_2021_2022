import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart ' as charts;
import 'package:social_network_ecommerce/widgets/PieCharSeries.dart';
class SimpleChart extends StatelessWidget {
  final List<PieCharSeries> data;
  SimpleChart({required this.data});


  @override
  Widget build(BuildContext context) {
    List<charts.Series<PieCharSeries,int>>series=[
      new charts.Series(
          id: 'ChartPie',
          domainFn: (PieCharSeries s, _) => s.sentiment,
    measureFn: (PieCharSeries s, _) => s.value,

    data: data,
        labelAccessorFn: (PieCharSeries row, _) => '${row.value}',
      )

    ];
    return SizedBox(

      child: new charts.PieChart(series,animate: false,

      ),
    );
  }

}