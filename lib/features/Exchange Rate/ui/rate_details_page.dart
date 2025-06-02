import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gmcappclean/features/Exchange%20Rate/models/rate_model.dart';
import 'dart:ui' as ui;

class RateDetailsPage extends StatelessWidget {
  final RateModel rateModel;

  const RateDetailsPage({super.key, required this.rateModel});

  String formatCurrency(double value) {
    // Use the NumberFormat class to format the number with commas
    final NumberFormat currencyFormat = NumberFormat('#,##0.00', 'en_US');
    return currencyFormat.format(value);
  }

  Widget sectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget rateTile(String label, String value, {Color? color}) {
    return ListTile(
      title: Text(label),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    );
  }

  double safeParse(String? value) {
    return double.tryParse(value ?? '') ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('التفاصيل'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              rateTile('📅 التاريخ', rateModel.date),
              rateTile('⏰ الوقت', rateModel.time),
              const Divider(),
              sectionTitle('💵 الدولار الأمريكي (USD)', Colors.green),
              rateTile(
                'شراء',
                formatCurrency(safeParse(rateModel.usd_buy)),
                color: Colors.green,
              ),
              rateTile(
                'بيع',
                formatCurrency(safeParse(rateModel.usd_sell)),
                color: Colors.green[700],
              ),
              const Divider(),
              sectionTitle('💶 اليورو (EUR)', Colors.blue),
              rateTile(
                'شراء',
                formatCurrency(safeParse(rateModel.euro_buy)),
                color: Colors.blue,
              ),
              rateTile(
                'بيع',
                formatCurrency(safeParse(rateModel.euro_sell)),
                color: Colors.blue[700],
              ),
              const Divider(),
              sectionTitle('🇸🇦 الريال السعودي (SAR)', Colors.orange),
              rateTile(
                'شراء',
                formatCurrency(safeParse(rateModel.sar_buy)),
                color: Colors.orange,
              ),
              rateTile(
                'بيع',
                formatCurrency(safeParse(rateModel.sar_sell)),
                color: Colors.orange[700],
              ),
              const Divider(),
              sectionTitle('🇦🇪 الدرهم الإماراتي (AED)', Colors.teal),
              rateTile(
                'شراء',
                formatCurrency(safeParse(rateModel.aed_buy)),
                color: Colors.teal,
              ),
              rateTile(
                'بيع',
                formatCurrency(safeParse(rateModel.aed_sell)),
                color: Colors.teal[700],
              ),
              const Divider(),
              sectionTitle('🏅 أسعار الذهب', Colors.amber[800]!),
              rateTile(
                'ذهب عيار 18',
                formatCurrency(safeParse(rateModel.gold_18)),
                color: Colors.amber[700],
              ),
              rateTile(
                'ذهب عيار 21',
                formatCurrency(safeParse(rateModel.gold_21)),
                color: Colors.amber[700],
              ),
              rateTile(
                'ذهب عيار 24',
                formatCurrency(safeParse(rateModel.gold_24)),
                color: Colors.amber[700],
              ),
              rateTile(
                'أونصة الذهب',
                formatCurrency(safeParse(rateModel.gold_ounce)),
                color: Colors.amber[700],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
