import 'package:flutter/material.dart';

class MyDropdownButton extends StatefulWidget {
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final String labelText;
  final ValueChanged<String?>? onChanged;
  final bool isEnabled;
  final bool showClearButton;
  final FormFieldValidator<String?>? validator;

  const MyDropdownButton({
    super.key,
    required this.value,
    required this.items,
    required this.labelText,
    this.onChanged,
    this.isEnabled = true,
    this.showClearButton = true,
    this.validator,
  });

  @override
  MyDropdownButtonState createState() => MyDropdownButtonState();
}

class MyDropdownButtonState extends State<MyDropdownButton> {
  String? currentValue;

  @override
  void initState() {
    super.initState();
    if (widget.items.any((item) => item.value == widget.value)) {
      currentValue = widget.value;
    } else {
      currentValue = null;
    }
  }

  @override
  void didUpdateWidget(covariant MyDropdownButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items.any((item) => item.value == widget.value)) {
      currentValue = widget.value;
    } else {
      currentValue = null;
    }
  }

  void _handleChange(String? newValue) {
    if (!widget.isEnabled) return;
    setState(() {
      currentValue = newValue;
    });
    widget.onChanged?.call(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return FormField<String>(
      initialValue: currentValue,
      validator: widget.validator,
      builder: (FormFieldState<String> state) {
        currentValue = state.value;
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            height: 48,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: widget.labelText,
                errorText: state.errorText,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 2.0, color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2.0,
                      color: state.hasError ? Colors.red : Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2.0,
                      color: state.hasError
                          ? Colors.red
                          : Theme.of(context).primaryColor),
                ),
                labelStyle: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.white54 : Colors.grey),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0),
                suffixIcon: widget.isEnabled &&
                        widget.showClearButton &&
                        currentValue != null
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _handleChange(null);
                          state.didChange(null);
                        },
                      )
                    : null,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: currentValue,
                  items: widget.items.map((item) {
                    return DropdownMenuItem<String>(
                      value: item.value,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: item.child is Text
                            ? Text(
                                (item.child as Text).data ?? '',
                                style: const TextStyle(
                                  fontFamily: 'CustomFont',
                                  fontSize: 12,
                                ),
                              )
                            : item.child,
                      ),
                    );
                  }).toList(),
                  onChanged: widget.isEnabled
                      ? (newValue) {
                          _handleChange(newValue);
                          state.didChange(newValue); // Notify FormField
                        }
                      : null,
                  isExpanded: true,
                  iconSize: 24,
                  disabledHint: Text(
                    currentValue ?? '',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white54 : Colors.black54,
                    ),
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: widget.isEnabled
                        ? (isDarkMode ? Colors.white : Colors.black)
                        : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
