import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../models/audio_state.dart';

class AudioPlayerViewModel {
  final _audioStateController = StreamController<AudioState>.broadcast();
  final _currentPositionController = StreamController<Duration>.broadcast();
  final _currentTrackController = StreamController<String>.broadcast();

  late StreamSubscription<Duration> _positionSubscription;
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayerViewModel() {
    _audioStateController.add(AudioState.initial);
    _currentPositionController.add(Duration.zero);
    _currentTrackController.add('');
  }

  // Streams
  Stream<AudioState> get audioStateStream => _audioStateController.stream;
  Stream<Duration> get currentPositionStream =>
      _currentPositionController.stream;
  Stream<String> get currentTrackStream => _currentTrackController.stream;

  Future<void> play(String trackPath) async {
    try {
      _currentTrackController.add(trackPath);
      await _audioPlayer.play(AssetSource('sample.mp3'));
      _audioStateController.add(AudioState.playing);

      // ポジション更新のSubscription
      _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
        _currentPositionController.add(position);
      });

      // 再生完了時の処理
      _audioPlayer.onPlayerComplete.listen((_) {
        _audioStateController.add(AudioState.stopped);
        _currentPositionController.add(Duration.zero);
      });
    } catch (e) {
      debugPrint('Error playing audio: $e');
      _audioStateController.add(AudioState.error);
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    _audioStateController.add(AudioState.paused);
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
    _audioStateController.add(AudioState.playing);
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _audioStateController.add(AudioState.stopped);
    _currentPositionController.add(Duration.zero);
  }

  void dispose() {
    _positionSubscription.cancel();
    _audioPlayer.dispose();
    _audioStateController.close();
    _currentPositionController.close();
    _currentTrackController.close();
  }
}
