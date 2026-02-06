import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class BackstageWidget extends StatelessWidget {
  const BackstageWidget({super.key, required this.call, required this.callId});

  final Call call;
  final String callId;

  @override
  Widget build(BuildContext context) {
    return PartialCallStateBuilder(
      call: call,
      selector: (state) =>
          state.callParticipants.where((p) => !p.roles.contains('host')).length,
      builder: (context, waitingParticipantsCount) {
        return Center(
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Text(
                      'Call ID',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      callId,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              PartialCallStateBuilder(
                call: call,
                selector: (state) => state.startsAt,
                builder: (context, startsAt) {
                  return Text(
                    startsAt != null
                        ? 'Livestream starting at ${DateFormat('HH:mm').format(startsAt.toLocal())}'
                        : 'Livestream starting soon',
                    style: Theme.of(context).textTheme.titleLarge,
                  );
                },
              ),
              if (waitingParticipantsCount > 0)
                Text('$waitingParticipantsCount participants waiting'),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (!call.state.value.status.isJoined) {
                    debugPrint("Call not joined yet");
                    return;
                  }

                  final result = await call.goLive();

                  if (result.isFailure) {
                    debugPrint("GoLive error: ${result}");
                  } else {
                    debugPrint("🎉 Stream is LIVE!");
                  }
                },
                child: const Text('Go Live'),
              ),

              ElevatedButton(
                onPressed: () {
                  call.leave();
                  Navigator.pop(context);
                },
                child: const Text('Leave Livestream'),
              ),
            ],
          ),
        );
      },
    );
  }
}
