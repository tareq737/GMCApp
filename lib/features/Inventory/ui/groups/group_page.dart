import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/Inventory/bloc/inventory_bloc.dart';
import 'package:gmcappclean/features/Inventory/models/groups_model.dart';
import 'package:gmcappclean/features/Inventory/services/inventory_services.dart';
import 'package:gmcappclean/features/Inventory/ui/groups/groups_list_page.dart';
import 'package:gmcappclean/init_dependencies.dart';

class GroupPage extends StatelessWidget {
  final GroupsModel? groupModel;

  const GroupPage({super.key, this.groupModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryBloc(InventoryServices(
        apiClient: getIt<ApiClient>(),
        authInteractor: getIt<AuthInteractor>(),
      )),
      child: Builder(
        builder: (context) {
          return GroupPageChild(groupModel: groupModel);
        },
      ),
    );
  }
}

class GroupPageChild extends StatefulWidget {
  final GroupsModel? groupModel;
  const GroupPageChild({super.key, this.groupModel});

  @override
  State<GroupPageChild> createState() => _GroupPageChildState();
}

class _GroupPageChildState extends State<GroupPageChild> {
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _parentCodeNameController = TextEditingController();
  final _parentCodeNameFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  bool _isSelectingParentGroup = false;
  bool _isFormSubmitting = false; // ADD THIS FLAG
  int? _selectedParentGroupId;

  @override
  void initState() {
    super.initState();
    if (widget.groupModel != null) {
      _codeController.text = widget.groupModel!.code ?? '';
      _nameController.text = widget.groupModel!.name ?? '';
      _parentCodeNameController.text =
          widget.groupModel!.parent_code_name ?? '';
      _selectedParentGroupId = widget.groupModel!.id;
    }
    _parentCodeNameFocusNode.addListener(_onParentCodeNameFocusChange);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _parentCodeNameController.dispose();
    _parentCodeNameFocusNode.removeListener(_onParentCodeNameFocusChange);
    _parentCodeNameFocusNode.dispose();
    super.dispose();
  }

  void _onParentCodeNameFocusChange() {
    if (_isFormSubmitting) return; // BLOCK SEARCH WHILE SUBMITTING

    if (!_parentCodeNameFocusNode.hasFocus &&
        _parentCodeNameController.text.isNotEmpty &&
        !_isSelectingParentGroup) {
      context.read<InventoryBloc>().add(
            SearchGroups(
              search: _parentCodeNameController.text,
              page: 1,
            ),
          );
    } else if (!_parentCodeNameFocusNode.hasFocus &&
        _parentCodeNameController.text.isEmpty) {
      setState(() {
        _selectedParentGroupId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(widget.groupModel == null ? 'إضافة مجموعة' : 'تعديل مجموعة'),
        ),
        body: BlocConsumer<InventoryBloc, InventoryState>(
          listener: (context, state) {
            if (state is InventorySuccess<GroupsModel>) {
              showSnackBar(
                context: context,
                content:
                    'تم ${widget.groupModel == null ? 'إضافة' : 'تعديل'} المجموعة: ${widget.groupModel!.name}',
                failure: false,
              );
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const GroupsListPage(),
                ),
              );
            } else if (state is InventorySuccess<List<GroupsModel>>) {
              if (state.result.length == 1) {
                _isSelectingParentGroup = true;
                final selectedGroup = state.result.first;
                setState(() {
                  _parentCodeNameController.text =
                      '${selectedGroup.code ?? ''}-${selectedGroup.name ?? ''}';
                  _selectedParentGroupId = selectedGroup.id;
                });
                FocusScope.of(context).unfocus();
                _isSelectingParentGroup = false;
              } else if (state.result.length > 1) {
                _showGroupSelectionDialog(context, state.result);
              } else {
                _parentCodeNameController.clear();
                setState(() {
                  _selectedParentGroupId = null;
                });
                showSnackBar(
                  context: context,
                  content: 'لم يتم العثور على مجموعات مطابقة.',
                  failure: true,
                );
              }
            } else if (state is InventoryError) {
              showSnackBar(
                context: context,
                content: state.errorMessage,
                failure: true,
              );
              if (_parentCodeNameController.text.isEmpty) {
                setState(() {
                  _selectedParentGroupId = null;
                });
              }
            }
          },
          builder: (context, state) {
            bool isLoadingSearch = state is InventoryLoading &&
                _parentCodeNameFocusNode.hasFocus &&
                state is! InventorySuccess<GroupsModel> &&
                state is! InventoryError;

            bool isLoadingFormSubmission = state is InventoryLoading &&
                (context.read<InventoryBloc>().state is InventoryLoading &&
                    context.read<InventoryBloc>().state
                        is! InventorySuccess<List<GroupsModel>>);

            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  spacing: 20,
                  children: [
                    const SizedBox(height: 20),
                    MyTextField(
                      controller: _codeController,
                      labelText: 'رمز المجموعة',
                      validator: (value) =>
                          value!.isEmpty ? 'يجب إدخال رمز المجموعة' : null,
                    ),
                    MyTextField(
                      controller: _nameController,
                      labelText: 'اسم المجموعة',
                      validator: (value) =>
                          value!.isEmpty ? 'يجب إدخال اسم المجموعة' : null,
                    ),
                    MyTextField(
                      controller: _parentCodeNameController,
                      labelText: 'المجموعة الأب',
                      focusNode: _parentCodeNameFocusNode,
                      suffixIcon: isLoadingSearch
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : (_parentCodeNameController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _parentCodeNameController.clear();
                                      _selectedParentGroupId = null;
                                    });
                                  },
                                )
                              : null),
                    ),
                    const SizedBox(height: 30),
                    isLoadingFormSubmission
                        ? const Center(child: Loader())
                        : Mybutton(
                            text: widget.groupModel == null ? 'إضافة' : 'تعديل',
                            onPressed: () {
                              if (!_isFormSubmitting) {
                                _submitForm();
                              }
                            }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      setState(() {
        _isFormSubmitting = true;
      });

      final model = _fillModelFromForm();
      if (widget.groupModel == null) {
        context.read<InventoryBloc>().add(AddGroup(groupsModel: model));
      } else {
        context
            .read<InventoryBloc>()
            .add(UpdateGroup(groupsModel: model, id: widget.groupModel!.id));
      }

      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _isFormSubmitting = false;
        });
      });
    }
  }

  GroupsModel _fillModelFromForm() {
    return GroupsModel(
      id: widget.groupModel?.id ?? 0,
      code: _codeController.text,
      name: _nameController.text,
      parent: _selectedParentGroupId,
      parent_code_name: _parentCodeNameController.text.isNotEmpty
          ? _parentCodeNameController.text
          : null,
    );
  }

  void _showGroupSelectionDialog(
      BuildContext context, List<GroupsModel> groups) async {
    _isSelectingParentGroup = true;

    final selectedGroup = await showDialog<GroupsModel>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('اختر مجموعة الأب'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: groups.length,
              itemBuilder: (BuildContext context, int index) {
                final group = groups[index];
                return ListTile(
                  title: Text(group.name ?? ''),
                  subtitle: Text(group.code ?? ''),
                  onTap: () {
                    Navigator.pop(context, group);
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (selectedGroup != null) {
      setState(() {
        _parentCodeNameController.text =
            '${selectedGroup.code ?? ''}-${selectedGroup.name ?? ''}';
        _selectedParentGroupId = selectedGroup.id;
      });
      FocusScope.of(context).unfocus();
    } else {
      setState(() {
        _parentCodeNameController.clear();
        _selectedParentGroupId = null;
      });
    }

    _isSelectingParentGroup = false;
  }
}
