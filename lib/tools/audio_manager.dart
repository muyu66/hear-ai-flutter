import 'package:hearai/apis/auth_store.dart';
import 'package:just_audio/just_audio.dart';

class AudioManager {
  // 单例
  AudioManager._internal();
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  final _player = AudioPlayer();

  /// 播放URL音频
  Future<void> play(String url, {String? mimeType}) async {
    if (isPlaying()) {
      await _player.stop(); // 播放新音频前先停止当前音频
    }
    if (AuthStore().isLoggedIn) {
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(url),
          headers: {"Authorization": 'Bearer ${AuthStore().accessToken}'},
        ),
      );
      await _player.play();
    }
  }

  /// 播放asset音频
  Future<void> playAsset(String assetUrl) async {
    if (isPlaying()) {
      await _player.stop(); // 播放新音频前先停止当前音频
    }
    await _player.setAudioSource(AudioSource.asset(assetUrl));
    await _player.play();
  }

  /// 暂停
  Future<void> pause() => _player.pause();

  /// 停止
  Future<void> stop() async {
    if (isPlaying()) {
      await _player.stop();
    }
  }

  /// 设置音量
  Future<void> setVolume(double volume) => _player.setVolume(volume);

  /// 是否正在播放
  bool isPlaying() {
    return _player.playing;
  }
}
