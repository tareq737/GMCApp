import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';

class SearchDialog extends StatefulWidget {
  final List<String> items;
  final String title;
  final String initialSelection;

  const SearchDialog({
    super.key,
    required this.items,
    required this.title,
    required this.initialSelection,
  });

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  late List<String> filteredItems;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = List.from(widget.items);
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: AlertDialog(
        title: Text(widget.title),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'بحث',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        // Return the selected item
                        Navigator.of(context).pop(item);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }
}

class SearchableDropdown extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final List<String> items;

  const SearchableDropdown({
    super.key,
    required this.controller,
    required this.labelText,
    required this.items,
  });

  Future<void> _showSelectionDialog(BuildContext context) async {
    final selectedItem = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        // Use the generic SearchDialog
        return SearchDialog(
          items: items,
          title: 'اختر الـ $labelText',
          initialSelection: controller.text,
        );
      },
    );

    if (selectedItem != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.text = selectedItem;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      controller: controller,
      labelText: labelText,
      readOnly: true,
      onTap: () => _showSelectionDialog(context),
      suffixIcon: const Icon(Icons.arrow_drop_down),
    );
  }
}
