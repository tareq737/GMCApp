import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWithSuggestions extends StatelessWidget {
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
  final List<String> suggestions; // List of suggestions for autocomplete

  const TextFieldWithSuggestions({
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
    this.suggestions = const [], // Initialize suggestions as an empty list
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return suggestions.where((String option) {
          return option
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        controller.text = selection;
      },
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController fieldTextEditingController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        fieldTextEditingController.addListener(
          () {
            controller.text = fieldTextEditingController.text;
          },
        );
        return TextFormField(
          textAlign: textAlign,
          controller: fieldTextEditingController,
          focusNode: focusNode,
          readOnly: readOnly,
          minLines: minLines ?? 1,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: const TextStyle(fontSize: 12),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: labelStyle ??
                TextStyle(
                    fontSize: 12, color: isDark ? Colors.white : Colors.black),
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
      },
    );
  }
}
