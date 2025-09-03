import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:tumbrtest/domain/models/user.dart';
import 'package:tumbrtest/presentation/providers/auth_provider.dart';
import 'package:tumbrtest/presentation/screens/signin.dart';
import 'package:tumbrtest/presentation/widgets/app_textfield.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D01B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: 50,
        leading: IconButton(
            onPressed: () {},
            icon: Platform.isIOS
                ? const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInScreen())),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            color: Color(0xFF4299E1),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // Form
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // First and Last Name
                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  label: 'First Name',
                                  controller: _firstNameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'First name is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: AppTextField(
                                  label: 'Last Name',
                                  controller: _lastNameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Last name is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Email
                          AppTextField(
                            label: 'Email',
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // Date of Birth
                          AppTextField(
                            label: 'Date of Birth',
                            controller: _dobController,
                            readOnly: true,
                            onTap: _selectDate,
                            suffixIcon: Image.asset(
                              'assets/icons/calendar.png',
                              height: 50,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Date of birth is required';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 232, 232, 232)),
                            ),
                            child: IntlPhoneField(
                              decoration: const InputDecoration(
                                hintText: '(454) 726-0592',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                              ),
                              initialCountryCode: 'NG',
                              disableLengthCheck: true,
                              showCountryFlag: true,
                              keyboardType: TextInputType.phone,
                              showDropdownIcon: true, // Show dropdown arrow
                              dropdownIconPosition: IconPosition.trailing,
                              validator: (value) {
                                if (value == null || value.number.isEmpty) {
                                  return 'Phone number is required';
                                }
                                if (value.number.length < 10) {
                                  return 'Please enter a valid phone number';
                                }
                                return null;
                              }, // Arrow right after flag
                              flagsButtonPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              onChanged: (phone) {
                                print(phone.completeNumber);
                              },
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Password
                          AppTextField(
                            label: 'Set Password',
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: const Color(0xFFA0AEC0),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 32),

                          // Register button
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: authProvider.isLoading
                                      ? null
                                      : _handleSignUp,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4299E1),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: authProvider.isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Text(
                                          'Register',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),

                          // Error message
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              if (authProvider.error != null) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text(
                                    authProvider.error!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final user = User(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        dateOfBirth: _dobController.text,
        phoneNumber: _phoneController.text.trim(),
      );

      final success = await authProvider.signUp(user, _passwordController.text);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignInScreen()));
      }
    }
  }
}
