import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../services/stream_service.dart';

class LiveLayout extends StatelessWidget {
  final Call call;

  const LiveLayout({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    final channel = StreamService.instance.chatClient.channel(
      'livestream',
      id: call.id,
    );

    return Column(
      children: [
        // Video call display
        Expanded(flex: 3, child: StreamCallContainer(call: call)),

        // Chat UI
        Expanded(
          flex: 2,
          child: StreamChannel(
            channel: channel,
            child: Column(
              children: [
                Expanded(
                  child: StreamMessageListView(), // Correct chat message list
                ),
                const StreamMessageInput(), // Correct input widget
              ],
            ),
          ),
        ),
      ],
    );
  }
}
