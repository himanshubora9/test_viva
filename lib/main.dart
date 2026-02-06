import 'package:flutter/material.dart';

import 'screens/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VivaApp());
}

class VivaApp extends StatelessWidget {
  const VivaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VIVA Live',
      theme: ThemeData(useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}
