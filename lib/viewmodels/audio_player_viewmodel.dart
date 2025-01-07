import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../models/audio_state.dart';

/// オーディオプレーヤーの状態管理とコントロールを行うViewModel
class AudioPlayerViewModel {
  /// オーディオの再生状態を管理するStreamController
  final _audioStateController = StreamController<AudioState>.broadcast();
  /// 現在の再生位置を管理するStreamController
  final _currentPositionController = StreamController<Duration>.broadcast();
  /// 現在の曲名を管理するStreamController
  final _currentTrackController = StreamController<String>.broadcast();

  /// 再生位置の更新を購読するSubscription
  late StreamSubscription<Duration> _positionSubscription;
  /// オーディオプレーヤーのインスタンス
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// コンストラクタ - 初期状態をStreamに流す
  AudioPlayerViewModel() {
    _audioStateController.add(AudioState.initial);
    _currentPositionController.add(Duration.zero);
    _currentTrackController.add('');
  }

  /// オーディオの再生状態を監視するStream
  Stream<AudioState> get audioStateStream => _audioStateController.stream;
  /// 現在の再生位置を監視するStream
  Stream<Duration> get currentPositionStream =>
      _currentPositionController.stream;
  /// 現在の曲名を監視するStream
  Stream<String> get currentTrackStream => _currentTrackController.stream;

  /// 指定された音声ファイルを再生する
  /// 
  /// [trackPath] - 再生する音声ファイルのパス
  /// 
  /// エラーが発生した場合は、AudioState.errorを発行し、エラーメッセージをログに出力
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

  /// 再生を一時停止する
  Future<void> pause() async {
    await _audioPlayer.pause();
    _audioStateController.add(AudioState.paused);
  }

  /// 再生を再開する
  Future<void> resume() async {
    await _audioPlayer.resume();
    _audioStateController.add(AudioState.playing);
  }

  /// 再生を停止する
  Future<void> stop() async {
    await _audioPlayer.stop();
    _audioStateController.add(AudioState.stopped);
    _currentPositionController.add(Duration.zero);
  }

  /// リソースを解放する
  /// 
  /// StreamControllerとAudioPlayerを適切に破棄
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayer.dispose();
    _audioStateController.close();
    _currentPositionController.close();
    _currentTrackController.close();
  }
}
