import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class StoreItemsPieChart extends StatelessWidget {
  final double paints;
  final double healthy;
  final double hardware;
  final double electrical;
  final double buildingMaterials;

  const StoreItemsPieChart({
    super.key,
    required this.paints,
    required this.healthy,
    required this.hardware,
    required this.electrical,
    required this.buildingMaterials,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "دهانات": paints,
      "صحية": healthy,
      "خرداوات": hardware,
      "كهربائيات": electrical,
      "مواد البناء": buildingMaterials,
    };

    return PieChart(
      dataMap: dataMap,
      chartRadius: 90,
      chartValuesOptions: const ChartValuesOptions(
        showChartValues: false,
      ),
      legendOptions: const LegendOptions(
        showLegends: false,
      ),
      colorList: const [
        Colors.red,
        Colors.green,
        Colors.blue,
        Colors.orange,
        Colors.purple,
      ],
    );
  }
}
