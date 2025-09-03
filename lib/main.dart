import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tumbrtest/presentation/providers/auth_provider.dart';
import 'package:tumbrtest/presentation/screens/signin.dart';
import 'package:tumbrtest/presentation/screens/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Auth App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home:
              // SignInScreen(),
              SignUpScreen()),
    );
  }
}
