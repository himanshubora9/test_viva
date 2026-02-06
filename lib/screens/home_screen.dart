import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stream_live/screens/live_sream_screen.dart';
import 'package:stream_live/utils/permission_utils.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? createLoadingText;

  @override
  Widget build(BuildContext context) {
    final isHost = StreamVideo.instance.currentUser.role == 'host';

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            if (isHost)
              ElevatedButton(
                onPressed: createLoadingText == null
                    ? () async {
                        setState(
                          () => createLoadingText = 'Creating Livestream...',
                        );
                        await _createLivestream();
                        setState(() => createLoadingText = null);
                      }
                    : null,
                child: Text(createLoadingText ?? 'Create a Livestream'),
              ),
            ElevatedButton(
              onPressed: () {
                _viewLivestream();
              },
              child: Text('View a Livestream'),
            ),
          ],
        ),
      ),
    );
  }

  String _generateRandomCallId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        6,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  Future<void> _createLivestream() async {
    final hasPermissions = await PermissionUtils.requestCallPermissions();
    if (!hasPermissions) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera and microphone are required.')),
      );
      return;
    }

    // Generate a random short call ID
    final callId = _generateRandomCallId();

    // Set up our call object
    final call = StreamVideo.instance.makeCall(
      callType: StreamCallType.liveStream(),
      id: callId,
    );

    // Create the call and set the current user as a host
    final result = await call.getOrCreate(
      startsAt: DateTime.now().toUtc().add(const Duration(seconds: 120)),
      backstage: const StreamBackstageSettings(
        enabled: true,
        joinAheadTimeSeconds: 120,
      ),
      members: [
        MemberRequest(
          userId: StreamVideo.instance.currentUser.id,
          role: 'host',
        ),
      ],
    );

    if (result.isFailure) {
      debugPrint('result.isFailure :: Not able to create a call.');
      return;
    }

    // // // Configure the call to allow users to join before it starts by setting a future start time
    // // and specifying how many seconds in advance they can join via `joinAheadTimeSeconds`
    // final updateResult = await call.update(
    //   startsAt: DateTime.now().toUtc().add(const Duration(seconds: 120)),
    //   backstage: const StreamBackstageSettings(
    //     enabled: true,
    //     joinAheadTimeSeconds: 120,
    //   ),
    // );
    //
    // if (updateResult.isFailure) {
    //   debugPrint('Not able to update the call.');
    //   return;
    // }

    // Set some default behaviour for how our devices should be configured once we join a call
    final connectOptions = CallConnectOptions(
      camera: TrackOption.enabled(),
      microphone: TrackOption.enabled(),
    );

    // Our local app user can join and receive events
    await call.join(connectOptions: connectOptions);

    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            LiveStreamScreen(livestreamCall: call, callId: callId),
      ),
    );
  }

  Future<void> _viewLivestream() async {
    // Show dialog to get call ID from user
    final callId = await _showCallIdDialog();
    if (callId == null || callId.isEmpty) {
      return;
    }

    // Set up our call object
    final call = StreamVideo.instance.makeCall(
      callType: StreamCallType.liveStream(),
      id: callId,
    );

    final result = await call.getOrCreate(); // Call object is created

    if (result.isSuccess) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Livestream'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  call.leave();
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: LivestreamPlayer(
              call: call,
              joinBehaviour: LivestreamJoinBehaviour.autoJoinAsap,
              connectOptions: CallConnectOptions(
                camera: TrackOption.disabled(),
                microphone: TrackOption.disabled(),
              ),
            ),
          ),
        ),
      );
    } else {
      debugPrint('Not able to create a call.');
    }
  }

  Future<String?> _showCallIdDialog() async {
    final controller = TextEditingController(text: 'test_livestream2');
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Call ID'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter the livestream call ID',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }
}
