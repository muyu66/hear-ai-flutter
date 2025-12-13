import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio/just_audio.dart';

// Feed your own stream of bytes into the player
class MyCustomSource extends StreamAudioSource {
  final List<int> bytes;
  MyCustomSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/opp',
    );
  }
}

class AudioManager {
  // 单例
  AudioManager._internal();
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  final _player = AudioPlayer();
  final String baseUrl = dotenv.get(
    'API_URL',
    fallback: 'http://127.0.0.1:3000',
  );

  /// 播放bytes音频
  Future<void> play(Uint8List bytes, {String? mimeType}) async {
    if (isPlaying()) {
      await _player.stop(); // 播放新音频前先停止当前音频
    }
    await _player.setAudioSource(MyCustomSource(bytes));
    await _player.play();
  }

  /// 预载asset音频
  Future<void> preloadAsset(String assetUrl, {String? mimeType}) async {
    await _player.setAsset(assetUrl);
  }

  /// 播放asset音频
  Future<void> playAsset(String assetUrl, {String? mimeType}) async {
    if (isPlaying()) {
      await _player.stop(); // 播放新音频前先停止当前音频
    }
    await _player.setAsset(assetUrl);
    await _player.play();
  }

  /// 播放流音频
  Future<void> playFile(String filePath) async {
    if (isPlaying()) {
      await _player.stop(); // 播放新音频前先停止当前音频
    }
    final file = File(filePath);
    if (!file.existsSync()) {
      debugPrint("需要播放的文件不存在 filePath=$filePath");
      return;
    }
    await _player.setFilePath(filePath);
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
