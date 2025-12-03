import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class RecordManager {
  // 单例
  static final RecordManager _instance = RecordManager._internal();
  factory RecordManager() => _instance;
  RecordManager._internal();

  final _record = AudioRecorder();
  AudioEncoder _encoder = AudioEncoder.wav;

  Future<void> init() async {
    if (await _record.isEncoderSupported(AudioEncoder.opus)) {
      _encoder = AudioEncoder.opus;
    }
  }

  Future<bool> hasPermission() async {
    return await _record.hasPermission();
  }

  Future<String> _getPath() async {
    final dir = await getTemporaryDirectory();
    final recordDir = Directory(p.join(dir.path, 'records'));
    if (!await recordDir.exists()) {
      await recordDir.create(recursive: true);
    }
    return p.join(
      recordDir.path,
      '${DateTime.now().millisecondsSinceEpoch}.wav',
    );
  }

  Future<void> start() async {
    if (await hasPermission()) {
      await _record.start(
        RecordConfig(
          encoder: _encoder,
          numChannels: 1,
          bitRate: 64000,
          sampleRate: 22050,
        ),
        path: await _getPath(),
      );
    }
  }

  Future<String?> stop() async {
    return await _record.stop(); // 返回录音文件路径
  }

  Future<bool> isRecording() async {
    return await _record.isRecording();
  }
}
