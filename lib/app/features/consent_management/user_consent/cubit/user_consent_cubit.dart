// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_consent_cubit_state.dart';

class UserConsentCubit extends Cubit<UserConsentCubitState> {
  UserConsentCubit() : super(UserConsentInitial());
}
