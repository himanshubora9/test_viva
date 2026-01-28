import 'package:stream_video_flutter/stream_video_flutter.dart' as video;
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as chat;

class StreamService {
  static final StreamService instance = StreamService._();
  StreamService._();

  late video.StreamVideo videoClient;
  late chat.StreamChatClient chatClient;

  Future<void> init({
    required String apiKey,
    required String userId,
    required String name,
    required String role,
    required String token,
  }) async {
    final videoUser = video.User(
      info: video.UserInfo(
        id: userId,
        name: name,
        role: role,
      ),
    );

    videoClient = video.StreamVideo(
      apiKey,
      user: videoUser,
      userToken: token,
    );

    chatClient = chat.StreamChatClient(apiKey);

    await chatClient.connectUser(
      chat.User(id: userId, name: name),
      token,
    );
  }
}
