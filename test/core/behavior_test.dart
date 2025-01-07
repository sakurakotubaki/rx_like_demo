import 'package:flutter_test/flutter_test.dart';
import 'package:rx_like_demo/core/behavior.dart';

void main() {
  group('Behavior Tests', () {
    late Behavior<int> behavior;

    setUp(() {
      behavior = Behavior<int>(0);
    });

    test('初期値が正しく設定されること', () {
      expect(behavior.value, equals(0));
    });

    test('subscribeした時点で初期値が通知されること', () {
      int? receivedValue;
      behavior.subscribe((value) {
        receivedValue = value;
      });

      expect(receivedValue, equals(0));
    });

    test('値の更新が正しく通知されること', () {
      List<int> receivedValues = [];
      behavior.subscribe((value) {
        receivedValues.add(value);
      });

      behavior.publish(1);
      behavior.publish(2);
      behavior.publish(3);

      expect(receivedValues, equals([0, 1, 2, 3])); // 0は初期値
    });

    test('複数のリスナーが正しく動作すること', () {
      List<int> receivedValues1 = [];
      List<int> receivedValues2 = [];

      behavior.subscribe((value) {
        receivedValues1.add(value);
      });

      behavior.publish(1);

      behavior.subscribe((value) {
        receivedValues2.add(value);
      });

      behavior.publish(2);

      expect(receivedValues1, equals([0, 1, 2]));
      expect(receivedValues2, equals([1, 2]));
    });

    test('nullableな型でも動作すること', () {
      final nullableBehavior = Behavior<int?>(null);
      List<int?> receivedValues = [];

      nullableBehavior.subscribe((value) {
        receivedValues.add(value);
      });

      nullableBehavior.publish(1);
      nullableBehavior.publish(null);
      nullableBehavior.publish(2);

      expect(receivedValues, equals([null, 1, null, 2]));
    });

    test('カスタム型でも動作すること', () {
      final person = Person('John', 30);
      final personBehavior = Behavior<Person>(person);
      Person? receivedPerson;

      personBehavior.subscribe((value) {
        receivedPerson = value;
      });

      final newPerson = Person('Jane', 25);
      personBehavior.publish(newPerson);

      expect(receivedPerson?.name, equals('Jane'));
      expect(receivedPerson?.age, equals(25));
    });
  });
}

// テスト用のカスタムクラス
class Person {
  final String name;
  final int age;

  Person(this.name, this.age);
}
