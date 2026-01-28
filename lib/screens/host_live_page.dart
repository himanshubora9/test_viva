import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../services/stream_service.dart';
import '../widgets/live_layout.dart';

class HostLivePage extends StatefulWidget {
  const HostLivePage({super.key});

  @override
  State<HostLivePage> createState() => _HostLivePageState();
}

class _HostLivePageState extends State<HostLivePage> {
  Call? call;

  @override
  void initState() {
    super.initState();
    start();
  }

  Future<void> start() async {
    final video = StreamService.instance.videoClient;

    call = video.makeCall(
      callType: StreamCallType.liveStream(),
      id: "viva-session-1",
    );

    // ✅ v1.2.2 correct flow
    await call!.getOrCreate();
    // await call!.join();

    await call!.setCameraEnabled(enabled: true);
    await call!.setMicrophoneEnabled(enabled: true);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (call == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("VIVA Host Live")),
      body: LiveLayout(call: call!),
    );
  }
}
