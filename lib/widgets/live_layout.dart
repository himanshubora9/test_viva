import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../services/stream_service.dart';

class LiveLayout extends StatelessWidget {
  final Call call;

  const LiveLayout({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    final chatClient = StreamService.instance.chatClient;

    final channel = chatClient.channel(
      'livestream',
      id: call.id,
    );

    return StreamChat(
      client: chatClient,
      child: StreamChatTheme(
        data: StreamChatThemeData.light(),
        child: Column(
          children: [
            // Video call display
            Expanded(
              flex: 3,
              child: StreamCallContainer(call: call),
            ),

            // Chat UI
            Expanded(
              flex: 2,
              child: StreamChannel(
                channel: channel,
                child: Column(
                  children: const [
                    Expanded(
                      child: StreamMessageListView(),
                    ),
                    StreamMessageInput(
                      disableAttachments: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
