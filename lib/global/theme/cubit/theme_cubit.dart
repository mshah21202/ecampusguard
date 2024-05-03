import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeInitial());

  bool darkMode = false;

  void toggleTheme() {
    darkMode = !darkMode;

    emit(ThemeUpdated(darkMode));
  }
}
