import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Function(PointerDownEvent)? onTapOutside;
  final String? Function(String?)? validator;
  final TextAlign textAlign;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final VoidCallback? onSuffixIconTap;
  final bool readOnly;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? labelStyle;
  final VoidCallback? onTap;
  final InputDecoration? decoration;
  final bool obscureText;
  final String? hintText;
  final EdgeInsetsGeometry? contentPadding;
  final bool filled;
  final Color? fillColor;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final TextStyle? style; // <<< 1. ADD THIS LINE

  const MyTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.onTapOutside,
    this.validator,
    this.textAlign = TextAlign.start,
    this.suffixIcon,
    this.prefixIcon,
    this.onSuffixIconTap,
    this.readOnly = false,
    this.minLines,
    this.maxLines,
    this.keyboardType,
    this.inputFormatters,
    this.labelStyle,
    this.onTap,
    this.decoration,
    this.obscureText = false,
    this.hintText,
    this.contentPadding,
    this.filled = false,
    this.fillColor,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.focusNode,
    this.style, // <<< 2. ADD THIS LINE
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      textAlign: textAlign,
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      onTapOutside: onTapOutside,
      minLines: minLines ?? 1,
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      style: style ??
          TextStyle(fontSize: 12, color: isDark ? Colors.white : Colors.black),
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      focusNode: focusNode,
      decoration: decoration ??
          InputDecoration(
            labelText: labelText,
            labelStyle: labelStyle ??
                TextStyle(
                    fontSize: 12, color: isDark ? Colors.white54 : Colors.grey),
            hintText: hintText,
            contentPadding: contentPadding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
                color: Colors.blue,
              ),
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    onPressed: onSuffixIconTap,
                    icon: suffixIcon!,
                  )
                : null,
            filled: filled,
            fillColor: fillColor,
          ),
    );
  }
}
