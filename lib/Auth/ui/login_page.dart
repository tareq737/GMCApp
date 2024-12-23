import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';

import 'package:gmc/Auth/bloc/auth_bloc.dart';
import 'package:gmc/Auth/model/auth_model.dart';
import 'package:gmc/core/pages/home_page.dart';
import 'package:gmc/core/utils/show_snackbar.dart';
import 'package:gmc/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible =
      false; // Add this variable to control password visibility

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      final username = _usernameController.text;
      final password = _passwordController.text;
      context.read<AuthBloc>().add(
            LoginEvent(Username: username, password: password),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          showCustomSnackBar(
            context: context,
            content: state.errorMessage,
            backgroundColor: Colors.red,
          );
        } else if (state is AuthSuccess<AuthModel>) {
          sharedPref.setInt("User_ID", state.result.User_ID);
          sharedPref.setString("Username", state.result.Username);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              // الخلفية
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
                    color: Colors.black
                        .withOpacity(0.2), // طبقة شفافة فوق الضبابية
                  ),
                ),
              ),
              // محتوى تسجيل الدخول
              Form(
                key: _formKey,
                child: Center(
                  child: Container(
                    width: screenWidth * 0.8, // 80% of screen width
                    padding: EdgeInsets.all(
                        screenWidth * 0.05), // 5% of screen width
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2), // الشفافية
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: screenHeight * 0.015),
                        // اسم المستخدم
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'عذراً الخانة مطلوبة';
                            }
                            return null;
                          },
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: "اسم المستخدم",
                            labelStyle: const TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        SizedBox(
                            height:
                                screenHeight * 0.015), // 1.5% of screen height
                        // كلمة المرور
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'عذراً الخانة مطلوبة';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "كلمة المرور",
                            labelStyle: const TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                Colors.black, // Adjusted for better readability
                          ),
                        ),

                        SizedBox(
                            height: screenHeight * 0.02), // 2% of screen height
                        state is AuthLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.white.withOpacity(0.4),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth *
                                        0.1, // 10% of screen width
                                    vertical: screenHeight *
                                        0.015, // 1.5% of screen height
                                  ),
                                ),
                                child: const Text(
                                  "تسجيل الدخول",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
