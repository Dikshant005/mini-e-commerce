import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_shop_simple/core/services/theme_storage.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final ThemeStorage _storage = ThemeStorage();
  ThemeCubit() : super(ThemeMode.system) {
    _load();
  }

  void _load() async => emit(await _storage.get());

  void toggle() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(next);
    await _storage.save(next);
  }
}