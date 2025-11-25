import 'package:flutter/material.dart';

class FullData extends StatelessWidget {
  final String appBarText;
  final List<Widget> listOfData;
  final List<BottomNavigationBarItem> bottomNavigationBarItems;
  final Function(int) onTap;

  final List<Widget>? appBarActions; // إضافة جديدة

  const FullData({
    super.key,
    required this.appBarText,
    required this.listOfData,
    required this.bottomNavigationBarItems,
    required this.onTap,
    this.appBarActions, // إضافتها بالكونستركتور
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(appBarText),
        actions: appBarActions, // إضافتها هنا
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: listOfData
                    .map((widget) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: widget,
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavigationBarItems,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
