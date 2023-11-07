// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
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
    on<SearchUserConsentSearchChanged>(_getUserConsentsSearching);
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
      (userConsents) async {
        List<ConsentFormModel> gotConsentForms = [];
        for (UserConsentModel userConsent in userConsents) {
          final result = await _consentRepository.getConsentFormById(
            userConsent.consentFormId,
            event.companyId,
          );

          result.fold(
            (failure) => emit(UserConsentError(failure.errorMessage)),
            (consentForm) => gotConsentForms.add(consentForm),
          );
        }

        final result = await _masterDataRepository.getMandatoryFields(
          event.companyId,
        );

        result.fold(
          (failure) => emit(UserConsentError(failure.errorMessage)),
          (mandatoryFields) => emit(
            GotUserConsents(
              userConsents
                ..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
              gotConsentForms,
              mandatoryFields..sort((a, b) => b.priority.compareTo(a.priority)),
            ),
          ),
        );
      },
    );
  }

  Future<void> _getUserConsentsSearching(
    SearchUserConsentSearchChanged event,
    Emitter<UserConsentState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const UserConsentError('Required company ID'));
      return;
    }

    emit(const GettingUserConsents());

    List<UserConsentModel> gotUserConsents = [];
    List<ConsentFormModel> gotConsentForms = [];
    List<MandatoryFieldModel> gotMadatoryFields = [];

    // SET UserConsents
    final userConsentResult =
        await _consentRepository.getUserConsents(event.companyId);

    await userConsentResult.fold(
      (failure) {
        emit(UserConsentError(failure.errorMessage));
        return;
      },
      (userConsents) async {
        gotUserConsents = userConsents;
      },
    );

    //SET ConsentForms
    for (UserConsentModel userConsent in gotUserConsents) {
      final consentFormResult = await _consentRepository.getConsentFormById(
        userConsent.consentFormId,
        event.companyId,
      );

      consentFormResult.fold(
        (failure) => emit(UserConsentError(failure.errorMessage)),
        (consentForm) => gotConsentForms.add(consentForm),
      );
    }

    //SET MadatoryFields

    final madatoryResult = await _masterDataRepository.getMandatoryFields(
      event.companyId,
    );

    madatoryResult.fold(
      (failure) => emit(UserConsentError(failure.errorMessage)),
      (mandatoryFields) async {
        gotMadatoryFields = mandatoryFields;
      },
    );

    if (event.search.isEmpty) {
      emit(
        GotUserConsents(
          gotUserConsents
            ..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
          gotConsentForms,
          gotMadatoryFields..sort((a, b) => a.priority.compareTo(b.priority)),
        ),
      );
    }

    List<UserConsentModel> newUserConsents = [];
    for (UserConsentModel userConsent in gotUserConsents) {
      bool isTitleFound = false;

      if (userConsent.toString().contains(event.search)) {
        isTitleFound = true;
      }

      if (isTitleFound) {
        newUserConsents.add(userConsent);
      }
    }

    List<ConsentFormModel> newConsents = [];
    for (ConsentFormModel consent in gotConsentForms) {
      bool isTitleFound = false;

      if (consent.title.toString().contains(event.search)) {
        isTitleFound = true;
      }

      if (isTitleFound) {
        newConsents.add(consent);
      }
    }

    List<MandatoryFieldModel> newMadatory = [];
    for (MandatoryFieldModel mandatory in gotMadatoryFields) {
      bool isTitleFound = false;

      if (mandatory.toString().contains(event.search)) {
        isTitleFound = true;
      }

      if (isTitleFound) {
        newMadatory.add(mandatory);
      }
    }

    emit(
      GotUserConsents(
        newUserConsents..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
        newConsents,
        newMadatory..sort((a, b) => a.priority.compareTo(b.priority)),
      ),
    );
  }
}
