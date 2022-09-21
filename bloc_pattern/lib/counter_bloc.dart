import 'dart:async';

abstract class CounterBase {}

class IncrementCounter extends CounterBase {}

class DecrementCounter extends CounterBase {}

class CounterBloc {
  int _count = 0;

  final StreamController<CounterBase> _input = StreamController();
  final StreamController<int> _output = StreamController();

  CounterBloc() {
    _input.stream.listen(event);
  }

  void event(CounterBase event) {
    if (event is IncrementCounter) {
      _count++;
    } else {
      _count--;
    }

    _output.add(_count);
  }

  void dispose() {
    _input.close();
    _output.close();
  }

  Stream<int> get counterStream => _output.stream;
  StreamSink<CounterBase> get sendEvent => _input.sink;
}
