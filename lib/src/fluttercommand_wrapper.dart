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

extension WrapWithConsumer<S> on Store<S> {
  Widget wrapWithConsumer<P>({
    required ReducedTransformer<S, P> transformer,
    required ReducedWidgetBuilder<P> builder,
  }) =>
      ValueListenableBuilder<P>(
        valueListenable: command.map((state) => transformer(this)),
        builder: (_, props, ___) => builder(props: props),
      );
}
