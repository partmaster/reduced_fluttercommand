// fluttercommand_store.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:reduced/reduced.dart';

import 'inherited_widgets.dart';

/// Implementation of the [ReducedStore] interface with a [Command] property.
class Store<S> extends ReducedStore<S> {
  Store(S initialState) : _state = initialState;

  S _state;

  @override
  get state => _state;

  @override
  dispatch(event) => command(event);

  S _reduce(Event<S> event) => _state = event(_state);

  late final command = Command.createSync(_reduce, _state);
}

extension ExtensionStoreOnBuildContext on BuildContext {
  /// Convenience method for getting a [Store] instance.
  Store<S> store<S>() => InheritedValueWidget.of<Store<S>>(this);
}
