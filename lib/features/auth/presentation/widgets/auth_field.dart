import 'package:flutter/material.dart';

// class AuthField extends StatelessWidget {
//   final String hintText;
//   final TextEditingController controller;
//   final bool isObscureText;
//   const AuthField({
//     super.key,
//     required this.hintText,
//     required this.controller,
//     this.isObscureText = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         hintText: hintText,
//       ),
//       validator: (value) {
//         if (value!.isEmpty) {
//           return '$hintText مفقود';
//         } else {
//           return null;
//         }
//       },
//       obscureText: isObscureText,
//     );
//   }
// }

class AuthField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;

  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
  });

  @override
  _AuthFieldState createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  TextDirection _textDirection = TextDirection.ltr; // Default is LTR

  void _updateTextDirection(String value) {
    final bool isArabic = RegExp(r'^[\u0600-\u06FF]').hasMatch(value);
    setState(() {
      _textDirection = isArabic ? TextDirection.rtl : TextDirection.ltr;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      textDirection: _textDirection, // Set text direction dynamically
      decoration: InputDecoration(
        hintText: widget.hintText,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return '${widget.hintText} مفقود';
        }
        return null;
      },
      obscureText: widget.isObscureText,
      onChanged: _updateTextDirection, // Detect text change
    );
  }
}
