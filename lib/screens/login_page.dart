import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stream_live/config.dart';
import 'package:stream_live/screens/home_screen.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController empCtrl = TextEditingController(text: '14078');
  TextEditingController roleCtrl = TextEditingController(text: 'host');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 90),
            TextField(
              controller: empCtrl,
              decoration: const InputDecoration(labelText: "Employee ID"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: roleCtrl,
              decoration: const InputDecoration(
                labelText: "host / viewer",
              ),
            ),
            TextButton(
              onPressed: () async {
                await login();
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    final userId = empCtrl.text.trim();
    final role = roleCtrl.text.trim().toLowerCase();

    if (userId.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employee ID is required.')),
      );
      return;
    }

    if (role != 'host' && role != 'viewer') {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Role must be host or viewer.')),
      );
      return;
    }

    final dio = Dio();
    final tokenRes = await dio.get("${Config.backendUrl}/api/stream/token/$userId");

    final streamToken = tokenRes.data['streamToken'];

    try {
      await StreamVideo(
        Config.streamApiKey,
        user: User(
          info: UserInfo(
            id: userId,
            image:
                "https://sso.heterohcl.com/iconnectpics/13078/scaled_1000029643.jpg",
            role: role,
            name: userId,
          ),
          type: UserType.authenticated,
        ),
        userToken: streamToken,
      ).connect();
    } on Exception catch (e) {
      debugPrint('Stream connect error: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to connect to Stream.')),
      );
      return;
    }

    if (context.mounted) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }
}
