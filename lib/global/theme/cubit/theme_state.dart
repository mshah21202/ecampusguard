part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  const ThemeState(this.themeMode);

  final ThemeMode themeMode;

  @override
  List<Object> get props => [themeMode];
}

class ThemeInitial extends ThemeState {
  const ThemeInitial() : super(ThemeMode.light);
}

class ThemeUpdated extends ThemeState {
  const ThemeUpdated(super.themeMode);
}
