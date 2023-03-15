// fluttercommand_widgets.dart

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
        converter: (rawValue) => ReducedStore(rawValue),
        rawValue: initialState,
        child: child,
      );
}

class ReducedConsumer<S, P> extends StatelessWidget {
  const ReducedConsumer({
    super.key,
    required this.mapper,
    required this.builder,
  });

  final StateToPropsMapper<S, P> mapper;
  final WidgetFromPropsBuilder<P> builder;

  @override
  Widget build(BuildContext context) => _build(context.store<S>());

  ValueListenableBuilder<P> _build(ReducedStore<S> store) =>
      ValueListenableBuilder<P>(
        valueListenable:
            store.command.map((state) => mapper(store.state, store)),
        builder: (_, props, ___) => builder(props: props),
      );
}
