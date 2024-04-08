import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'permit_applications_state.dart';

class PermitApplicationsCubit extends Cubit<PermitApplicationsState> {
  PermitApplicationsCubit() : super(PermitApplicationsInitial());
}
