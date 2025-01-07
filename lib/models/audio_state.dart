/// オーディオプレーヤーの状態を表す列挙型
enum AudioState {
  /// 初期状態
  initial,
  /// 再生中
  playing,
  /// 一時停止中
  paused,
  /// 停止中
  stopped,
  /// エラー発生
  error
}
