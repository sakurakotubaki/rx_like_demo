/// 値の変更を監視可能にするジェネリッククラス
/// 
/// [T] 監視対象の値の型
class Observable<T> {
  /// 値の変更を監視するリスナーのリスト
  final List<Function(T)> _listeners = [];
  
  /// 現在の値
  T _value;

  /// コンストラクタ - 初期値を設定
  /// 
  /// [_value] 監視対象の初期値
  Observable(this._value);

  /// 現在の値を取得
  T get value => _value;

  /// 値の変更を監視するリスナーを登録
  /// 
  /// [listener] 値が変更された時に呼び出されるコールバック関数
  /// 登録時に現在の値で即座にコールバックを呼び出す
  void subscribe(Function(T) listener) {
    _listeners.add(listener);
    listener(_value); // 初期値を通知
  }

  /// 新しい値を設定し、全てのリスナーに通知
  /// 
  /// [newValue] 設定する新しい値
  void publish(T newValue) {
    _value = newValue;
    for (var listener in _listeners) {
      listener(newValue);
    }
  }

  /// リソースの解放
  /// 
  /// 全てのリスナーをクリア
  void dispose() {
    _listeners.clear();
  }
}
