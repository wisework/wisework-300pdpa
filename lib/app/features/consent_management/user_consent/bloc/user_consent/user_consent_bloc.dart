// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/user_consent_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
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

    await result.fold(
      (failure) {
        emit(UserConsentError(failure.errorMessage));
        return;
      },
      (userConsent) async {
        final result = await _masterDataRepository.getMandatoryFields(
          event.companyId,
        );

        result.fold(
          (failure) => emit(UserConsentError(failure.errorMessage)),
          (mandatoryFields) => emit(
            GotUserConsents(
              userConsent
                ..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
              mandatoryFields..sort((a, b) => a.priority.compareTo(b.priority)),
            ),
          ),
        );
      },
    );
  }
}
