// fluttercommand_wrapper.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:reduced/reduced.dart';

import 'fluttercommand_store.dart';
import 'inherited_widgets.dart';

class ReducedProvider<S> extends StatelessWidget {
  const ReducedProvider({
    super.key,
    required this.initialState,
    required this.child,
  });

  final S initialState;
  final Widget child;

  @override
  Widget build(context) => StatefulInheritedValueWidget(
        converter: (rawValue) => Store(rawValue),
        rawValue: initialState,
        child: child,
      );
}

class ReducedConsumer<S, P> extends StatelessWidget {
  const ReducedConsumer({
    super.key,
    required this.transformer,
    required this.builder,
  });

  final ReducedTransformer<S, P> transformer;
  final ReducedWidgetBuilder<P> builder;

  @override
  Widget build(BuildContext context) => _build(context.store<S>());

  ValueListenableBuilder<P> _build(Store<S> store) => ValueListenableBuilder<P>(
        valueListenable: store.command.map((state) => transformer(store)),
        builder: (_, props, ___) => builder(props: props),
      );
}
