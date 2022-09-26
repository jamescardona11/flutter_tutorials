// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: DojoProvider<ExampleDojoRoom, StateToTest>(
        dojo: ExampleDojoRoom(StateToTest()),
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  /// default constructor
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // DojoBuilder<ExampleDojoRoom>(
                  //   builder: (context, state) {
                  //     return Text('HomePage ${state.count}');
                  //   },
                  // ),
                  Builder(
                    builder: (context) {
                      print('BUILDER NormalWith S');
                      final count = Dojo.select<StateToTest, int>(
                          context, (state) => state.count);
                      return Text('HomePage ${count} as');
                    },
                  ),
                  // Builder(
                  //   builder: (context) {
                  //     print('BUILDER NormalWith W');
                  //     final count = Dojo.watch<ExampleDojoRoom>(context);
                  //     return Text('HomePage ${count.state.count} as');
                  //   },
                  // ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        /// The action is executed in the [ApplicationContext].
        onPressed: () {
          final dojo = Dojo.read<ExampleDojoRoom>(context);
          dojo.increment();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class StateToTest {
  final int count;

  StateToTest({
    this.count = 0,
  });

  StateToTest copyWith({
    int? count,
  }) {
    return StateToTest(
      count: count ?? this.count,
    );
  }
}

class ExampleDojoRoom extends DojoRoom<StateToTest> {
  ExampleDojoRoom(super.initialState);

  void increment() {
    dispatch(
      state.copyWith(
        count: state.count + 1,
      ),
    );
  }
}

// ---------------------------DOJO

typedef DBuilder<DState> = Widget Function(BuildContext context, DState state);

class DojoBuilder<DRoom extends DojoRoom> extends StatelessWidget {
  /// default constructor
  const DojoBuilder({
    Key? key,
    required this.builder,
    this.child,
  }) : super(key: key);

  final DBuilder builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final gym = Dojo.read<DRoom>(context);

      return builder.call(context, gym.state);
    });
  }
}

//event
abstract class Action<DState> {
  const Action(this.newState);

  final DState newState;
}

class GenericStateChangeAction<DState> extends Action<DState> {
  const GenericStateChangeAction(super.newState);
}

typedef Dispatch = Future<void> Function(Action event);

/// inherited widget
class DojoGym<DRoom extends DojoRoom> extends InheritedWidget {
  const DojoGym({
    super.key,
    required super.child,
    required this.dojoRoom,
  });

  final DRoom dojoRoom;

  static DojoRoom of<DRoom extends DojoRoom>(
    BuildContext context, {
    bool listen = false,
  }) {
    final gym = listen
        ? context.dependOnInheritedWidgetOfExactType<DojoGym<DRoom>>()
        : (context
            .getElementForInheritedWidgetOfExactType<DojoGym<DRoom>>()
            ?.widget as DojoGym<DRoom>?);

    if (gym == null) {
      //THROW
    }

    return gym!.dojoRoom;
  }

  @override
  bool updateShouldNotify(DojoGym oldWidget) {
    return true;
  }
}

/// inherited model
class DojoSelector<DState> extends InheritedModel<Selector> {
  const DojoSelector({
    super.key,
    required this.state,
    required super.child,
  });

  final DState state;

  @override
  bool updateShouldNotify(covariant DojoSelector<DState> oldWidget) {
    print('HERE');
    return state != oldWidget.state;
  }

  @override
  bool updateShouldNotifyDependent(
      covariant DojoSelector<DState> oldWidget, Set<Selector> dependencies) {
    print('HERE2');
    return dependencies.any(
      (selector) => selector(oldWidget.state) != selector(state),
    );
  }
}

// provider
typedef ProviderState<DTState> = DTState Function(BuildContext context);

class DojoProvider<DRoom extends DojoRoom<DState>, DState>
    extends StatefulWidget {
  const DojoProvider({
    super.key,
    required this.dojo,
    required this.child,
  });

  final DRoom dojo;
  final Widget child;

  @override
  State<DojoProvider<DRoom, DState>> createState() =>
      _DojoProviderState<DRoom, DState>();
}

class _DojoProviderState<DRoom extends DojoRoom<DState>, DState>
    extends State<DojoProvider<DRoom, DState>> {
  late DState _lastState;

  @override
  void initState() {
    _lastState = widget.dojo.state;
    widget.dojo.addListener(_onStateUpdate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DojoGym<DRoom>(
      dojoRoom: widget.dojo,
      child: DojoSelector(
        state: widget.dojo.state,
        child: widget.child,
      ),
    );
  }

  void _onStateUpdate() {
    if (_lastState != widget.dojo.state) {
      _lastState = widget.dojo.state;
      print('HEREEEEE');
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.dojo.removeListener(_onStateUpdate);
    super.dispose();
  }
}

// class MultiDojoProvider<DState> extends StatefulWidget {
//   const MultiDojoProvider({
//     super.key,
//     required this.initState,
//     required this.dojo,
//     required this.child,
//   });

//   final ProviderState initState;
//   final Dojo<State> dojo;
//   final Widget child;

//   @override
//   State<MultiDojoProvider<DState>> createState() =>
//       _MultiDojoProviderState<DState>();
// }

// class _MultiDojoProviderState<DState> extends State<MultiDojoProvider<DState>> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

/// emitir nuevos estados
abstract class DojoRoom<DState> extends ChangeNotifier {
  DState _state;

  DojoRoom(DState initialState) : _state = initialState;

  void dispatch(DState newState) async {
    _dispatchAction(GenericStateChangeAction(newState));
  }

  void _dispatchAction(Action event) {
    state = event.newState;
  }

  @protected
  set state(DState state) {
    if (_state != state) {
      _state = state;
      notifyListeners();
    }
  }

  DState get state => _state;
}

/// read, watch, dispatch, etc, etc
typedef Selector<DState, S> = S Function(DState state);

class Dojo {
  static S select<DState, S>(
    BuildContext context,
    Selector<DState, S> selector,
  ) {
    final Selector untypedSelector = (state) => selector(state);
    final provider = InheritedModel.inheritFrom<DojoSelector<DState>>(
      context,
      aspect: untypedSelector,
    );
    return selector(provider!.state);
  }

  static DRoom read<DRoom extends DojoRoom>(BuildContext context) {
    return DojoGym.of<DRoom>(context) as DRoom;
  }

  static DRoom watch<DRoom extends DojoRoom>(BuildContext context) {
    return DojoGym.of<DRoom>(context, listen: true) as DRoom;
  }

  // Future<void> dispatch<DState>(BuildContext context, Event event) =>
  //     Dispatcher.of<DState>(this)(event);

  // static listen<DRoom extends DojoRoom>() {}
}

/// eventos
abstract class DojoEvents<DAction extends Action> {
  Stream<void> onDojoEvent(DAction event);
}
