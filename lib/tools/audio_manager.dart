import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hearai/apis/auth_store.dart';
import 'package:just_audio/just_audio.dart';

class StreamSource extends StreamAudioSource {
  final List<int> bytes;
  StreamSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/ogg',
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

  Future<Uint8List> _streamToBytes(Stream<Uint8List> stream) async {
    final bytes = await stream.fold<List<int>>([], (previous, element) {
      previous.addAll(element);
      return previous;
    });
    return Uint8List.fromList(bytes);
  }

  /// 播放URL音频
  Future<void> play(String url, {String? mimeType}) async {
    if (isPlaying()) {
      await _player.stop(); // 播放新音频前先停止当前音频
    }
    await _player.setAudioSource(
      AudioSource.uri(
        Uri.parse(url),
        // 后端来源才需要传递token，第三方音频不需要
        headers: url.contains(baseUrl)
            ? AuthStore().isLoggedIn
                  ? {"Authorization": 'Bearer ${AuthStore().accessToken}'}
                  : null
            : null,
      ),
    );
    await _player.play();
  }

  /// 播放asset音频
  Future<void> playAsset(String assetUrl) async {
    if (isPlaying()) {
      await _player.stop(); // 播放新音频前先停止当前音频
    }
    await _player.setAudioSource(AudioSource.asset(assetUrl));
    await _player.play();
  }

  /// 播放字节音频
  Future<void> playBytes(List<int> bytes) async {
    if (isPlaying()) {
      await _player.stop(); // 播放新音频前先停止当前音频
    }
    await _player.setAudioSource(StreamSource(bytes));
    await _player.play();
  }

  /// 播放流音频
  Future<void> playStream(Stream<Uint8List> stream) async {
    if (isPlaying()) {
      await _player.stop(); // 播放新音频前先停止当前音频
    }
    await _player.setAudioSource(StreamSource(await _streamToBytes(stream)));
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
