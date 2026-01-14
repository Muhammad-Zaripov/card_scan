import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/presentation/bloc/home_bloc.dart';
import '../screen/settings_screen.dart';

/// {@template settings_controller}
/// Settings controller.
/// {@endtemplate}
abstract class SettingsState extends State<SettingsScreen> {
  /// {@macro settings_controller}
  SettingsState();

  late final HomeBloc homeBloc;

  @override
  void initState() {
    super.initState();
    homeBloc = context.read<HomeBloc>();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
