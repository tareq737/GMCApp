import 'package:flutter/material.dart';
import 'package:gmc/Purchases/models/details_purchase_model.dart';
import 'package:gmc/core/widgets/mytextfield.dart';

class DetailsPurchasePage extends StatefulWidget {
  final DetailsPurchaseModel detailsPurchaseModel;

  const DetailsPurchasePage({super.key, required this.detailsPurchaseModel});

  @override
  State<DetailsPurchasePage> createState() => _DetailsPurchasePageState();
}

class _DetailsPurchasePageState extends State<DetailsPurchasePage> {
  final _purIDController = TextEditingController();
  final _sectionController = TextEditingController();
  final _applicantController = TextEditingController();
  final _insertDateController = TextEditingController();
  final _itemController = TextEditingController();
  final _specificationsController = TextEditingController();
  final _heightController = TextEditingController();
  final _widthController = TextEditingController();
  final _lengthController = TextEditingController();
  final _colorController = TextEditingController();
  final _countryController = TextEditingController();
  final _usageController = TextEditingController();
  final _warehouseAmountController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();
  final _requiredDateController = TextEditingController();
  final _supplierController = TextEditingController();
  final _idMaintenanceController = TextEditingController();
  final _lastPurchaseController = TextEditingController();
  final _lastPriceController = TextEditingController();
  final _notesController = TextEditingController();
  final _approvedDateController = TextEditingController();
  final _managerNoteController = TextEditingController();
  final _realSupplierController = TextEditingController();
  final _buyerController = TextEditingController();
  final _expectedDateController = TextEditingController();
  final _buyDateController = TextEditingController();
  final _priceController = TextEditingController();
  final _offer1Controller = TextEditingController();
  final _offer2Controller = TextEditingController();
  final _offer3Controller = TextEditingController();

  final _receivedDateController = TextEditingController();

