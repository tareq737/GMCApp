import 'package:flutter/material.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';

class SearchRow extends StatelessWidget {
  final TextEditingController textEditingController;
  final VoidCallback onSearch;

  const SearchRow({
    super.key,
    required this.textEditingController,
    required this.onSearch,
  });

  void _handleSearch(BuildContext context) {
    if (textEditingController.text.trim().isEmpty) {
      showSnackBar(
          context: context, content: 'يرجى تعبئة خانة البحث', failure: true);
      return;
    }
    onSearch(); // Proceed with search if input is valid
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Expanded(
                flex: 8,
                child: MyTextField(
                  labelText: 'بحث',
                  controller: textEditingController,
                )),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: IconButton(
                onPressed: () => _handleSearch(context),
                icon: const Icon(Icons.manage_search, size: 28),
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
