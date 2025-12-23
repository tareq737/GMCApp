import 'package:flutter/material.dart';
import 'package:gmcappclean/features/surveys/models/sales/pros_cons_model.dart';

class MultiSelectionChips extends StatefulWidget {
  final List<ProsConsItem> items;
  final List<int> selectedIds;
  final ValueChanged<List<int>> onSelectionChanged;
  final String label;
  final double? chipSpacing;
  final double? chipRunSpacing;

  const MultiSelectionChips({
    Key? key,
    required this.items,
    required this.selectedIds,
    required this.onSelectionChanged,
    required this.label,
    this.chipSpacing = 8,
    this.chipRunSpacing = 8,
  }) : super(key: key);

  @override
  _MultiSelectionChipsState createState() => _MultiSelectionChipsState();
}

class _MultiSelectionChipsState extends State<MultiSelectionChips> {
  late List<int> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = List<int>.from(widget.selectedIds);
  }

  @override
  void didUpdateWidget(MultiSelectionChips oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIds != widget.selectedIds) {
      setState(() {
        _selectedIds = List<int>.from(widget.selectedIds);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
        ),
        const SizedBox(height: 8),
        if (widget.items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'لا توجد عناصر متاحة',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          Wrap(
            spacing: widget.chipSpacing!,
            runSpacing: widget.chipRunSpacing!,
            children: widget.items.map((item) {
              final isSelected = _selectedIds.contains(item.id);

              return _buildChoiceChip(
                item: item,
                isSelected: isSelected,
                theme: theme,
                isDark: isDark,
                colorScheme: colorScheme,
              );
            }).toList(),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildChoiceChip({
    required ProsConsItem item,
    required bool isSelected,
    required ThemeData theme,
    required bool isDark,
    required ColorScheme colorScheme,
  }) {
    // 🌱 Green palette (selected)
    final greenBgLight = Colors.green.withOpacity(0.15);
    final greenBgDark = Colors.green.withOpacity(0.30);
    final greenText = Colors.green.shade700;
    final greenTextDark = Colors.green.shade300;

    // 🎨 Unselected
    final lightBg = Colors.grey.shade100;
    final darkBg = colorScheme.surfaceVariant.withOpacity(0.6);
    final lightBorder = Colors.grey.shade300;
    final darkBorder = colorScheme.outline.withOpacity(0.4);

    return ChoiceChip(
      label: Text(
        item.detail,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            if (!_selectedIds.contains(item.id)) {
              _selectedIds.add(item.id);
            }
          } else {
            _selectedIds.remove(item.id);
          }
        });
        widget.onSelectionChanged(List<int>.from(_selectedIds));
      },
      backgroundColor: isSelected
          ? (isDark ? greenBgDark : greenBgLight)
          : (isDark ? darkBg : lightBg),
      selectedColor: isDark ? greenBgDark : greenBgLight,
      surfaceTintColor: Colors.transparent,
      labelStyle: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        color: isSelected
            ? (isDark ? greenTextDark : greenText)
            : theme.colorScheme.onSurface,
      ),
      side: isSelected
          ? BorderSide(
              color: isDark ? greenTextDark : greenText,
              width: 1,
            )
          : BorderSide(
              color: isDark ? darkBorder : lightBorder,
              width: 1,
            ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 0,
      pressElevation: 1,
      showCheckmark: false,
      shadowColor: Colors.transparent,
      selectedShadowColor: Colors.transparent,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
