import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_live/widgets/back_stage_widget.dart';
import 'package:stream_live/widgets/live_stream_ended.dart';
import 'package:stream_live/widgets/liver_stream_live.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class LiveStreamScreen extends StatefulWidget {
  const LiveStreamScreen({
    super.key,
    required this.livestreamCall,
    required this.callId,
  });

  final Call livestreamCall;
  final String callId;

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  late StreamSubscription<CallState> _callStateSubscription;

  @override
  void initState() {
    super.initState();

    _callStateSubscription = widget.livestreamCall.state.valueStream
        .distinct((previous, current) => previous.status != current.status)
        .listen((event) {
          if (event.status is CallStatusDisconnected) {
            // Prompt the user to check their internet connection
          }
        });
  }

  @override
  void dispose() {
    _callStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PartialCallStateBuilder(
      call: widget.livestreamCall,
      selector: (state) =>
          (isBackstage: state.isBackstage, endedAt: state.endedAt),
      builder: (context, callState) {
        return Scaffold(
          body: Builder(
            builder: (context) {
              if (callState.isBackstage) {
                return BackstageWidget(
                  call: widget.livestreamCall,
                  callId: widget.callId,
                );
              }

              if (callState.endedAt != null) {
                return LivestreamEndedWidget(call: widget.livestreamCall);
              }

              return LivestreamLiveWidget(
                call: widget.livestreamCall,
                callId: widget.callId,
              );
            },
          ),
        );
      },
    );
  }
}
