import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/features/production_management/total_production/bloc/total_production_bloc.dart';
import 'package:gmcappclean/features/production_management/total_production/services/total_production_services.dart';
import 'package:gmcappclean/init_dependencies.dart';

class ExportExcelTasksPage extends StatefulWidget {
  final String department;
  final String departmentDisplayName;

  const ExportExcelTasksPage({
    super.key,
    required this.department,
    required this.departmentDisplayName,
  });

  @override
  State<ExportExcelTasksPage> createState() => _ExportExcelTasksPageState();
}

class _ExportExcelTasksPageState extends State<ExportExcelTasksPage> {
  late TotalProductionBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = TotalProductionBloc(
      TotalProductionServices(
        apiClient: getIt<ApiClient>(),
        authInteractor: getIt<AuthInteractor>(),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(ExportExcelTasks(department: widget.department));
    });
  }

  Future<void> _saveFile(Uint8List bytes) async {
    try {
      final directory = await getTemporaryDirectory();

      // Use the Arabic display name as the file name
      final fileName = 'برنامج فردي ${widget.departmentDisplayName}.xlsx';

      final path = '${directory.path}/$fileName';

      final file = File(path);
      await file.writeAsBytes(bytes);

      await _showDialog('نجاح', 'تم حفظ الملف وسيتم فتحه الآن');

      final result = await OpenFilex.open(path);

      if (result.type != ResultType.done) {
        await _showDialog('Error', 'لم يتم فتح الملف: ${result.message}');
      }

      Navigator.of(context).pop(); // Close the page
    } catch (e) {
      await _showDialog('Error', 'Failed to save/open file:\n$e');
      Navigator.of(context).pop();
    }
  }

  Future<void> _showDialog(String title, String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close the dialog
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<TotalProductionBloc, TotalProductionState>(
        listener: (context, state) async {
          if (state is TotalProductionSuccess) {
            await _saveFile(state.result);
          } else if (state is TotalProductionError) {
            await _showDialog('Export Failed', state.errorMessage);
            Navigator.of(context).pop();
          }
        },
        child: const Scaffold(
          body: Center(child: Loader()),
        ),
      ),
    );
  }
}
