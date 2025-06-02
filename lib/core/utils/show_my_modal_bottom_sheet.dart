import 'package:flutter/material.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';

void showMyModalBottomSheet(
  BuildContext context, {
  required List<Mybutton> buttons,
  required TextEditingController codeController,
  required TextEditingController nameController,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                MyTextField(
                  controller: codeController,
                  labelText: 'رمز المستودع',
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: nameController,
                  labelText: 'اسم المستودع',
                ),
                const SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: buttons),
                const SizedBox(
                  height: 10,
                ),
                Mybutton(
                    text: 'إغلاق',
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ),
          ),
        ),
      );
    },
  );
}

class ButtonDetails {
  final String label;
  final VoidCallback? onPressed;
  final void Function(BuildContext context)? onPressedWithContext;

  ButtonDetails(
      {required this.label, this.onPressed, this.onPressedWithContext});
}
