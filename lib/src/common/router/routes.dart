import 'package:elixir/elixir.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../feature/home/presentation/bloc/home_bloc.dart';
import '../../feature/home/presentation/bloc/home_state.dart';
import '../../feature/home/presentation/screen/home_screen.dart';
import '../../feature/settings/screen/settings_screen.dart';
import 'custom_material_route.dart';

/// Type definition for the page.
@immutable
sealed class AppPage extends ElixirPage {
  const AppPage({required super.name, required super.child, super.arguments, super.key});

  @override
  int get hashCode => key.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AppPage && key == other.key;

  @override
  String toString() => '/$name${arguments.isEmpty ? '' : '~$arguments'}';
}

final class HomePage extends AppPage {
  HomePage({HomeState? state})
    : super(
        child: BlocProvider(
          create: (context) => HomeBloc(initialState: state),
          child: const HomeScreen(),
        ),
        name: 'home',
      );

  @override
  Set<String> get tags => {'home'};
}

// final class NFCTestPage extends AppPage {
//   const NFCTestPage() : super(child: const NfcTestScreen(), name: 'nfc');

//   @override
//   Set<String> get tags => {'home'};
// }

final class SettingsPage extends AppPage {
  SettingsPage({required final String data})
    : super(
        child: SettingsScreen(data: data),
        name: 'settings',
      );

  @override
  Route<void> createRoute(BuildContext context) => CustomMaterialRoute(page: this);

  @override
  Set<String> get tags => {'settings'};
}
