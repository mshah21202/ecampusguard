import 'package:bloc/bloc.dart';
import 'package:country_state_city/models/country.dart';
import 'package:country_state_city/utils/country_utils.dart';
import 'package:ecampusguard/features/user_permit_details/view/widgets/personal_information_details.dart';
import 'package:ecampusguard/features/user_permit_details/view/widgets/vehicle_infromation_details.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

part 'user_permit_details_state.dart';

class UserPermitDetailsCubit extends Cubit<UserPermitDetailsState> {
  UserPermitDetailsCubit() : super(UserPermitDetailsInitial()) {
    loadCountries();
  }

  final Ecampusguardapi _api = GetIt.I.get<Ecampusguardapi>();

  // final TextEditingController phoneNumberController = TextEditingController();
  // final TextEditingController drivingLicenseController =
  //     TextEditingController();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // final TextEditingController plateNumberController = TextEditingController();
  // final TextEditingController selectedCarNationalityController =
  //     TextEditingController();
  // final TextEditingController carMakeController = TextEditingController();
  // final TextEditingController carYearController = TextEditingController();
  // final TextEditingController carModelController = TextEditingController();
  // final TextEditingController carColorController = TextEditingController();
  // final TextEditingController carRegistrationController =
  //     TextEditingController();
  GlobalKey<PersonalInformationDetailsState> personalInfoKey =
      GlobalKey<PersonalInformationDetailsState>();

  GlobalKey<VehicleInformationDetailsState> carInfoKey =
      GlobalKey<VehicleInformationDetailsState>();

  PlatformFile? drivingLicenseFile;
  PlatformFile? carRegistrationFile;
  String? drivingLicenseImgUrl;
  String? carRegistrationImgUrl;

  Country? selectedPhoneCountry;
  Country? selectedCarNationality;

  List<Country> countries = [];

  UserPermitDto? userPermit;

  // void populatePersonalInformation() {
  //   setSelectedPhoneCountry(
  //     countries.firstWhere((element) =>
  //         element.isoCode ==
  //         userPermit!.permitApplication!.phoneNumberCountry!),
  //   );

  //   phoneNumberController.text = userPermit!.permitApplication!.phoneNumber!;
  // }

  // void populateVehicleInformation() {
  //   plateNumberController.text = userPermit!.vehicle!.plateNumber;
  //   setSelectedCarNationality(
  //     countries.firstWhere(
  //         (element) => element.isoCode == userPermit!.vehicle!.nationality),
  //   );
  //   carMakeController.text = userPermit!.vehicle!.make;
  //   carModelController.text = userPermit!.vehicle!.model;
  //   carYearController.text = (userPermit!.vehicle!.year).toString();
  //   carColorController.text = userPermit!.vehicle!.color;
  // }

  void loadCountries() async {
    countries = await getAllCountries();
  }

  void setSelectedPhoneCountry(Country? country) {
    selectedPhoneCountry = country;
    emit(UserPermitDetailsUpdated(selectedPhoneCountry: selectedPhoneCountry));
  }

  // void setSelectedCarNationality(Country? country) {
  //   selectedCarNationality = country;
  //   selectedCarNationalityController.text = country?.name ?? "";
  //   emit(UserPermitDetailsUpdated(
  //       selectedCarNationality: selectedCarNationality));
  // }

  // void selectDrivingLicense(PlatformFile file) {
  //   drivingLicenseFile = file;
  //   drivingLicenseController.text = file.name;
  //   emit(UserPermitDetailsUpdated(
  //     drivingLicenseFile: drivingLicenseFile,
  //   ));
  // }

  // void selectCarRegistration(PlatformFile file) {
  //   carRegistrationFile = file;
  //   carRegistrationController.text = file.name;
  //   emit(UserPermitDetailsUpdated(
  //     carRegistrationFile: carRegistrationFile,
  //   ));
  // }

  void getUserPermit() async {
    emit(UserPermitDetailsLoading());
    try {
      var result = await _api.getUserPermitsApi().userPermitsRelevantGet();

      if (result.data == null) {
        emit(UserPermitDetailsError(snackbarMessage: result.statusMessage));
        return;
      }

      userPermit = result.data;
      emit(UserPermitDetailsLoaded(userPermit: userPermit));
      return;
    } catch (e) {
      emit(const UserPermitDetailsError());
      return;
    }
  }

  Future<void> _uploadLicenseFile() async {
    try {
      var file = _storage.ref().child("licenses/${drivingLicenseFile!.name}");

      await file.putBlob(drivingLicenseFile!.bytes).then((p0) async {
        drivingLicenseImgUrl = await file.getDownloadURL();
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _uploadRegistrationFile() async {
    try {
      var file =
          _storage.ref().child("registrations/${carRegistrationFile!.name}");

      await file.putBlob(carRegistrationFile!.bytes).then((p0) async {
        carRegistrationImgUrl = await file.getDownloadURL();
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> onSubmit() async {
    emit(UserPermitDetailsLoading());
    try {
      if (carRegistrationFile != null) {
        await _uploadRegistrationFile();
      }

      if (drivingLicenseFile != null) {
        await _uploadLicenseFile();
      }

      var result = await _api.getUserPermitsApi().updatePost(
            validateStatus: (status) => true,
            createUpdateRequestDto: CreateUpdateRequestDto(
              phoneNumber:
                  personalInfoKey.currentState!.phoneNumberController.text,
              phoneNumberCountry:
                  personalInfoKey.currentState!.selectedPhoneCountry!.isoCode,
              drivingLicenseImgPath: drivingLicenseImgUrl,
              vehicle: VehicleDto(
                plateNumber:
                    carInfoKey.currentState!.plateNumberController.text,
                nationality:
                    carInfoKey.currentState!.selectedCarNationality!.isoCode,
                make: carInfoKey.currentState!.carMakeController.text,
                model: carInfoKey.currentState!.carModelController.text,
                color: carInfoKey.currentState!.carColorController.text,
                year:
                    int.parse(carInfoKey.currentState!.carYearController.text),
                registrationDocImgPath: carRegistrationImgUrl,
              ),
            ),
          );

      if (result.data == null) {
        emit(UserPermitDetailsError(snackbarMessage: result.statusMessage));
        return;
      }

      emit(
        UserPermitDetailsLoaded(
            snackbarMessage: result.data!.message!.toString()),
      );
      return;
    } catch (e) {
      emit(UserPermitDetailsError(snackbarMessage: e.toString()));
      return;
    }
  }
}
