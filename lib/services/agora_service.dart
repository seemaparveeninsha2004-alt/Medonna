import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraService {
  late RtcEngine _engine;

  Future<void> initAgora(String appId) async {
    await Permission.microphone.request();

    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: appId));

    await _engine.enableAudio();
  }

  Future<void> joinChannel({
    required String token,
    required String channelName,
  }) async {
    await _engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> leaveChannel() async {
    await _engine.leaveChannel();
  }
}
