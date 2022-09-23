// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

// https://www.youtube.com/watch?v=HS2jsM-yzq4&t=10s
// https://github.com/GiancarloCode/bloc-pattern-example

// class NAME extends AnimatedWidget {

//   const NAME ({
//     Key? key,
//   }): super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

abstract class Bloc<Event, State> {
  final PublishSubject<Event> _eventSubject = PublishSubject<Event>();
  late final BehaviorSubject<State> _stateSubject;

  Bloc() {
    _stateSubject = BehaviorSubject<State>.seeded(initialState);
    _bindStateSubject();
  }

  State get initialState;

  State get currentState => _stateSubject.value;

  Stream<State>? get state => _stateSubject.stream;

  Stream<State> mapEventToState(Event event);

  Stream<State> transform(
      Stream<Event> events, Stream<State> next(Event event)) {
    return events.asyncExpand(next);
  }

  void dispatch(Event event) {
    try {
      BlocSupervisor.delegate.onEvent(this, event);
      onEvent(event);
      _eventSubject.add(event);
    } catch (err, stackTrace) {
      _handleError(err, stackTrace);
    }
  }

  @mustCallSuper
  void close() {
    _eventSubject.close();
    _stateSubject.close();
  }

  void onError(Object err, StackTrace? stackTrace) {}

  void onEvent(Event event) {}

  void onTransition(Transition<Event, State> transition) {}

  void _bindStateSubject() {
    late Event currentEvent;

    transform(_eventSubject, (event) {
      currentEvent = event;
      return mapEventToState(event).handleError(_handleError);
    }).forEach((State nextState) {
      if (currentState == nextState || _stateSubject.isClosed) return;

      final transition = Transition(
        currentState: currentState,
        event: currentEvent,
        nextState: nextState,
      );
      BlocSupervisor.delegate.onTransition(this, transition);
      onTransition(transition);

      _stateSubject.add(nextState);
    });
  }

  void _handleError(Object err, [StackTrace? stackTrace]) {
    BlocSupervisor.delegate.onError(this, err, stackTrace);
    onError(err, stackTrace);
  }
}

class Transition<Event, State> {
  final State currentState;
  final Event event;
  final State nextState;

  Transition({
    required this.currentState,
    required this.event,
    required this.nextState,
  });

  @override
  bool operator ==(covariant Transition<Event, State> other) {
    if (identical(this, other)) return true;

    return other.currentState == currentState &&
        other.event == event &&
        other.nextState == nextState;
  }

  @override
  int get hashCode =>
      currentState.hashCode ^ event.hashCode ^ nextState.hashCode;
}

class BlocDelegate {
  @mustCallSuper
  void onEvent(Bloc bloc, dynamic event) {}

  @mustCallSuper
  void onTransition(Bloc bloc, Transition transition) {}

  @mustCallSuper
  void onError(Bloc bloc, Object err, StackTrace? stackTrace) {}
}

class BlocSupervisor {
  BlocDelegate _delegate = BlocDelegate();

  BlocSupervisor._();

  static final BlocSupervisor _instance = BlocSupervisor._();

  static BlocDelegate get delegate => _instance._delegate;

  static set delegate(BlocDelegate? d) =>
      _instance._delegate = d ?? BlocDelegate();
}

typedef BlocWidgetBuilder<S> = Widget Function(BuildContext context, S state);

typedef BlocBuilderCondition<S> = bool Function(S previous, S current);

class BlocBuilder<E, S> extends StatefulWidget {
  final Bloc<E, S> bloc;
  final BlocWidgetBuilder<S> builder;
  final BlocBuilderCondition<S>? condition;

  const BlocBuilder({
    Key? key,
    required this.bloc,
    required this.builder,
    this.condition,
  }) : super(key: key);

  _BlocBuilderState<E, S> createState() => _BlocBuilderState<E, S>();
}

class _BlocBuilderState<E, S> extends State<BlocBuilder<E, S>> {
  StreamSubscription<S>? _subscription;
  late S _previousState;
  late S _state;

  @override
  void initState() {
    super.initState();
    _previousState = widget.bloc.currentState;
    _state = widget.bloc.currentState;
    _subscribe();
  }

  @override
  void didUpdateWidget(BlocBuilder<E, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bloc.state != widget.bloc.state) {
      if (_subscription != null) {
        _unsubscribe();
        _previousState = widget.bloc.currentState;
        _state = widget.bloc.currentState;
      }
      _subscribe();
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _state);

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    if (widget.bloc.state != null) {
      _subscription = widget.bloc.state!.skip(1).listen(
        (S state) {
          if (widget.condition?.call(_previousState, state) ?? true) {
            setState(() {
              _state = state;
            });
          }
          _previousState = state;
        },
      );
    }
  }

  void _unsubscribe() {
    _subscription?.cancel();
  }
}

class BlocProvider<T extends Bloc<dynamic, dynamic>> extends InheritedWidget {
  final T bloc;

  final Widget child;

  BlocProvider({
    Key? key,
    required this.bloc,
    this.child = const SizedBox(),
  }) : super(key: key, child: child);

  static T of<T extends Bloc<dynamic, dynamic>>(BuildContext context) {
    final provider = context
        .getElementForInheritedWidgetOfExactType<BlocProvider<T>>()
        ?.widget as BlocProvider<T>?;

    if (provider == null) {
      throw FlutterError(
        "BlocProvider.of() called with a context that does not contain a Bloc of type $T.",
      );
    }
    return provider.bloc;
  }

  BlocProvider<T> copyWith(Widget child) {
    return BlocProvider<T>(
      key: key,
      bloc: bloc,
      child: child,
    );
  }

  @override
  bool updateShouldNotify(BlocProvider oldWidget) => false;
}
