# rx_like_demo

このプロジェクトは、Flutterでリアクティブプログラミングの考え方を実装したデモアプリケーションです。RxSwiftやRxJSのような既存のリアクティブプログラミングフレームワークの考え方を参考に、シンプルな実装を目指しました。

## リアクティブプログラミングとは

リアクティブプログラミングは、データの流れと変更の伝播に焦点を当てたプログラミングパラダイムです。主な特徴として：

- データストリーム：全てのデータを時間とともに流れる値の連続（ストリーム）として扱います
- 宣言的：データの変更に対する処理を事前に定義します
- 自動伝播：データの変更が自動的に関連する全ての処理に伝播します

## プロジェクトの実装

### コア機能

#### Observable<T>
基本となるObservableクラスは、値の変更を監視可能にする機能を提供します：
```dart
class Observable<T> {
  void subscribe(Function(T) listener)
  void publish(T newValue)
}
```

#### Behavior<T>
RxSwiftの`BehaviorSubject`に相当する機能を提供します：
- 初期値を持つ
- 購読開始時に最新値を即座に通知
- 値の変更を監視可能

### RxSwiftとの比較

| 機能 | RxSwift | rx_like_demo |
|-----|----------|--------------|
| Subject | `PublishSubject` | `Observable` |
| 初期値付きSubject | `BehaviorSubject` | `Behavior` |
| オペレータ | 豊富な組み込み関数 | 基本機能のみ |
| エラーハンドリング | `Error` 型で明示的 | try-catch |
| スレッド制御 | `Scheduler` | Dart の `async/await` |

### アーキテクチャ

このデモでは、MVVMパターンを採用し、以下のような構成となっています：

```
lib/
  ├── core/           # リアクティブプログラミングの基本実装
  ├── models/         # データモデル
  ├── viewmodels/     # ビジネスロジックとデータの状態管理
  └── views/          # UI実装
```

### 実装例：オーディオプレーヤー

オーディオプレーヤーの実装を例に、リアクティブプログラミングの利点を示しています：

1. **状態管理**
   - 再生状態（再生中/停止中/一時停止）
   - 現在の再生位置
   - 現在の曲情報

2. **イベントストリーム**
   - 再生位置の更新
   - 再生完了の通知
   - エラーハンドリング

3. **UI更新**
   - `StreamBuilder`を使用した宣言的なUI更新
   - 状態変更の自動反映

## 利点

1. **コードの簡潔さ**
   - 状態管理のボイラープレートコードを削減
   - `setState`の使用を最小限に抑制

2. **保守性**
   - データフローが明確
   - 状態変更のトレースが容易

3. **拡張性**
   - 新しい機能の追加が容易
   - テストが書きやすい

## 制限事項

- RxSwiftやRxJSと比較して機能は限定的
- 複雑なオペレータチェーンは未実装
- エラーハンドリングは基本的な実装のみ

## 今後の展望

- より多くのオペレータの実装
- エラーハンドリングの強化
- パフォーマンス最適化
- テストカバレッジの向上

## 参考文献

- [ReactiveX](http://reactivex.io/)
- [RxSwift](https://github.com/ReactiveX/RxSwift)
- [RxJS](https://rxjs.dev/)
