import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tumbrtest/presentation/providers/auth_provider.dart';
import 'package:tumbrtest/presentation/screens/signup.dart';
import 'package:tumbrtest/presentation/widgets/app_button.dart';
import 'package:tumbrtest/presentation/widgets/app_textfield.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Load shared credentials if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.sharedEmail.isNotEmpty) {
        _emailController.text = authProvider.sharedEmail;
      }
      if (authProvider.sharedPassword.isNotEmpty) {
        _passwordController.text = authProvider.sharedPassword;
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D01B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D01B),
        leadingWidth: 140,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
            icon: Image.asset('assets/icons/Logo.png', width: 100, height: 100),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        // title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  const Text(
                    'Sign in to your\nAccount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
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
            const SizedBox(height: 20),
            // Form section
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.only(
                  //   topLeft: Radius.circular(24),
                  //   topRight: Radius.circular(24),
                  // ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            // Email field
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

                            // Password field
                            AppTextField(
                              label: 'Password',
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

                            const SizedBox(height: 16),

                            // Remember me and Forgot password
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                                  activeColor: const Color(0xFF4299E1),
                                ),
                                const Text(
                                  'Remember me',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF4A5568),
                                  ),
                                ),
                                // const Spacer(),
                                Expanded(child: Container()),
                                GestureDetector(
                                  onTap: () {
                                    // Handle forgot password
                                  },
                                  child: const Text(
                                    'Forgot Password ?',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF4299E1),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Login button
                            Consumer<AuthProvider>(
                              builder: (context, authProvider, child) {
                                return SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: authProvider.isLoading
                                        ? null
                                        : _handleSignIn,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1D61E7),
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
                                            'Log In',
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

                            const SizedBox(height: 32),

                            // Or login with
                            const Text(
                              'Or login with',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF718096),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Social login buttons
                            Row(
                              children: [
                                Expanded(
                                  child: SocialLoginButton(
                                    text: 'Google',
                                    icon: Image(
                                        image: AssetImage(
                                            'assets/icons/googleicon.png')),
                                    onPressed: () {},
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: SocialLoginButton(
                                    text: 'Facebook',
                                    icon: Image(
                                        image: AssetImage(
                                            'assets/icons/facebookicon.png')),
                                    // color: const Color(0xFF1877F2),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            // Terms and conditions
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF718096),
                                  ),
                                  children: [
                                    TextSpan(
                                        text:
                                            'By signing up, you agree to the '),
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: TextStyle(
                                        color: Color(0xFF4299E1),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(text: ' and\n'),
                                    TextSpan(
                                      text: 'Data Processing Agreement',
                                      style: TextStyle(
                                        color: Color(0xFF4299E1),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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

  void _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success) {
        // Navigate to home or show success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign in successful!')),
        );
      }
    }
  }
}
