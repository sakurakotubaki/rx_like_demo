class Observable<T> {
  final List<Function(T)> _listeners = [];
  T _value;

  Observable(this._value);

  T get value => _value;

  void subscribe(Function(T) listener) {
    _listeners.add(listener);
    listener(_value); // 初期値を通知
  }

  void publish(T newValue) {
    _value = newValue;
    for (var listener in _listeners) {
      listener(newValue);
    }
  }

  void dispose() {
    _listeners.clear();
  }
}
