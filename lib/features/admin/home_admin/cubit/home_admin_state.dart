part of 'home_admin_cubit.dart';

class HomeAdminState extends Equatable {
  const HomeAdminState(
      {this.areaSummaries, this.snackBarMessage, this.applicationSummaries});

  final String? snackBarMessage;
  final List<ApplicationSummaryDto>? applicationSummaries;
  final List<AreaDto>? areaSummaries;

  @override
  List<Object> get props => [
        snackBarMessage ?? "",
        applicationSummaries ?? [],
        areaSummaries ?? [],
      ];
}

class HomeAdminInitial extends HomeAdminState {}

class HomeAdminLoading extends HomeAdminState {}

class HomeAdminLoaded extends HomeAdminState {
  const HomeAdminLoaded({
    super.snackBarMessage,
    super.applicationSummaries,
    super.areaSummaries,
  });
}

class HomeAdminError extends HomeAdminState {
  const HomeAdminError({super.snackBarMessage});
}
