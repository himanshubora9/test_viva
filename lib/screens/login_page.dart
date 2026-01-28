import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import '../services/stream_service.dart';
import '../utils/permission_utils.dart';
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

  Future<void> permissions() async {
    await PermissionUtils.requestCallPermissions();
  }

  Future<void> login() async {
    try {
      // setState(() => loading = true);
      final url = "${Config.backendUrl}/api/stream/token/${empCtrl.text}";
      print('url :: $url');
      http: //192.168.213.172:4000/api/stream/token/14078
      http: //192.168.213.172:4000/api/stream/token/13078
      final dio = Dio();
      final tokenRes = await dio.get(
        url,
        options: Options(
          receiveTimeout: Duration(seconds: 30),
          connectTimeout: Duration(seconds: 30),
          sendTimeout: Duration(seconds: 30),
        ),
      );

      final streamToken = tokenRes.data['streamToken'];

      await StreamService.instance.init(
        apiKey: Config.streamApiKey,
        userId: empCtrl.text,
        name: empCtrl.text,
        role: roleCtrl.text,
        token: streamToken,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(role: roleCtrl.text)),
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    permissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("VIVA Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: empCtrl,
              decoration: const InputDecoration(labelText: "Employee ID"),
            ),
            TextField(
              controller: roleCtrl,
              decoration: const InputDecoration(labelText: "host / viewer"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => login(),
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
