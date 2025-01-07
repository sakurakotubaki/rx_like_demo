import 'package:flutter/material.dart';
import '../viewmodels/audio_player_viewmodel.dart';
import '../models/audio_state.dart';

/// オーディオプレーヤーのUIを提供するウィジェット
class AudioPlayerView extends StatefulWidget {
  /// コンストラクタ
  const AudioPlayerView({super.key});

  @override
  _AudioPlayerViewState createState() => _AudioPlayerViewState();
}

/// AudioPlayerViewの状態を管理するState
class _AudioPlayerViewState extends State<AudioPlayerView> {
  /// ViewModelのインスタンス
  final _viewModel = AudioPlayerViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio Player')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 現在の曲名を表示
            StreamBuilder<String>(
              stream: _viewModel.currentTrackStream,
              initialData: '',
              builder: (context, snapshot) {
                return Text(
                  snapshot.data?.isEmpty ?? true 
                    ? 'No track selected' 
                    : snapshot.data!,
                  style: Theme.of(context).textTheme.titleLarge,
                );
              }
            ),
            
            const SizedBox(height: 20),
            
            // 再生位置を表示
            StreamBuilder<Duration>(
              stream: _viewModel.currentPositionStream,
              initialData: Duration.zero,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                return Text(
                  '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.titleMedium,
                );
              }
            ),
            
            const SizedBox(height: 30),
            
            // 再生状態に応じたボタンを表示
            StreamBuilder<AudioState>(
              stream: _viewModel.audioStateStream,
              initialData: AudioState.initial,
              builder: (context, snapshot) {
                final state = snapshot.data;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 48,
                      icon: Icon(
                        state == AudioState.playing ? Icons.pause : Icons.play_arrow,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        if (state == AudioState.playing) {
                          _viewModel.pause();
                        } else if (state == AudioState.paused) {
                          _viewModel.resume();
                        } else {
                          _viewModel.play('assets/sample.mp3');
                        }
                      },
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      iconSize: 48,
                      icon: Icon(
                        Icons.stop,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: state == AudioState.initial || state == AudioState.stopped 
                        ? null 
                        : () => _viewModel.stop(),
                    ),
                  ],
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
