import 'dart:async';

/// Copied from https://github.com/PlugFox/throttling/blob/master/lib/src/throttle.dart
/// Throttler
/// Have method [throttle]
class Throttler {
  Throttler({this.duration = const Duration(seconds: 1)}) {
    _subscription.sink.add(true);
  }

  final Duration duration;
  final StreamController<bool> _subscription =
      StreamController<bool>.broadcast();

  bool isReady = true;
  Future<void> get _waiter => Future.delayed(duration);

  Function throttle(Function func) {
    if (!isReady) return null;

    _subscription.sink.add(false);

    isReady = false;

    _waiter
      ..then((_) {
        isReady = true;
        _subscription.sink.add(true);
      });

    return Function.apply(func, []);
  }

  StreamSubscription<bool> listen(Function(bool) onData) =>
      _subscription.stream.listen(onData);

  dispose() {
    _subscription.close();
  }
}
