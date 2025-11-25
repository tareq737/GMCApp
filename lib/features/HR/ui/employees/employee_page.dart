import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/my_dropdown_button_widget.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/HR/bloc/hr_bloc.dart';
import 'package:gmcappclean/features/HR/models/employee_model.dart';
import 'package:gmcappclean/features/HR/services/hr_services.dart';
import 'package:gmcappclean/features/HR/ui/employees/employees_list_page.dart';
import 'package:gmcappclean/core/Pages/view_image_page.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class EmployeePage extends StatelessWidget {
  final EmployeeModel? employeeModel;

  const EmployeePage({super.key, this.employeeModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HrBloc(HrServices(
        apiClient: getIt<ApiClient>(),
        authInteractor: getIt<AuthInteractor>(),
      )),
      child: Builder(
        builder: (context) {
          return EmployeePageChild(employeeModel: employeeModel);
        },
      ),
    );
  }
}

class EmployeePageChild extends StatefulWidget {
  final EmployeeModel? employeeModel;
  const EmployeePageChild({super.key, this.employeeModel});

  @override
  State<EmployeePageChild> createState() => _EmployeePageChildState();
}

class _EmployeePageChildState extends State<EmployeePageChild> {
  final List<String> _department = [
    'الإدارة',
    'بطاقة ثانية',
    'دعم تقني',
    'الزراعة',
    'شركة النور',
    'الأولية',
    'التصنيع',
    'التعبئة',
    'التوزيع',
    'الخدمات',
    'الصيانة',
    'المبيعات',
    'المحاسبة',
    'المخبر',
    'الموارد البشرية',
    'الجاهزة',
    'ضبط جودة',
    'المشتريات',
  ];
  final List<String> maritalStatus = [
    'عازب',
    'متزوج',
    'أرملة',
    'مطلق',
    'غير محدد',
  ];
  final List<String> militaryService = [
    'أدى الخدمة',
    'لم يؤديها',
    'لم يستلم الدفتر بعد',
    'معفى',
    'مؤجل دراسياً',
    'وحيد',
  ];
  final List<String> gender = [
    'ذكر',
    'أنثى',
  ];
  final List<String> jobTitle = [
    'إداري',
    'أمين صندوق',
    'أمين مستودع المواد الأولية',
    'أمين مستودع المواد الجاهزة',
    'أمين مستودع قسم التعبئة',
    'تسويق',
    'حارس بواب',
    'خدمات',
    'دعم تقني',
    'رئيس قسم التصنيع',
    'رئيس قسم الصيانة',
    'رئيس قسم المشتريات',
    'رئيس قسم الموارد البشرية',
    'رئيس قسم دعم تقني',
    'سائق باص الموظفين',
    'سائق توزيع',
    'سكرتارية',
    'عامل قسم الزراعة',
    'عامل قسم التصنيع',
    'عامل قسم التعبئة',
    'عامل قسم الصيانة',
    'عامل قسم المواد الأولية',
    'عامل قسم المواد الجاهزة',
    'عاملة قسم التعبئة',
    'فني صيانة',
    'مبيعات',
    'محاسبة',
    'مخبري',
    'مدير عام',
    'مراقب دوام',
    'مزارع',
    'موزع',
    'موظف شركة النور',
    'موظف مشتريات',
    'موظف موارد بشرية',
  ];
  final List<String> jobRole = [
    'رئيس قسم',
    'نائب رئيس قسم',
    'موظف',
  ];
  final List<String> nationality = [
    'سوري',
    'فلسطيني',
    'عراقي',
    'مصري',
    'سوداني',
    'فلسطيني سوري',
    'فلسطيني عراقي',
  ];
  final List<String> salaryType = [
    'نظام عام',
    'إداري',
    'دون تأمينات',
    'حارس + ناطور',
    'سائقين',
  ];
  final List<String> reasonOfLeave = [
    'فصل/ أداء ضعيف',
    'لم يعجبه العمل',
    'فصل/ مشكلة سلوكية',
    'راتب قليل',
    'فرصة عمل أفضل',
    'بعد السكن',
    'مشكلة مع الإدارة',
    'سفر',
  ];
  final List<String> academicLevel = [
    'إبتدائي',
    'إعدادي',
    'ثانوي',
    'جامعي',
    'ماجستير',
    'دتوراه',
  ];
  // --- Controllers and Form State ---
  final _departmentController = TextEditingController();
  final _fingePrintCodeController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _placeOfBirthController = TextEditingController();
  final _localityController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _nationalityController = TextEditingController();
  final _genderController = TextEditingController();
  final _numberOfChildrenController = TextEditingController();
  final _maritalStatusController = TextEditingController();
  final _militaryServiceController = TextEditingController();
  final _employmentDateController = TextEditingController();
  final _quittingDateController = TextEditingController();
  final _reasonOfLeaveController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _jobRoleController = TextEditingController();
  final _localEmailController = TextEditingController();
  final _insNumberController = TextEditingController();
  final _insRegistrationDateController = TextEditingController();
  final _insCancellationDateController = TextEditingController();
  final _baseSalaryController = TextEditingController();
  final _salaryTypeController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _administrativeLeaveCountController = TextEditingController();
  final _idNumberCountController = TextEditingController();
  final _insSalaryController = TextEditingController();
  final _detailsController = TextEditingController();
  final _academicLevelController = TextEditingController();
  final _academicMajorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isWorking = false;
  bool? _smokes = false;

