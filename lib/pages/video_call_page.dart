import 'package:flutter/material.dart';
import '../services/agora_service.dart';

class VideoCallPage extends StatefulWidget {
  final String appId;
  final String token;
  final String channel;

  const VideoCallPage({
    super.key,
    required this.appId,
    required this.token,
    required this.channel,
  });

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  final AgoraService _agoraService = AgoraService();

  @override
  void initState() {
    super.initState();

    _init();
  }

  Future<void> _init() async {
    await _agoraService.initAgora(widget.appId);
    await _agoraService.joinChannel(
      token: widget.token,
      channelName: widget.channel,
    );
  }

  @override
  void dispose() {
    _agoraService.leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medonna AI Voice")),
      body: const Center(
        child: Text(
          "🎤 Listening... (Agora Audio Channel Active)",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
