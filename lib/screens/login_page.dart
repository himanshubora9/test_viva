import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../config.dart';
import '../services/stream_service.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final empCtrl = TextEditingController();
  final roleCtrl = TextEditingController(text: "viewer");
  bool loading = false;

  Future<void> login() async {
    setState(() => loading = true);

    final dio = Dio();
    final tokenRes = await dio.get(
      "${Config.backendUrl}/api/stream/token/${empCtrl.text}",
    );

    final streamToken = tokenRes.data['streamToken'];

    await StreamService.instance.init(
      apiKey: Config.streamApiKey,
      userId: empCtrl.text,
      name: empCtrl.text,
      token: streamToken,
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(role: roleCtrl.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("VIVA Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: empCtrl, decoration: const InputDecoration(labelText: "Employee ID")),
            TextField(controller: roleCtrl, decoration: const InputDecoration(labelText: "host / viewer")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : login,
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
