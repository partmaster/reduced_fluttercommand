// fluttercommand_store.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:reduced/reduced.dart';

import 'inherited_widgets.dart';

/// Implementation of the [Store] interface with a [Command] property.
class ReducedStore<S> extends Store<S> {
  ReducedStore(S initialState) : _state = initialState;

  S _state;

  @override
  get state => _state;

  @override
  process(event) => command(event);

  S _process(Event<S> event) => _state = event(_state);

  late final command = Command.createSync(_process, _state);
}

extension ExtensionStoreOnBuildContext on BuildContext {
  /// Convenience method for getting a [ReducedStore] instance.
  ReducedStore<S> store<S>() =>
      InheritedValueWidget.of<ReducedStore<S>>(this);
}
