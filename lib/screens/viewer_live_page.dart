import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import '../services/stream_service.dart';
import '../widgets/live_layout.dart';

class ViewerLivePage extends StatefulWidget {
  const ViewerLivePage({super.key});

  @override
  State<ViewerLivePage> createState() => _ViewerLivePageState();
}

class _ViewerLivePageState extends State<ViewerLivePage> {
  Call? call;

  @override
  void initState() {
    super.initState();
    join();
  }

  Future<void> join() async {
    final video = StreamService.instance.videoClient;


    call = video.makeCall(
      callType: StreamCallType.liveStream(),
      id: "viva-session-1",
    );

    await call!.join();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (call == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("VIVA Viewer")),
      body: LiveLayout(call: call!),
    );
  }
}
