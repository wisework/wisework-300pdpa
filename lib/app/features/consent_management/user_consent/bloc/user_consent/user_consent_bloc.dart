// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/user_consent_model.dart';
import 'package:pdpa/app/data/repositories/consent_repository.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

part 'user_consent_event.dart';
part 'user_consent_state.dart';

class UserConsentBloc extends Bloc<UserConsentEvent, UserConsentState> {
  UserConsentBloc({
    required ConsentRepository consentRepository,
    required MasterDataRepository masterDataRepository,
  })  : _consentRepository = consentRepository,
        _masterDataRepository = masterDataRepository,
        super(const UserConsentInitial()) {
    on<GetUserConsentsEvent>(_getUserConsentsHandler);
  }
  final ConsentRepository _consentRepository;
  final MasterDataRepository _masterDataRepository;

  Future<void> _getUserConsentsHandler(
    GetUserConsentsEvent event,
    Emitter<UserConsentState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const UserConsentError('Required company ID'));
      return;
    }

    emit(const GettingUserConsents());

    final result = await _consentRepository.getUserConsents(event.companyId);

    result.fold(
      (failure) => emit(UserConsentError(failure.errorMessage)),
      (customfields) => emit(GotUserConsents(
        customfields..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
      )),
    );
  }
}