  int? _selectedApproved; // Variable for RadioListTile selection
  bool _isReceived = false;
  bool _isArchived = false;

  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _purIDController.text = widget.detailsPurchaseModel.Pur_ID.toString();
    _sectionController.text = widget.detailsPurchaseModel.Section ?? '';
    _applicantController.text = widget.detailsPurchaseModel.Applicant ?? '';
    _insertDateController.text = widget.detailsPurchaseModel.Insert_Date ?? '';
    _itemController.text = widget.detailsPurchaseModel.Item ?? '';
    _specificationsController.text =
        widget.detailsPurchaseModel.Specifications ?? '';
    _heightController.text =
        widget.detailsPurchaseModel.Height?.toString() ?? '';
    _widthController.text = widget.detailsPurchaseModel.Width?.toString() ?? '';
    _lengthController.text =
        widget.detailsPurchaseModel.Length?.toString() ?? '';
    _colorController.text = widget.detailsPurchaseModel.Color ?? '';
    _countryController.text = widget.detailsPurchaseModel.Country ?? '';
    _usageController.text = widget.detailsPurchaseModel.Usage ?? '';
    _warehouseAmountController.text =
        widget.detailsPurchaseModel.WarehouseAmount ?? '';
    _quantityController.text = widget.detailsPurchaseModel.Quantity ?? '';
    _unitController.text = widget.detailsPurchaseModel.Unit ?? '';
    _requiredDateController.text =
        widget.detailsPurchaseModel.RequiredDate ?? '';
    _supplierController.text = widget.detailsPurchaseModel.Supplier ?? '';
    _idMaintenanceController.text =
        widget.detailsPurchaseModel.IDMaintenance ?? '';
    _lastPurchaseController.text =
        widget.detailsPurchaseModel.LastPurchase ?? '';
    _lastPriceController.text = widget.detailsPurchaseModel.LastPrice ?? '';
    _notesController.text = widget.detailsPurchaseModel.Notes ?? '';
    _selectedApproved = widget.detailsPurchaseModel.Approved;
    _approvedDateController.text =
        widget.detailsPurchaseModel.ApprovedDate ?? '';
    _managerNoteController.text = widget.detailsPurchaseModel.ManagerNote ?? '';
    _realSupplierController.text =
        widget.detailsPurchaseModel.RealSupplier ?? '';
    _buyerController.text = widget.detailsPurchaseModel.Buyer ?? '';
    _expectedDateController.text =
        widget.detailsPurchaseModel.ExpectedDate ?? '';
    _buyDateController.text = widget.detailsPurchaseModel.BuyDate ?? '';
    _priceController.text = widget.detailsPurchaseModel.Price ?? '';
    _offer1Controller.text = widget.detailsPurchaseModel.Offer1 ?? '';
    _offer2Controller.text = widget.detailsPurchaseModel.Offer2 ?? '';
    _offer3Controller.text = widget.detailsPurchaseModel.Offer3 ?? '';
    _isReceived = widget.detailsPurchaseModel.Received == 1;
    _receivedDateController.text =
        widget.detailsPurchaseModel.ReceivedDate ?? '';
    _isArchived = widget.detailsPurchaseModel.Archived == 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade600,
        title: Text(
          'طلب مشتريات رقم ${_purIDController.text}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: [
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: Card(
                  elevation: 5,
                  color: Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'معلومات الطلب',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        MyTextField(
                            controller: _sectionController, labelText: 'القسم'),
                        MyTextField(
                            controller: _applicantController,
                            labelText: 'مقدم الطلب'),
                        Row(
                          spacing: 5,
                          children: [
                            Expanded(
                              child: MyTextField(
                                  controller: _insertDateController,
                                  labelText: 'تاريخ الإدراج'),
                            ),
                            Expanded(
                              child: MyTextField(
                                  controller: _requiredDateController,
                                  labelText: 'تاريخ التوريد المطلوب'),
                            ),
                          ],
                        ),
                        MyTextField(
                            controller: _itemController, labelText: 'الصنف'),
                        MyTextField(
                            controller: _usageController,
                            labelText: 'الاستعمال وتوصيف الحالة'),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  color: Colors.blue.shade50,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'الأبعاد والمواصفات',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        MyTextField(
                            controller: _specificationsController,
                            labelText: 'المواصفات الفنية'),
                        Row(
                          spacing: 5,
                          children: [
                            Expanded(
                              child: MyTextField(
                                  controller: _lengthController,
                                  labelText: 'الطول'),
                            ),
                            Expanded(
                              child: MyTextField(
                                  controller: _widthController,
                                  labelText: 'العرض'),
                            ),
                            Expanded(
                              child: MyTextField(
                                  controller: _heightController,
                                  labelText: 'الارتفاع'),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 5,
                          children: [
                            Expanded(
                              child: MyTextField(
                                  controller: _colorController,
                                  labelText: 'اللون'),
                            ),
                            Expanded(
                              child: MyTextField(
                                  controller: _countryController,
                                  labelText: 'بلد المنشأ'),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 5,
                          children: [
                            Expanded(
                              flex: 3,
                              child: MyTextField(
                                  controller: _warehouseAmountController,
                                  labelText: 'رصيد المستودع'),
                            ),
                            Expanded(
                              flex: 2,
                              child: MyTextField(
                                  controller: _quantityController,
                                  labelText: 'الكمية'),
                            ),
                            Expanded(
                              flex: 3,
                              child: MyTextField(
                                  controller: _unitController,
                                  labelText: 'الوحدة'),
                            ),
                          ],
                        ),
                        Center(
                          child: ElevatedButton(
                              onPressed: () {},
                              child: Text('تعديل طلب المشتريات')),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 5,
            color: Colors.green.shade50,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'قسم المشتريات',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      Expanded(
                        child: MyTextField(
                            controller: _lastPurchaseController,
                            labelText: 'تاريخ آخر شراء'),
                      ),
                      Expanded(
                        child: MyTextField(
                            controller: _lastPriceController,
                            labelText: 'سعر آخر شراء'),
                      ),
                    ],
                  ),
                  MyTextField(
                      controller: _notesController, labelText: 'ملاحظات'),
                  Row(
                    spacing: 5,
                    children: [
                      Expanded(
                        child: MyTextField(
                            controller: _buyDateController,
                            labelText: 'تاريخ الشراء'),
                      ),
                      Expanded(
                        child: MyTextField(
                            controller: _priceController,
                            labelText: 'سعر الشراء'),
                      ),
                    ],
                  ),
                  MyTextField(
                      controller: _offer1Controller, labelText: 'عرض سعر 1'),
                  MyTextField(
                      controller: _offer2Controller, labelText: 'عرض سعر 2'),
                  MyTextField(
                      controller: _offer3Controller, labelText: 'عرض سعر 3'),
                  MyTextField(
                      controller: _realSupplierController,
                      labelText: 'المورد الفعلي'),
                  Row(
                    spacing: 5,
                    children: [
                      Expanded(
                        child: MyTextField(
                            controller: _expectedDateController,
                            labelText: 'تاريخ الشراء المتوقع'),
                      ),
                      Expanded(
                        child: MyTextField(
                            controller: _buyerController,
                            labelText: 'القائم بالشراء'),
                      ),
                    ],
                  ),
                  CheckboxListTile(
                    value: _isArchived,
                    onChanged: (bool? value) {
                      setState(() {
                        _isArchived = value ?? false;
                      });
                    },
                    title: const Text('أرشفة'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {}, child: Text('حفظ ملاحظات المشتريات')),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 5,
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'قسم المدير',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  RadioListTile<int?>(
                    value: null,
                    groupValue: _selectedApproved,
                    onChanged: (value) {
                      setState(() {
                        _selectedApproved = value;
                      });
                    },
                    title: const Text('التوقيع غير محدد'),
                  ),
                  RadioListTile<int?>(
                    value: 1,
                    groupValue: _selectedApproved,
                    onChanged: (value) {
                      setState(() {
                        _selectedApproved = value;
                      });
                    },
                    title: const Text('موافق'),
                  ),
                  RadioListTile<int?>(
                    value: 0,
                    groupValue: _selectedApproved,
                    onChanged: (value) {
                      setState(() {
                        _selectedApproved = value;
                      });
                    },
                    title: const Text('مرفوض'),
                  ),
                  MyTextField(
                      controller: _approvedDateController,
                      labelText: 'تاريخ الموافقة'),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                      controller: _managerNoteController,
                      labelText: 'ملاحظة المدير'),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {}, child: Text('حفظ توقيع المدير')),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 5,
            color: Colors.green.shade50,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'قسم الاستلام',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  CheckboxListTile(
                    value: _isReceived,
                    onChanged: (bool? value) {
                      setState(() {
                        _isReceived = value ?? false;
                      });
                    },
                    title: const Text('استلام'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  MyTextField(
                      controller: _receivedDateController,
                      labelText: 'تاريخ الاستلام'),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {}, child: Text('حفظ الاستلام')),
                  )
                ],
              ),
            ),
          ),
        ),
      ][_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        selectedItemColor: Colors.teal, // Color for selected item
        unselectedItemColor: Colors.grey, // Color for unselected items
        backgroundColor: Colors.white, // Background color for the bar
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'معلومات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_checkout),
            label: 'المشتريات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts_outlined),
            label: 'المدير',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recommend_outlined),
            label: 'الاستلام',
          ),
        ],
      ),
    );
  }
}
