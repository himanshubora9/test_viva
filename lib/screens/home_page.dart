import 'package:flutter/material.dart';
import 'host_live_page.dart';
import 'viewer_live_page.dart';

class HomePage extends StatelessWidget {
  final String role;
  const HomePage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("VIVA Live Home")),
      body: Center(
        child: ElevatedButton(
          child: Text(role == "host" ? "Start Live" : "Join Live"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                role == "host" ? const HostLivePage() : const ViewerLivePage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
