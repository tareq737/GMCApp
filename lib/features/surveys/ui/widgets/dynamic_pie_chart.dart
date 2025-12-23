import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class DynamicPieChart extends StatelessWidget {
  final Map<String, double> dataMap;
  final List<Color> colors;
  final double chartRadius;

  const DynamicPieChart({
    super.key,
    required this.dataMap,
    required this.colors,
    this.chartRadius = 120, // Default value of 120
  });

  @override
  Widget build(BuildContext context) {
    // If all values are 0, we show a grey circle so it's not "invisible"
    bool isEmpty = dataMap.values.every((v) => v == 0);

    return PieChart(
      dataMap: isEmpty ? {"Empty": 1} : dataMap,
      chartRadius: chartRadius, // Use the parameter here
      chartValuesOptions: const ChartValuesOptions(
        showChartValues: false,
      ),
      legendOptions: const LegendOptions(
        showLegends: false,
      ),
      colorList: isEmpty ? [Colors.grey.shade300] : colors,
    );
  }
}
