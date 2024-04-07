part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  const ThemeState(this.darkMode);

  final bool darkMode;

  @override
  List<Object> get props => [darkMode];
}

class ThemeInitial extends ThemeState {
  const ThemeInitial() : super(false);
}

class ThemeUpdated extends ThemeState {
  const ThemeUpdated(super.darkMode);
}
