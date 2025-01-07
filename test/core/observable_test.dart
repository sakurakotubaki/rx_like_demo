import 'package:flutter_test/flutter_test.dart';
import 'package:rx_like_demo/core/observable.dart';

void main() {
  group('Observable Tests', () {
    late Observable<int> observable;

    setUp(() {
      observable = Observable<int>(0);
    });

    test('初期値が正しく設定されること', () {
      expect(observable.value, equals(0));
    });

    test('publishで値が更新され、リスナーに通知されること', () {
      int? receivedValue;
      observable.subscribe((value) {
        receivedValue = value;
      });

      observable.publish(42);
      expect(receivedValue, equals(42));
    });

    test('複数のリスナーに正しく通知されること', () {
      int receivedValue1 = 0;
      int receivedValue2 = 0;

      observable.subscribe((value) {
        receivedValue1 = value;
      });

      observable.subscribe((value) {
        receivedValue2 = value;
      });

      observable.publish(100);
      
      expect(receivedValue1, equals(100));
      expect(receivedValue2, equals(100));
    });

    test('subscribeした時点で現在の値が通知されること', () {
      int? receivedValue;
      observable.publish(50);

      observable.subscribe((value) {
        receivedValue = value;
      });

      expect(receivedValue, equals(50));
    });

    test('disposeでリスナーがクリアされること', () {
      int callCount = 0;
      observable.subscribe((value) {
        callCount++;
      });

      observable.publish(1); // callCount = 2 (初期値通知 + publish)
      observable.dispose();
      observable.publish(2); // disposeされているので通知されない

      expect(callCount, equals(2));
    });

    test('文字列型でも動作すること', () {
      final stringObservable = Observable<String>('initial');
      String? receivedValue;

      stringObservable.subscribe((value) {
        receivedValue = value;
      });

      stringObservable.publish('updated');
      expect(receivedValue, equals('updated'));
    });
  });
}
