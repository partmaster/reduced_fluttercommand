![GitHub release (latest by date)](https://img.shields.io/github/v/release/partmaster/reduced_fluttercommand)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/partmaster/reduced_fluttercommand/dart.yml)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/partmaster/reduced_fluttercommand)
![GitHub last commit](https://img.shields.io/github/last-commit/partmaster/reduced_fluttercommand)
![GitHub commit activity](https://img.shields.io/github/commit-activity/m/partmaster/reduced_fluttercommand)
# reduced_fluttercommand

Implementation of the 'reduced' API for the 'fluttercommand' state management framework with following features:

1. Implementation of the ```ReducedStore``` interface 
2. Extension on the ```BuildContext``` for convenient access to the  ```ReducedStore``` instance.
3. Register a state for management.
4. Trigger a rebuild on widgets selectively after a state change.

## Features

#### 1. Implementation of the ```ReducedStore``` interface 

```dart
class Store<S> extends ReducedStore<S> {
  Store(S initialState) : _state = initialState;

  S _state;

  @override
  get state => _state;

  @override
  reduce(reducer) => command(reducer);

  S _reduce(Reducer<S> reducer) => _state = reducer(_state);

  late final command = Command.createSync(_reduce, _state);
}
```

#### 2. Extension on the ```BuildContext``` for convenient access to the  ```REducedStore``` instance.

```dart
extension ExtensionStoreOnBuildContext on BuildContext {
  Store<S> store<S>() => InheritedValueWidget.of<Store<S>>(this);
}
```

#### 3. Register a state for management.

```dart
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
```

#### 4. Trigger a rebuild on widgets selectively after a state change.

```dart
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

  ValueListenableBuilder<P> _build(Store<S> store) =>
      ValueListenableBuilder<P>(
        valueListenable:
            store.command.map((state) => transformer(store)),
        builder: (_, props, ___) => builder(props: props),
      );
}
```

## Getting started

In the pubspec.yaml add dependencies on the package 'reduced' and on the package  'reduced_fluttercommand'.

```
dependencies:
  reduced: ^0.2.1
  reduced_fluttercommand: ^0.2.1
```

Import package 'reduced' to implement the logic.

```dart
import 'package:reduced/reduced.dart';
```

Import package 'reduced_fluttercommand' to use the logic.

```dart
import 'package:reduced_fluttercommand/reduced_fluttercommand.dart';
```

## Usage

Implementation of the counter demo app logic with the 'reduced' API without further dependencies on state management packages.

```dart
// logic.dart

import 'package:flutter/material.dart';
import 'package:reduced/reduced.dart';

class Incrementer extends Reducer<int> {
  @override
  int call(int state) => state + 1;
}

class Props {
  Props({required this.counterText, required this.onPressed});
  final String counterText;
  final Callable<void> onPressed;
  @override
  toString() => counterText;
}

class PropsTransformer {
  static Props transform(ReducedStore<int> store) => Props(
        counterText: '${store.state}',
        onPressed: CallableAdapter(store, Incrementer()),
      );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.props});

  final Props props;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('reduced_fluttercommand example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(props.counterText),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: props.onPressed,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
}
```

Finished counter demo app using logic.dart and 'reduced_fluttercommand' package:

```dart
// main.dart

import 'package:flutter/material.dart';
import 'package:reduced_fluttercommand/reduced_fluttercommand.dart';
import 'logic.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ReducedProvider(
        initialState: 0,
        child: MaterialApp(
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const ReducedConsumer(
            transformer: PropsTransformer.transform,
            builder: MyHomePage.new,
          ),
        ),
      );
}
```

# Additional information

Implementations of the 'reduced' API are available for the following state management frameworks:

|framework|implementation package for 'reduced' API|
|---|---|
|[Binder](https://pub.dev/packages/binder)|[reduced_binder](https://github.com/partmaster/reduced_binder)|
|[Bloc](https://bloclibrary.dev/#/)|[reduced_bloc](https://github.com/partmaster/reduced_bloc)|
|[FlutterCommand](https://pub.dev/packages/flutter_command)|[reduced_fluttercommand](https://github.com/partmaster/reduced_fluttercommand)|
|[FlutterTriple](https://pub.dev/packages/flutter_triple)|[reduced_fluttertriple](https://github.com/partmaster/reduced_fluttertriple)|
|[GetIt](https://pub.dev/packages/get_it)|[reduced_getit](https://github.com/partmaster/reduced_getit)|
|[GetX](https://pub.dev/packages/get)|[reduced_getx](https://github.com/partmaster/reduced_getx)|
|[MobX](https://pub.dev/packages/mobx)|[reduced_mobx](https://github.com/partmaster/reduced_mobx)|
|[Provider](https://pub.dev/packages/provider)|[reduced_provider](https://github.com/partmaster/reduced_provider)|
|[Redux](https://pub.dev/packages/redux)|[reduced_redux](https://github.com/partmaster/reduced_redux)|
|[Riverpod](https://riverpod.dev/)|[reduced_riverpod](https://github.com/partmaster/reduced_riverpod)|
|[Solidart](https://pub.dev/packages/solidart)|[reduced_solidart](https://github.com/partmaster/reduced_solidart)|
|[StatesRebuilder](https://pub.dev/packages/states_rebuilder)|[reduced_statesrebuilder](https://github.com/partmaster/reduced_statesrebuilder)|
