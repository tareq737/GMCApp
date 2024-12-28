import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmc/Purchases/bloc/purchase_bloc.dart';
import 'package:gmc/Purchases/models/brief_purchase_model.dart';
import 'package:gmc/Purchases/ui/details_purchase_page.dart';
import 'package:gmc/core/utils/show_snackbar.dart';

class BriefPurchasePage extends StatefulWidget {
  const BriefPurchasePage({super.key});

  @override
  State<BriefPurchasePage> createState() => _BriefPurchasePageState();
}

class _BriefPurchasePageState extends State<BriefPurchasePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<BriefPurchaseModel> _briefPurchases = []; // Variable to store the data
  final List<String> _itemsStatus = [
    'الطلبات الغير موافقة من المدير',
    'الطلبات الموافقة من المدير',
    'الطلبات المرفوضة من المدير',
    'الطلبات الموافقة من المدير وغير منفذة',
    'الطلبات الغير مؤرشفة وغير مستلمة',
    'كافة الطلبات الغير مؤرشفة',
    'كافة طلبات المشتريات'
  ];
  final List<String> _itemsSection = [
    'الصيانة',
    'الزراعة',
    'العهد',
    'الخدمات',
    'المبيعات',
    'أقسام الإنتاج',
    'IT',
    'شركة النور'
  ];

  String? _selectedItemStatus;
  String? _selectedItemSection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade600,
        title: Text(
          'طلبات المشتريات',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Dropdown for Status
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  decoration: BoxDecoration(
                    color: Colors
                        .teal.shade50, // Light blue background for the dropdown
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          hint: Text(
                            'الحالة',
                            style: TextStyle(
                              color: Colors.teal.shade700,
                            ),
                          ),
                          value: _selectedItemStatus,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedItemStatus = newValue;
                            });
                            if (newValue != null) {
                              context.read<PurchaseBloc>().add(
                                    GetBriefPurchase(
                                      section: _selectedItemSection,
                                      status: _selectedItemStatus,
                                    ),
                                  );
                            }
                          },
                          isExpanded: true,
                          underline: SizedBox(),
                          items: _itemsStatus
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: Colors.teal.shade700,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      if (_selectedItemStatus != null)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedItemStatus = null;
                            });
                            context.read<PurchaseBloc>().add(GetBriefPurchase(
                                  section: _selectedItemSection,
                                  status: _selectedItemStatus,
                                ));
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Dropdown for Section
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          hint: Text(
                            'القسم',
                            style: TextStyle(
                              color: Colors.orange.shade700,
                            ),
                          ),
                          value: _selectedItemSection,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedItemSection = newValue;
                            });
                            if (newValue != null) {
                              context.read<PurchaseBloc>().add(GetBriefPurchase(
                                    section: _selectedItemSection,
                                    status: _selectedItemStatus,
                                  ));
                            }
                          },
                          isExpanded: true,
                          underline: SizedBox(), // Remove the default underline
                          items: _itemsSection
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                ), // Dropdown text color
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      if (_selectedItemSection !=
                          null) // Show clear button only if a value is selected
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedItemSection = null;
                            });
                            context.read<PurchaseBloc>().add(GetBriefPurchase(
                                  section: _selectedItemSection,
                                  status: _selectedItemStatus,
                                ));
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 14,
            child: BlocConsumer<PurchaseBloc, PurchaseState>(
              listener: (context, state) {
                if (state is PurchaseError) {
                  showCustomSnackBar(
                    context: context,
                    content: state.errorMessage,
                    backgroundColor: Colors.red,
                  );
                } else if (state is PurchaseSuccess<List<BriefPurchaseModel>>) {
                  setState(() {
                    _briefPurchases = state.result;
                  });
                }
              },
              builder: (context, state) {
                if (state is PurchaseInitial) {
                  return SizedBox();
                } else if (state is PurchaseLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (_briefPurchases.isNotEmpty) {
                  return ListView.builder(
                    itemCount: _briefPurchases.length,
                    itemBuilder: (context, index) {
                      final screenWidth = MediaQuery.of(context).size.width;
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsPurchasePage(
                                Pur_ID: _briefPurchases[index].Pur_ID!,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 4),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                              title: SizedBox(
                                width: screenWidth * 0.7,
                                child: Text(
                                  _briefPurchases[index].Item ?? "",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              subtitle: SizedBox(
                                  width: screenWidth * 0.6,
                                  child: Text(
                                    _briefPurchases[index].Usage ?? "",
                                    style:
                                        TextStyle(color: Colors.grey.shade600),
                                  )),
                              leading: SizedBox(
                                width: screenWidth * 0.10,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.teal.shade200,
                                      radius: 11,
                                      child: Text(
                                        _briefPurchases[index]
                                            .Pur_ID
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 9),
                                      ),
                                    ),
                                    Text(
                                      textAlign: TextAlign.center,
                                      _briefPurchases[index].Section ?? "",
                                      style: TextStyle(fontSize: 8),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: SizedBox(
                                width: screenWidth * 0.01,
                                child: Column(
                                  children: [
                                    Icon(
                                      _briefPurchases[index].Approved == 1
                                          ? Icons.check_circle
                                          : _briefPurchases[index].Approved == 0
                                              ? Icons
                                                  .remove_circle_outline_sharp
                                              : Icons.info,
                                      color: _briefPurchases[index].Approved ==
                                              1
                                          ? Colors.green
                                          : _briefPurchases[index].Approved == 0
                                              ? Colors.red
                                              : Colors.grey,
                                      size: 15,
                                    ),
                                    Icon(
                                      _briefPurchases[index].Received == 1
                                          ? Icons.check_circle
                                          : _briefPurchases[index].Received == 0
                                              ? Icons
                                                  .remove_circle_outline_sharp
                                              : Icons.remove,
                                      color: _briefPurchases[index].Received ==
                                              1
                                          ? Colors.green
                                          : _briefPurchases[index].Received == 0
                                              ? Colors.red
                                              : Colors.grey,
                                      size: 15,
                                    ),
                                    Icon(
                                      _briefPurchases[index].Archived == 1
                                          ? Icons.check_circle
                                          : _briefPurchases[index].Archived == 0
                                              ? Icons
                                                  .remove_circle_outline_sharp
                                              : Icons.remove, // Default icon
                                      color: _briefPurchases[index].Archived ==
                                              1
                                          ? Colors.green
                                          : _briefPurchases[index].Archived == 0
                                              ? Colors.red
                                              : Colors.grey,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      );
                    },
                  );
                } else if (state is PurchaseError) {
                  return Center(
                    child: Text(state.errorMessage),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
