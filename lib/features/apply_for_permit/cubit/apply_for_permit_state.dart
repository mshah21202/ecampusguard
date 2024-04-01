part of 'apply_for_permit_cubit.dart';

class ApplyForPermitState extends Equatable {
  const ApplyForPermitState({
    this.attendingDays,
    this.selectedCountry,
  });

  final List<bool>? attendingDays;
  final Country? selectedCountry;

  @override
  List<Object> get props => [
        attendingDays ?? [false, false, false, false, false],
        selectedCountry ??
            Country(
              name: "",
              isoCode: "",
              phoneCode: "",
              flag: "",
              currency: "",
              latitude: "",
              longitude: "",
            )
      ];
}

class ApplyForPermitInitial extends ApplyForPermitState {}

class ApplyForPermitUpdated extends ApplyForPermitState {
  const ApplyForPermitUpdated({super.attendingDays});
}

class LoadingCountriesState extends ApplyForPermitState {}

class LoadedCountriesState extends ApplyForPermitState {}

class SelectedCountryState extends ApplyForPermitState {
  SelectedCountryState({super.selectedCountry});
}
