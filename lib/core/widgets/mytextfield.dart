import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Function(PointerDownEvent)? onTapOutside;
  final String? Function(String?)? validator;
  final TextAlign textAlign;
  final Icon? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final bool readOnly;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? labelStyle;
  final VoidCallback? onTap;

  const MyTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.onTapOutside,
    this.validator,
    this.textAlign = TextAlign.start,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.readOnly = false,
    this.minLines,
    this.maxLines,
    this.keyboardType,
    this.inputFormatters,
    this.labelStyle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: textAlign,
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      minLines: minLines ?? 1,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(fontSize: 13),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: Colors.grey,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: Colors.grey,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: Colors.grey,
          ),
        ),
        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: onSuffixIconTap,
                child: suffixIcon,
              )
            : null,
      ),
      validator: validator,
    );
  }
}
