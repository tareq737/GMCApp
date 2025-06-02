import 'package:flutter/material.dart';

Future<int> selectYear(BuildContext context) async {
  const int minYear = 1900;
  const int maxYear = 2010;

  int selectedYear = minYear;

  final int? year = await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text('Select Year'),
            content: SizedBox(
              height: 200,
              child: ListWheelScrollView.useDelegate(
                itemExtent: 50,
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    final year = minYear + index;
                    if (year > maxYear) return null;
                    return Center(
                      child: Text(
                        year.toString(),
                        style: TextStyle(
                          fontSize: 24,
                          color:
                              year == selectedYear ? Colors.blue : Colors.white,
                        ),
                      ),
                    );
                  },
                  childCount: maxYear - minYear + 1,
                ),
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedYear = minYear + index;
                  });
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(selectedYear);
                },
                child: const Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    },
  );

  if (year != null) {
    // setState(() {
    //   _clientYearOfBirthController.text = year.toString();
    // });

    return year;
  } else {
    return 0;
  }
}
