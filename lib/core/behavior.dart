import 'observable.dart';

/// Observableを拡張した振る舞いを提供するクラス
/// 
/// [T] 監視対象の値の型
/// 
/// Observableを継承し、初期値を持つストリームとして機能する。
/// RxJSのBehaviorSubjectに似た機能を提供する。
class Behavior<T> extends Observable<T> {
  /// コンストラクタ - 親クラスに初期値を渡す
  /// 
  /// [value] 監視対象の初期値
  Behavior(super.value);
}
