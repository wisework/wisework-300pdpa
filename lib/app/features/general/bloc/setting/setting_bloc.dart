// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/authentication/company_model.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/etc/user_company_role.dart';
import 'package:pdpa/app/data/repositories/authentication_repository.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const SettingInitial()) {
    on<UpdateCurrentUserEvent>(_updateCurrentUserHandler);
    on<UpdateCurrentUserEvent>(_updateCurrentUserHandler);
  }
  final AuthenticationRepository _authenticationRepository;

  void _updateCurrentUserHandler(
    UpdateCurrentUserEvent event,
    Emitter<SettingState> emit,
  ) {
    emit(SettingUpdated(event.user, event.companies));
  }

  // Future<void> _updateLanguage(
  //   UpdateLanguageSettingsEvent event,
  //   Emitter<SettingState> emit,
  // ) async {
  //   final updated = event.user.copyWith(
  //     defaultLanguage: event.user.defaultLanguage,
  //   );

  //   final result = await _authenticationRepository.updateCurrentUser(
  //     updated,
  //   );
  //   await result.fold(
  //     (failure) {
  //       emit(SignUpCompanyError(failure.errorMessage));
  //       return;
  //     },
  //     (user) async {
  //       List<CompanyModel> companies = [];

  //       for (String id in user.companies) {
  //         final result = await _authenticationRepository.getCompanyById(id);
  //         result.fold(
  //           (failure) => emit(SignUpCompanyError(failure.errorMessage)),
  //           (company) => companies.add(company),
  //         );
  //       }

  //       emit(SignedUpCompany(user, companies));
  //     },
  //   );
  // }
}
