import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  // 单例
  AudioManager._internal();
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  final AudioPlayer _player = AudioPlayer();

  /// 播放音频
  Future<void> play(
    String url, {
    bool isLocal = false,
    String? mimeType,
  }) async {
    await _player.stop(); // 播放新音频前先停止当前音频
    if (isLocal) {
      await _player.play(DeviceFileSource(url, mimeType: mimeType));
    } else {
      await _player.play(UrlSource(url, mimeType: mimeType));
    }
  }

  /// 暂停
  Future<void> pause() => _player.pause();

  /// 停止
  Future<void> stop() async {
    if (await isPlaying()) {
      _player.stop();
    }
  }

  /// 设置音量
  Future<void> setVolume(double volume) => _player.setVolume(volume);

  /// 是否正在播放
  Future<bool> isPlaying() async {
    final state = _player.state;
    return state == PlayerState.playing;
  }
}