  // --- Image Handling ---
  File? _idImage;
  File? _empImage;
  File? _insImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickIdImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      File? compressedImage = await _compressImage(File(pickedFile.path));
      setState(() {
        _idImage = compressedImage;
      });
    }
  }

  Future<void> _pickEmpImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      File? compressedImage = await _compressImage(File(pickedFile.path));
      setState(() {
        _empImage = compressedImage;
      });
    }
  }

  Future<void> _pickInsImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      File? compressedImage = await _compressImage(File(pickedFile.path));
      setState(() {
        _insImage = compressedImage;
      });
    }
  }

  Future<File?> _compressImage(File file) async {
    // Skip compression on Windows
    if (Platform.isWindows) {
      return file; // Return the original file without compression
    }

    // Proceed with compression for other platforms (Android, iOS, etc.)
    final directory = await getTemporaryDirectory();
    final targetPath =
        '${directory.path}/${p.basename(file.path)}_compressed.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,
    );

    return result != null ? File(result.path) : null;
  }

  // --- Lifecycle and Initialization ---
  @override
  void initState() {
    super.initState();
    if (widget.employeeModel != null) {
      _initializeFormData();
    }
  }

  void _initializeFormData() {
    _departmentController.text = widget.employeeModel!.department_name ?? '';
    _fingePrintCodeController.text =
        widget.employeeModel!.finger_print_code ?? '';
    _firstNameController.text = widget.employeeModel!.first_name ?? '';
    _lastNameController.text = widget.employeeModel!.last_name ?? '';
    _fatherNameController.text = widget.employeeModel!.father_name ?? '';
    _motherNameController.text = widget.employeeModel!.mother_name ?? '';
    _dateOfBirthController.text = widget.employeeModel!.dob ?? '';
    _placeOfBirthController.text = widget.employeeModel!.pob ?? '';
    _localityController.text = widget.employeeModel!.locality ?? '';
    _nationalIdController.text = widget.employeeModel!.national_id ?? '';
    _nationalityController.text = widget.employeeModel!.nationality ?? '';
    _numberOfChildrenController.text =
        widget.employeeModel!.number_of_children?.toString() ?? '';
    _maritalStatusController.text = widget.employeeModel!.marital_status ?? '';
    _militaryServiceController.text =
        widget.employeeModel!.military_service ?? '';
    _employmentDateController.text =
        widget.employeeModel!.employment_date ?? '';
    _quittingDateController.text = widget.employeeModel!.quitting_date ?? '';
    _reasonOfLeaveController.text = widget.employeeModel!.reason_of_leave ?? '';
    _genderController.text = widget.employeeModel!.gender ?? '';
    _phoneNumberController.text = widget.employeeModel!.phone_number ?? '';
    _addressController.text = widget.employeeModel!.address ?? '';
    _jobTitleController.text = widget.employeeModel!.job_title ?? '';
    _jobRoleController.text = widget.employeeModel!.job_role ?? '';
    _localEmailController.text = widget.employeeModel!.local_email ?? '';
    _insNumberController.text = widget.employeeModel!.ins_number ?? '';
    _insRegistrationDateController.text =
        widget.employeeModel!.ins_registration_date ?? '';
    _insCancellationDateController.text =
        widget.employeeModel!.ins_cancellation_date ?? '';
    _administrativeLeaveCountController.text =
        widget.employeeModel!.max_admin_leaves ?? '';
    _baseSalaryController.text = widget.employeeModel!.base_salary ?? '';
    _salaryTypeController.text = widget.employeeModel!.salary_type ?? '';
    _idNumberCountController.text = widget.employeeModel!.ID_number ?? '';
    _insSalaryController.text = widget.employeeModel!.ins_salary ?? '';
    _detailsController.text = widget.employeeModel!.details ?? '';
    _academicLevelController.text = widget.employeeModel!.academic_level ?? '';
    _academicMajorController.text = widget.employeeModel!.academic_major ?? '';
    _isWorking = widget.employeeModel!.is_working ?? false;
    _smokes = widget.employeeModel!.smokes ?? false;
  }

  @override
  void dispose() {
    final controllers = [
      _departmentController,
      _fingePrintCodeController,
      _firstNameController,
      _lastNameController,
      _fatherNameController,
      _motherNameController,
      _dateOfBirthController,
      _placeOfBirthController,
      _localityController,
      _nationalIdController,
      _nationalityController,
      _genderController,
      _numberOfChildrenController,
      _maritalStatusController,
      _militaryServiceController,
      _employmentDateController,
      _quittingDateController,
      _reasonOfLeaveController,
      _jobTitleController,
      _jobRoleController,
      _localEmailController,
      _insNumberController,
      _insRegistrationDateController,
      _insCancellationDateController,
      _baseSalaryController,
      _salaryTypeController,
      _phoneNumberController,
      _addressController,
      _administrativeLeaveCountController,
      _idNumberCountController,
      _insSalaryController,
      _detailsController,
      _academicLevelController,
      _academicMajorController,
    ];

    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // --- UI Helper Methods ---

  Widget _buildFieldRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: children
            .expand((widget) => [widget, const SizedBox(width: 10)])
            .toList()
          ..removeLast(),
      ),
    );
  }

  Card _buildInfoCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onTap,
  }) {
    return MyTextField(
      readOnly: true,
      controller: controller,
      labelText: label,
      onTap: onTap,
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Widget _buildEmploymentStatus() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Icon(
                _isWorking ? Icons.work : Icons.work_off,
                color: _isWorking ? Colors.green : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'حالة العمل',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Switch(
            value: _isWorking,
            onChanged: (value) {
              // Check if trying to set to not working without quitting date
              if (value == false && _quittingDateController.text.isEmpty) {
                _showQuittingDateRequiredDialog();
                return;
              }
              setState(() => _isWorking = value);
            },
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  void _showQuittingDateRequiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: AlertDialog(
            title: const Text('تاريخ الاستقالة مطلوب'),
            content:
                const Text('يجب إدخال تاريخ الاستقالة قبل تعطيل حالة العمل.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('موافق'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSmokingStatus() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: CheckboxListTile(
        title: const Text(
          'مدخن',
          style: TextStyle(fontSize: 14),
        ),
        value: _smokes ?? false,
        onChanged: (bool? value) {
          setState(() {
            _smokes = value;
          });
        },
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  Widget _buildConditionalDropdown({
    required TextEditingController controller,
    required List<String> options,
    required String label,
  }) {
    final isInOptions =
        options.contains(controller.text) || controller.text.isEmpty;

    return isInOptions
        ? MyDropdownButton(
            value: controller.text.isEmpty ? null : controller.text,
            items: options
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    ))
                .toList(),
            onChanged: (String? newValue) {
              setState(() {
                controller.text = newValue ?? '';
              });
            },
            labelText: label,
          )
        : MyTextField(
            controller: controller,
            labelText: label,
            readOnly: true,
          );
  }

  // --- Form Building Logic based on Orientation ---
  List<Widget> _buildFormFields(Orientation orientation) {
    if (orientation == Orientation.portrait) {
      // Portrait Layout: Mostly two-column rows
      return [
        // Basic Information Section
        _buildInfoCard(
          title: 'المعلومات الأساسية',
          children: [
            _buildFieldRow([
              Expanded(
                child: MyDropdownButton(
                  value: _departmentController.text.isEmpty
                      ? null
                      : _departmentController.text,
                  items: _department
                      .map((dep) => DropdownMenuItem(
                            value: dep,
                            child: Text(dep),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _departmentController.text = newValue ?? '';
                    });
                  },
                  labelText: 'القسم',
                ),
              ),
              Expanded(child: _buildEmploymentStatus()),
            ]),
            _buildFieldRow([
              Expanded(
                child: MyTextField(
                  controller: _firstNameController,
                  labelText: 'الاسم الأول *',
                  validator: (value) =>
                      value!.isEmpty ? 'يجب إدخال الاسم الأول' : null,
                ),
              ),
              Expanded(
                child: MyTextField(
                  controller: _lastNameController,
                  labelText: 'الكنية *',
                  validator: (value) =>
                      value!.isEmpty ? 'يجب إدخال الكنية' : null,
                ),
              ),
            ]),
            _buildFieldRow([
              Expanded(
                child: MyTextField(
                  controller: _fatherNameController,
                  labelText: 'اسم الأب',
                ),
              ),
              Expanded(
                child: MyTextField(
                  controller: _motherNameController,
                  labelText: 'اسم الأم',
                ),
              ),
            ]),
          ],
        ),

        // Personal Information Section
        _buildInfoCard(
          title: 'المعلومات الشخصية',
          children: [
            _buildFieldRow([
              Expanded(
                child: _buildDateField(
                  controller: _dateOfBirthController,
                  label: 'تاريخ الميلاد',
                  onTap: () => _selectDate(_dateOfBirthController),
                ),
              ),
              Expanded(
                child: MyTextField(
                  controller: _placeOfBirthController,
                  labelText: 'مكان الميلاد',
                ),
              ),
            ]),
            _buildFieldRow([
              Expanded(
                child: MyTextField(
                  controller: _nationalIdController,
                  labelText: 'رقم الوطني',
                ),
              ),
              Expanded(
                child: MyTextField(
                  controller: _idNumberCountController,
                  labelText: 'رقم الهوية',
                ),
              ),
            ]),
            _buildFieldRow([
              Expanded(
                child: MyTextField(
                  controller: _localityController,
                  labelText: 'الخانة',
                ),
              ),
            ]),
            _buildFieldRow([
              Expanded(
                child: _buildConditionalDropdown(
                  controller: _nationalityController,
                  options: nationality,
                  label: 'الجنسية',
                ),
              ),
              Expanded(
                child: _buildConditionalDropdown(
                  controller: _genderController,
                  options: gender,
                  label: 'الجنس',
                ),
              ),
            ]),
            _buildFieldRow([
              Expanded(
                child: _buildConditionalDropdown(
                  controller: _maritalStatusController,
                  options: maritalStatus,
                  label: 'الحالة الاجتماعية',
                ),
              ),
              Expanded(
                child: MyTextField(
                  controller: _numberOfChildrenController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  labelText: 'عدد الأولاد',
                ),
              ),
            ]),
            _buildFieldRow([
              Expanded(child: _buildSmokingStatus()),
              Expanded(
                child: _buildConditionalDropdown(
                  controller: _militaryServiceController,
                  options: militaryService,
                  label: 'خدمة العلم',
                ),
              ),
            ]),
            // Academic Information in Portrait
            _buildFieldRow([
              Expanded(
                child: _buildConditionalDropdown(
                  controller: _academicLevelController,
                  options: academicLevel,
                  label: 'المستوى الأكاديمي',
                ),
              ),
              Expanded(
                child: MyTextField(
                  controller: _academicMajorController,
                  labelText: 'التخصص الأكاديمي',
                  maxLines: 5,
                ),
              ),
            ]),
          ],
        ),
        // Contact Information Section
        _buildInfoCard(
          title: 'معلومات الاتصال',
          children: [
            _buildFieldRow([
              Expanded(
                child: MyTextField(
                  controller: _phoneNumberController,
                  labelText: 'رقم الموبايل',
                  keyboardType: TextInputType.phone,
                ),
              ),
            ]),
            MyTextField(
              controller: _addressController,
              labelText: 'العنوان',
              maxLines: 2,
            ),
          ],
        ),

        // Job Information Section
        _buildInfoCard(
          title: 'المعلومات الوظيفية',
          children: [
            _buildFieldRow([
              Expanded(
                child: _buildDateField(
                  controller: _employmentDateController,
                  label: 'تاريخ التوظيف',
                  onTap: () => _selectDate(_employmentDateController),
                ),
              ),
              Expanded(
                child: _buildDateField(
                  controller: _quittingDateController,
                  label: 'تاريخ الاستقالة',
                  onTap: () => _selectDate(_quittingDateController),
                ),
              ),
            ]),
            _buildFieldRow([
              Expanded(
                child: _buildConditionalDropdown(
                  controller: _jobTitleController,
                  options: jobTitle,
                  label: 'المسمى الوظيفي',
                ),
              ),
              Expanded(
                child: _buildConditionalDropdown(
                  controller: _jobRoleController,
                  options: jobRole,
                  label: 'الدور الوظيفي',
                ),
              ),
            ]),
            _buildFieldRow([
              Expanded(
                child: _buildConditionalDropdown(
                  controller: _salaryTypeController,
                  options: salaryType,
                  label: 'نوع الراتب',
                ),
              ),
              Expanded(
                child: MyTextField(
                  controller: _baseSalaryController,
                  labelText: 'الراتب الأساسي',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ]),
            _buildConditionalDropdown(
              controller: _reasonOfLeaveController,
              options: reasonOfLeave,
              label: 'سبب الاستقالة',
            ),
          ],
        ),

        // Insurance Information Section
        _buildInfoCard(
          title: 'المعلومات التأمينية',
          children: [
            _buildFieldRow([
              Expanded(
                child: MyTextField(
                  controller: _insNumberController,
                  labelText: 'الرقم التأميني',
                ),
              ),
              Expanded(
                child: MyTextField(
                  controller: _insSalaryController,
                  labelText: 'الراتب التأميني',
                ),
              ),
            ]),
            _buildFieldRow([
              Expanded(
                child: _buildDateField(
                  controller: _insRegistrationDateController,
                  label: 'تاريخ التسجيل بالتأمينات',
                  onTap: () => _selectDate(_insRegistrationDateController),
                ),
              ),
              Expanded(
                child: _buildDateField(
                  controller: _insCancellationDateController,
                  label: 'تاريخ انفكاك التأمينات',
                  onTap: () => _selectDate(_insCancellationDateController),
                ),
              ),
            ]),
          ],
        ),

        // Additional Information Section
        _buildInfoCard(
          title: 'معلومات إضافية',
          children: [
            _buildFieldRow([
              Expanded(
                child: MyTextField(
                  controller: _fingePrintCodeController,
                  labelText: 'رقم البصمة',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              Expanded(
                child: MyTextField(
                  controller: _administrativeLeaveCountController,
                  labelText: 'عدد الإجازات الإدارية',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ]),
            MyTextField(
              controller: _localEmailController,
              labelText: 'البريد الإلكتروني المحلي',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextField(
              controller: _detailsController,
              labelText: 'ملاحظات',
            ),
          ],
        ),
      ];
    } else {
      // Landscape Layout: Mostly three-column rows for better space utilization
      return [
        // Basic Information Section
        _buildInfoCard(
          title: 'المعلومات الأساسية',
          children: [
            _buildFieldRow([
              Expanded(
                child: MyDropdownButton(
                  value: _departmentController.text.isEmpty
                      ? null
                      : _departmentController.text,
                  items: _department
                      .map((dep) => DropdownMenuItem(
                            value: dep,
                            child: Text(dep),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _departmentController.text = newValue ?? '';
                    });
                  },
                  labelText: 'القسم',
                ),
              ),
              Expanded(
                child: MyTextField(
                  controller: _firstNameController,
                  labelText: 'الاسم الأول *',
                  validator: (value) =>
                      value!.isEmpty ? 'يجب إدخال الاسم الأول' : null,
                ),
              ),
              Expanded(
                child: MyTextField(
                  controller: _lastNameController,
                  labelText: 'الكنية *',
                  validator: (value) =>
                      value!.isEmpty ? 'يجب إدخال الكنية' : null,
                ),
              ),
            ]),
            _buildFieldRow([
              Expanded(
                child: MyTextField(
                  controller: _fatherNameController,
                  labelText: 'اسم الأب',
                ),
              ),
              Expanded(
                child: MyTextField(
                  controller: _motherNameController,
                  labelText: 'اسم الأم',
                ),
              ),
              Expanded(child: _buildEmploymentStatus()),
            ]),
          ],
        ),

        // Personal Information Section
        _buildInfoCard(
          title: 'المعلومات الشخصية',
          children: [
            _buildFieldRow([
              Expanded(
                child: _buildDateField(
                  controller: _dateOfBirthController,
                  label: 'تاريخ الميلاد',
                  onTap: () => _selectDate(_dateOfBirthController),
                ),
              ),
              Expanded(
                child: MyTextField(
                  controller: _placeOfBirthController,
                  labelText: 'مكان الميلاد',
                ),
              ),
              Expanded(
                child: MyTextField(
                  controller: _localityController,
                  labelText: 'الخانة',
                ),
              ),
            ]),
            _buildFieldRow([
              Expanded(
                child: MyTextField(
                  controller: _nationalIdController,
                  labelText: 'رقم الوطني',
                ),
              ),
              Expanded(
                child: MyTextField(
                  controller: _idNumberCountController,
                  labelText: 'رقم الهوية',
                ),
              ),
              Expanded(
                child: _buildConditionalDropdown(
                  controller: _nationalityController,
                  options: nationality,
                  label: 'الجنسية',
                ),
              ),
            ]),
            _buildFieldRow([
              Expanded(
                child: _buildConditionalDropdown(
                  controller: _genderController,
                  options: gender,
                  label: 'الجنس',
                ),
              ),
              Expanded(
                child: _buildConditionalDropdown(
                  controller: _maritalStatusController,
                  options: maritalStatus,
                  label: 'الحالة الاجتماعية',
                ),
              ),
              Expanded(
                child: MyTextField(
                  controller: _numberOfChildrenController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  labelText: 'عدد الأولاد',
                ),
              ),
            ]),
            _buildFieldRow([
              Expanded(child: _buildSmokingStatus()),
              Expanded(
                child: _buildConditionalDropdown(
                  controller: _militaryServiceController,
                  options: militaryService,
                  label: 'خدمة العلم',
                ),
              ),
              const Expanded(child: SizedBox.shrink()), // Filler
            ]),
            _buildFieldRow([
              Expanded(
                child: _buildConditionalDropdown(
                  controller: _academicLevelController,
                  options: academicLevel,
                  label: 'المستوى الأكاديمي',
                ),
              ),
              Expanded(
                child: MyTextField(
                  controller: _academicMajorController,
                  labelText: 'التخصص الأكاديمي',
                ),
              ),
              const Expanded(child: SizedBox.shrink()), // Filler
            ]),
          ],
        ),

        // Contact Information Section
        _buildInfoCard(
          title: 'معلومات الاتصال',
          children: [
            _buildFieldRow([
              Expanded(
                child: MyTextField(
                  controller: _phoneNumberController,
                  labelText: 'رقم الموبايل',
                  keyboardType: TextInputType.phone,
                ),
              ),
              Expanded(
                child: MyTextField(
                  controller: _localEmailController,
                  labelText: 'البريد الإلكتروني المحلي',
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const Expanded(child: SizedBox.shrink()), // Filler
            ]),
            MyTextField(
              controller: _addressController,
              labelText: 'العنوان',
              maxLines: 2,
            ),
          ],
        ),

        // Job Information Section
        _buildInfoCard(
          title: 'المعلومات الوظيفية',
          children: [
            _buildFieldRow([
              Expanded(
                child: _buildDateField(
                  controller: _employmentDateController,
                  label: 'تاريخ التوظيف',
                  onTap: () => _selectDate(_employmentDateController),
                ),
              ),
              Expanded(
                child: _buildDateField(
                  controller: _quittingDateController,
                  label: 'تاريخ الاستقالة',
                  onTap: () => _selectDate(_quittingDateController),
                ),
              ),
              Expanded(
                child: _buildConditionalDropdown(
                  controller: _jobTitleController,
                  options: jobTitle,
                  label: 'المسمى الوظيفي',
                ),
              ),
            ]),
            _buildFieldRow([
              Expanded(
                child: _buildConditionalDropdown(
                  controller: _jobRoleController,
                  options: jobRole,
                  label: 'الدور الوظيفي',
                ),
              ),
              Expanded(
                child: _buildConditionalDropdown(
                  controller: _salaryTypeController,
                  options: salaryType,
                  label: 'نوع الراتب',
                ),
              ),
              Expanded(
                child: MyTextField(
                  controller: _baseSalaryController,
                  labelText: 'الراتب الأساسي',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ]),
            _buildConditionalDropdown(
              controller: _reasonOfLeaveController,
              options: reasonOfLeave,
              label: 'سبب الاستقالة',
            ),
          ],
        ),

        // Insurance Information Section
        _buildInfoCard(
          title: 'المعلومات التأمينية',
          children: [
            _buildFieldRow([
              Expanded(
                child: MyTextField(
                  controller: _insNumberController,
                  labelText: 'الرقم التأميني',
                ),
              ),
              Expanded(
                child: MyTextField(
                  controller: _insSalaryController,
                  labelText: 'الراتب التأميني',
                ),
              ),
              Expanded(
                child: _buildDateField(
                  controller: _insRegistrationDateController,
                  label: 'تاريخ التسجيل بالتأمينات',
                  onTap: () => _selectDate(_insRegistrationDateController),
                ),
              ),
            ]),
            _buildFieldRow([
              Expanded(
                child: _buildDateField(
                  controller: _insCancellationDateController,
                  label: 'تاريخ انفكاك التأمينات',
                  onTap: () => _selectDate(_insCancellationDateController),
                ),
              ),
              const Expanded(child: SizedBox.shrink()), // Filler
              const Expanded(child: SizedBox.shrink()), // Filler
            ]),
          ],
        ),

        // Additional Information Section
        _buildInfoCard(
          title: 'معلومات إضافية',
          children: [
            _buildFieldRow([
              Expanded(
                child: MyTextField(
                  controller: _fingePrintCodeController,
                  labelText: 'رقم البصمة',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              Expanded(
                child: MyTextField(
                  controller: _administrativeLeaveCountController,
                  labelText: 'عدد الإجازات الإدارية',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              const Expanded(child: SizedBox.shrink()), // Filler
            ]),
            MyTextField(
              controller: _detailsController,
              labelText: 'ملاحظات',
            ),
          ],
        ),
      ];
    }
  }

  // --- Image Controls Widget ---
  Widget _buildImageControls() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildImageCard(
              title: 'الهوية الشخصية',
              hasImage: widget.employeeModel?.id_image != null,
              onView: () {
                context.read<HrBloc>().add(
                      GetIDImage(id: widget.employeeModel!.id),
                    );
              },
              onDelete: () {
                _confirmDelete(context, 'الهوية الشخصية', () {
                  context.read<HrBloc>().add(
                        DeleteIDImage(id: widget.employeeModel!.id),
                      );
                });
              },
              onPickCamera: () async {
                await _pickIdImage(ImageSource.camera);
                if (_idImage != null) {
                  context.read<HrBloc>().add(AddIDImage(
                      image: _idImage!, id: widget.employeeModel!.id));
                }
              },
              onPickGallery: () async {
                await _pickIdImage(ImageSource.gallery);
                if (_idImage != null) {
                  context.read<HrBloc>().add(AddIDImage(
                      image: _idImage!, id: widget.employeeModel!.id));
                }
              },
            ),
            const SizedBox(width: 20),
            _buildImageCard(
              title: 'الصورة الشخصية',
              hasImage: widget.employeeModel?.photo != null,
              onView: () {
                context.read<HrBloc>().add(
                      GetEmpImage(id: widget.employeeModel!.id),
                    );
              },
              onDelete: () {
                _confirmDelete(context, 'الصورة الشخصية', () {
                  context.read<HrBloc>().add(
                        DeleteEmpImage(id: widget.employeeModel!.id),
                      );
                });
              },
              onPickCamera: () async {
                await _pickEmpImage(ImageSource.camera);
                if (_empImage != null) {
                  context.read<HrBloc>().add(AddEmpImage(
                      image: _empImage!, id: widget.employeeModel!.id));
                }
              },
              onPickGallery: () async {
                await _pickEmpImage(ImageSource.gallery);
                if (_empImage != null) {
                  context.read<HrBloc>().add(AddEmpImage(
                      image: _empImage!, id: widget.employeeModel!.id));
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildImageCard(
          title: 'صورة العقد التأميني',
          hasImage: widget.employeeModel?.ins_reg_image != null,
          onView: () {
            context.read<HrBloc>().add(
                  GetInsImage(id: widget.employeeModel!.id),
                );
          },
          onDelete: () {
            _confirmDelete(context, 'صورة العقد التأميني', () {
              context.read<HrBloc>().add(
                    DeleteInsImage(id: widget.employeeModel!.id),
                  );
            });
          },
          onPickCamera: () async {
            await _pickInsImage(ImageSource.camera);
            if (_insImage != null) {
              context.read<HrBloc>().add(
                  AddInsImage(image: _insImage!, id: widget.employeeModel!.id));
            }
          },
          onPickGallery: () async {
            await _pickInsImage(ImageSource.gallery);
            if (_insImage != null) {
              context.read<HrBloc>().add(
                  AddInsImage(image: _insImage!, id: widget.employeeModel!.id));
            }
          },
          isFullWidth: true, // Make insurance image card full width
        ),
      ],
    );
  }

  Widget _buildImageCard({
    required String title,
    required bool hasImage,
    required VoidCallback onView,
    required VoidCallback onDelete,
    required VoidCallback onPickCamera,
    required VoidCallback onPickGallery,
    bool isFullWidth = false,
  }) {
    final card = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          hasImage
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.remove_red_eye, color: Colors.blue),
                      tooltip: 'عرض الصورة',
                      onPressed: onView,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'حذف الصورة',
                      onPressed: onDelete,
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (Platform.isAndroid)
                      IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.green),
                        tooltip: 'تصوير الصورة',
                        onPressed: onPickCamera,
                      ),
                    IconButton(
                      icon:
                          const Icon(Icons.photo_library, color: Colors.orange),
                      tooltip: 'اختيار الصورة',
                      onPressed: onPickGallery,
                    ),
                  ],
                ),
        ],
      ),
    );

    return isFullWidth ? card : Expanded(child: card);
  }

  // --- Main Build Method ---
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              isDark ? AppColors.gradient2 : AppColors.lightGradient2,
          title: Text(
            widget.employeeModel == null ? 'إضافة موظف' : 'تعديل موظف',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: BlocConsumer<HrBloc, HrState>(
          listener: (context, state) {
            if (state is HRSuccess<EmployeeModel>) {
              final fullName =
                  '${_firstNameController.text} ${_lastNameController.text}'
                      .trim();

              showSnackBar(
                context: context,
                content:
                    'تم ${widget.employeeModel == null ? 'إضافة' : 'تعديل'} الموظف: $fullName',
                failure: false,
              );

              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmployeesListPage(),
                ),
              );
            } else if (state is HRSuccess<Uint8List>) {
              // Navigate to new page after the current frame
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Navigate first
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ViewImagePage(imageData: state.result),
                  ),
                );
              });
            } else if (state is HRSuccess<bool>) {
              showSnackBar(
                context: context,
                content: 'تم حذف الصورة',
                failure: false,
              );
            } else if (state is HRError) {
              showSnackBar(
                context: context,
                content: state.errorMessage,
                failure: true,
              );
            } else if (state is ImageSavedSuccess) {
              showSnackBar(
                context: context,
                content: 'تم حفظ الصورة',
                failure: false,
              );
            }
          },
          builder: (context, state) {
            if (state is HRLoading) {
              return const Center(child: Loader());
            }

            return OrientationBuilder(
              builder: (context, orientation) {
                return Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView(
                      children: [
                        ..._buildFormFields(orientation),
                        const SizedBox(height: 10),
                        _buildImageControls(),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 20, bottom: 20, left: 80, right: 80),
                          child: Mybutton(
                            text: widget.employeeModel == null
                                ? 'إضافة موظف'
                                : 'حفظ التعديلات',
                            onPressed: _submitForm,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // --- Form Submission Logic ---
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Check required fields
      if (_firstNameController.text.trim().isEmpty ||
          _lastNameController.text.trim().isEmpty ||
          _departmentController.text.trim().isEmpty) {
        showSnackBar(
          context: context,
          content: 'الرجاء تعبئة الاسم الأول، الاسم الأخير، القسم.',
          failure: true,
        );
        return;
      }

      // Additional validation: If employee is not working, quitting date must be provided
      if (!_isWorking && _quittingDateController.text.isEmpty) {
        showSnackBar(
          context: context,
          content: 'يجب إدخال تاريخ الاستقالة عندما تكون حالة العمل غير مفعلة.',
          failure: true,
        );
        return;
      }

      final model = _fillModelFromForm();

      if (widget.employeeModel == null) {
        context.read<HrBloc>().add(AddEmployee(employeeModel: model));
      } else {
        context.read<HrBloc>().add(
              UpdateEmployee(
                employeeModel: model,
                id: widget.employeeModel!.id,
              ),
            );
      }
    }
  }

  EmployeeModel _fillModelFromForm() {
    String? _nullIfEmpty(String text) =>
        text.trim().isEmpty ? null : text.trim();

    return EmployeeModel(
      id: widget.employeeModel?.id ?? 0,
      first_name: _firstNameController.text,
      last_name: _lastNameController.text,
      department_name: _departmentController.text,
      is_working: _isWorking,
      father_name: _fatherNameController.text,
      mother_name: _motherNameController.text,
      phone_number: _phoneNumberController.text,
      address: _addressController.text,
      job_title: _jobTitleController.text,
      job_role: _jobRoleController.text,
      finger_print_code: _fingePrintCodeController.text,
      dob: _nullIfEmpty(_dateOfBirthController.text),
      pob: _placeOfBirthController.text,
      locality: _localityController.text,
      national_id: _nationalIdController.text,
      nationality: _nationalityController.text,
      gender: _genderController.text,
      marital_status: _maritalStatusController.text,
      number_of_children: _numberOfChildrenController.text.isNotEmpty
          ? int.tryParse(_numberOfChildrenController.text)
          : null,
      smokes: _smokes,
      military_service: _militaryServiceController.text,
      employment_date: _nullIfEmpty(_employmentDateController.text),
      quitting_date: _nullIfEmpty(_quittingDateController.text),
      reason_of_leave: _reasonOfLeaveController.text,
      salary_type: _salaryTypeController.text,
      local_email: _localEmailController.text,
      ins_number: _insNumberController.text,
      ins_registration_date: _nullIfEmpty(_insRegistrationDateController.text),
      ins_cancellation_date: _nullIfEmpty(_insCancellationDateController.text),
      max_admin_leaves: _administrativeLeaveCountController.text,
      base_salary: _baseSalaryController.text,
      ins_salary: _insSalaryController.text,
      ID_number: _idNumberCountController.text,
      details: _detailsController.text,
      academic_level: _academicLevelController.text,
      academic_major: _academicMajorController.text,
    );
  }
}

// --- Global Function for Confirmation Dialog ---
Future<void> _confirmDelete(
    BuildContext context, String docType, Function onConfirm) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap a button!
    builder: (BuildContext dialogContext) {
      return Directionality(
        textDirection: ui.TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تأكيد الحذف'), // Confirmation
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('هل أنت متأكد من رغبتك في حذف $docType؟'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('إلغاء', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('حذف',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onConfirm();
              },
            ),
          ],
        ),
      );
    },
  );
}
