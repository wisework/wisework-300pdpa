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
              mandatoryFields..sort((a, b) => a.priority.compareTo(b.priority)),
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
                    mandatoryFields
                      ..sort((a, b) => a.priority.compareTo(b.priority)),
                  ),
                ));

        // List<UserConsentModel> newUserConsent = [];

        // for (UserConsentModel userConsent in userConsents) {
        //   bool isTitleFound = false;

        //   if (userConsent.mandatoryFields.toString().contains(event.search)) {
        //     isTitleFound = true;
        //   }

        //   if (isTitleFound) {
        //     newUserConsent.add(userConsent);
        //   }
        // }

        // emit(
        //   GotUserConsents(
        //     newUserConsent
        //       ..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
        //     gotConsentForms,
        //     mandatoryFields..sort((a, b) => a.priority.compareTo(b.priority)),
        //   ),
        // );
      },
    );

    // if (event.search.isEmpty) {
    //   emit(
    //     GotUserConsents(
    //       userConsents..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
    //       gotConsentForms,
    //       mandatoryFields..sort((a, b) => a.priority.compareTo(b.priority)),
    //     ),
    //   );
    // }
    // List<ConsentFormModel> newConsents = [];
    // for (ConsentFormModel consent in gotConsentForms) {
    //   bool isTitleFound = false;
    //   bool isPurposeCategoryFound = false;

    //   if (consent.title.toString().contains(event.search)) {
    //     isTitleFound = true;
    //   }
    //   for (PurposeCategoryModel category in gotPurposeCategories) {
    //     if (category.title.map((e) => e.text).first.contains(event.search)) {
    //       isPurposeCategoryFound = true;
    //     }
    //   }
    //   if (isTitleFound || isPurposeCategoryFound) {
    //     newConsents.add(consent);
    //   }
    // }

    // emit(
    //   GotUserConsents(
    //     userConsents..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
    //     gotConsentForms,
    //     mandatoryFields..sort((a, b) => a.priority.compareTo(b.priority)),
    //   ),
    // );
  }
}
