import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gmc/Auth/ui/login_page.dart';
import 'package:gmc/Purchases/ui/brief_purchase_page.dart';
import 'package:gmc/core/utils/show_snackbar.dart';
import 'package:gmc/main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/core/assets/images/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // تأثير الضبابية
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 1.0, // قوة الضبابية في الاتجاه الأفقي
                sigmaY: 1.0, // قوة الضبابية في الاتجاه العمودي
              ),
              child: Container(
                color: Colors.black.withOpacity(0.2), // طبقة شفافة فوق الضبابية
              ),
            ),
          ),
          // Main Content
          Column(
            children: [
              // User Accounts Drawer Header (Fixed)
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                accountName: Text(
                  sharedPref.getString("Username") ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: Text("www.ofc.com.sy"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  child: Image.asset(
                    'lib/core/assets/images/logo.png',
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.2,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.10),
                      // Quick Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildActionButton(
                            icon: Icons.shopping_cart,
                            label: "المشتريات",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BriefPurchasePage(),
                                ),
                              );
                            },
                          ),
                          SizedBox(width: screenWidth * 0.10),
                          _buildActionButton(
                            icon: Icons.build,
                            label: "الصيانة",
                            onTap: () {
                              showCustomSnackBar(
                                context: context,
                                content: "القسم قيد التطوير",
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              );
                            },
                          ),
                          SizedBox(width: screenWidth * 0.10),
                          _buildActionButton(
                            icon: Icons.grass,
                            label: "الزراعة",
                            onTap: () {
                              showCustomSnackBar(
                                context: context,
                                content: "القسم قيد التطوير",
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildActionButton(
                            icon: Icons.storefront,
                            label: "المبيعات",
                            onTap: () {
                              showCustomSnackBar(
                                context: context,
                                content: "القسم قيد التطوير",
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              );
                            },
                          ),
                          SizedBox(width: screenWidth * 0.10),
                          _buildActionButton(
                            icon: Icons.warehouse,
                            label: "المستودعات",
                            onTap: () {
                              showCustomSnackBar(
                                context: context,
                                content: "القسم قيد التطوير",
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              );
                            },
                          ),
                          SizedBox(width: screenWidth * 0.10),
                          _buildActionButton(
                            icon: Icons.account_balance,
                            label: "المحاسبة",
                            onTap: () {
                              showCustomSnackBar(
                                context: context,
                                content: "القسم قيد التطوير",
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildActionButton(
                            icon: Icons.factory,
                            label: "الإنتاج",
                            onTap: () {
                              showCustomSnackBar(
                                context: context,
                                content: "القسم قيد التطوير",
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              );
                            },
                          ),
                          SizedBox(width: screenWidth * 0.10),
                          _buildActionButton(
                            icon: Icons.science,
                            label: "المخبر",
                            onTap: () {
                              showCustomSnackBar(
                                context: context,
                                content: "القسم قيد التطوير",
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              );
                            },
                          ),
                          SizedBox(width: screenWidth * 0.10),
                          _buildActionButton(
                            icon: Icons.settings,
                            label: "ERP",
                            onTap: () {
                              showCustomSnackBar(
                                context: context,
                                content: "القسم قيد التطوير",
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.1),
                      _buildActionButton(
                        icon: Icons.exit_to_app,
                        label: "",
                        onTap: () {
                          sharedPref.clear();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 74,
        height: 88,
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor:
                  Colors.green.shade200.withOpacity(0.4), // Add opacity here
              child: Icon(icon, size: 30, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(fontSize: 14, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
