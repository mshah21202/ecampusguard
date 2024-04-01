import 'package:bloc/bloc.dart';
import 'package:country_state_city/models/country.dart';
import 'package:country_state_city/utils/country_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'apply_for_permit_state.dart';

class ApplyForPermitCubit extends Cubit<ApplyForPermitState> {
  ApplyForPermitCubit() : super(ApplyForPermitInitial());

  Map<String, bool> _attendingDays = {
    "Sun": false,
    "Mon": false,
    "Tue": false,
    "Wed": false,
    "Thu": false
  };

  final attendingDaysController = TextEditingController();
  final TextEditingController academicYearController = TextEditingController();
  int? academicYear;

  List<bool> get attendingDays => _attendingDays.values.toList();
  List<String> get daysNames => _attendingDays.keys.toList();
  List<String> get academicYears => [
        "First Year",
        "Second Year",
        "Third Year",
        "Forth Year",
        "Fifth Year (Engineering Students)"
      ];

  List<Country> countries = [];
  Country? selectedCountry;

  // DropdownButton(
  //                       items: cubit.countries
  //                           .map((country) => DropdownMenuItem(
  //                                 child: Text(country.name),
  //                                 value: country.isoCode,
  //                               ))
  //                           .toList(),
  //                       onChanged: (value) {},
  //                     ),

  void loadCountries() async {
    emit(LoadingCountriesState());
    countries = await getAllCountries();
    selectedCountry =
        countries.firstWhere((country) => country.isoCode == "JO");
    emit(LoadedCountriesState());
  }

  void setSelectedCountry(Country country) {
    selectedCountry = country;
    emit(SelectedCountryState(selectedCountry: selectedCountry));
  }

  void handleAttendingDays() {
    _setAttendingDaysText();
  }

  void _setAttendingDaysText() {
    Map<String, bool> days = Map<String, bool>.from(_attendingDays);
    days.removeWhere((key, value) => !value);

    List<String> daysStrings = days.keys.toList();

    attendingDaysController.text = daysStrings.join(',');
  }

  void onChangedAttendingDay(int index) {
    _attendingDays[_attendingDays.keys.elementAt(index)] =
        !_attendingDays[_attendingDays.keys.elementAt(index)]!;

    _setAttendingDaysText();
    emit(ApplyForPermitUpdated(attendingDays: _attendingDays.values.toList()));
  }
}
