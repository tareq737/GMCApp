// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/features/Exchange%20Rate/bloc/exchange_rate_bloc.dart';
import 'package:gmcappclean/features/Exchange%20Rate/models/char_model.dart';
import 'package:gmcappclean/features/Exchange%20Rate/services/rate_service.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:ui' as ui;

class RateChartPage extends StatefulWidget {
  final String date1;
  final String date2;

  const RateChartPage({
    super.key,
    required this.date1,
    required this.date2,
  });

  @override
  State<RateChartPage> createState() => _RateChartPageState();
}

class _RateChartPageState extends State<RateChartPage> {
  bool showUSD = true;
  bool showOunce = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExchangeRateBloc(
        RateService(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>(),
        ),
      )..add(
          GetAllRatesOnlyUSD(
            start: widget.date1,
            end: widget.date2,
            usd: true,
            ounce: true,
          ),
        ),
      child: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('مخطط تغير الأسعار'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<ExchangeRateBloc, ExchangeRateState>(
              builder: (context, state) {
                if (state is RatesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RatesSuccess<List<CharModel>>) {
                  final rates = state.result;

                  if (rates.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.solidClipboard,
                            size: 50,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'لا توجد بيانات لعرضها.',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: showUSD,
                            onChanged: (value) {
                              setState(() {
                                showUSD = value ?? true;
                              });
                            },
                          ),
                          const Text('الدولار'),
                          const SizedBox(width: 20),
                          Checkbox(
                            value: showOunce,
                            onChanged: (value) {
                              setState(() {
                                showOunce = value ?? true;
                              });
                            },
                          ),
                          const Text('أونصة الذهب'),
                        ],
                      ),
                      Expanded(child: _buildCompactChart(rates)),
                      const SizedBox(height: 20),
                      Text(
                        'من ${rates.last.date} إلى ${rates.first.date}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                } else if (state is RatesError) {
                  return Center(child: Text("خطأ: ${state.errorMessage}"));
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactChart(List<CharModel> rates) {
    rates.sort((a, b) => a.date.compareTo(b.date));

    final usdRates = rates.where((rate) {
      final value = double.tryParse(rate.usd_sell ?? '0') ?? 0;
      return value != 0;
    }).toList();

    final goldRates = rates.where((rate) {
      final value = double.tryParse(rate.gold_ounce ?? '0') ?? 0;
      return value != 0;
    }).toList();

    final List<CartesianSeries<CharModel, DateTime>> series = [];

    if (showUSD) {
      series.add(LineSeries<CharModel, DateTime>(
        name: 'الدولار',
        dataSource: usdRates,
        xValueMapper: (rate, _) => DateTime.parse(rate.date),
        yValueMapper: (rate, _) => double.tryParse(rate.usd_sell ?? '0') ?? 0,
        color: Colors.green,
        width: 2,
        markerSettings: MarkerSettings(
          isVisible: usdRates.length < 15,
          shape: DataMarkerType.circle,
        ),
      ));
    }

    if (showOunce) {
      series.add(LineSeries<CharModel, DateTime>(
        name: 'أونصة الذهب',
        dataSource: goldRates,
        xValueMapper: (rate, _) => DateTime.parse(rate.date),
        yValueMapper: (rate, _) => double.tryParse(rate.gold_ounce ?? '0') ?? 0,
        color: Colors.amber,
        width: 2,
        markerSettings: MarkerSettings(
          isVisible: goldRates.length < 15,
          shape: DataMarkerType.diamond,
        ),
      ));
    }

    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat('dd/MM/yyyy'),
        intervalType: DateTimeIntervalType.auto,
      ),
      primaryYAxis: NumericAxis(
        numberFormat: NumberFormat('#,##0'),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      legend: Legend(isVisible: true, position: LegendPosition.bottom),
      series: series,
    );
  }
}
