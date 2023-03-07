// fluttercommand_wrapper.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:reduced/reduced.dart';

import 'inherited_widgets.dart';
import 'fluttercommand_reducible.dart';

Widget wrapWithProvider<S>({
  required S initialState,
  required Widget child,
}) =>
    StatefulInheritedValueWidget(
      converter: (rawValue) => Store(rawValue),
      rawValue: initialState,
      child: child,
    );

extension WrapWithConsumer<S> on Store<S> {}

Widget wrapWithConsumer<S, P>({
  required ReducedTransformer<S, P> transformer,
  required ReducedWidgetBuilder<P> builder,
}) =>
    Builder(builder: (context) {
      final store = context.store<S>();
      return internalWrapWithConsumer(
        store: store,
        transformer: transformer,
        builder: builder,
      );
    });

@visibleForTesting
ValueListenableBuilder<P> internalWrapWithConsumer<S, P>({
  required Store<S> store,
  required ReducedTransformer<S, P> transformer,
  required ReducedWidgetBuilder<P> builder,
}) =>
    ValueListenableBuilder<P>(
      valueListenable: store.command.map((state) => transformer(store)),
      builder: (_, props, ___) => builder(props: props),
    );
