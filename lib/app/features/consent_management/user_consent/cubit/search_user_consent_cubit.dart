// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/user_consent_model.dart';
import 'package:pdpa/app/data/models/etc/user_input_text.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';

part 'search_user_consent_state.dart';

class SearchUserConsentCubit extends Cubit<SearchUserConsentState> {
  SearchUserConsentCubit()
      : super(const SearchUserConsentState(
          initialUserConsents: [],
          userConsents: [],
          initialConsentForms: [],
          consentForms: [],
          initialMandatoryFields: [],
          mandatoryFields: [],
        ));

  void initialUserConsent(
    List<UserConsentModel> userConsents,
    List<ConsentFormModel> consentForms,
    List<MandatoryFieldModel> mandatoryFields,
  ) {
    emit(
      state.copyWith(
        initialUserConsents: userConsents,
        userConsents: userConsents,
        initialConsentForms: consentForms,
        consentForms: consentForms,
        initialMandatoryFields: mandatoryFields,
        mandatoryFields: mandatoryFields,
      ),
    );
  }

  void searchUserConsent(String search, String language) {
    if (search.isEmpty) {
      emit(state.copyWith(userConsents: state.initialUserConsents));
      return;
    }

    final firstMandatory = state.mandatoryFields.firstWhere(
        (mandatory) => mandatory.priority == 1,
        orElse: () => state.mandatoryFields.first);

    List<UserConsentModel> searchResult = [];

    searchResult = state.userConsents.where((userConsent) {
      if (userConsent.mandatoryFields.isNotEmpty) {
        final firstMandatoryText = userConsent.mandatoryFields
            .firstWhere(
              (mandatoryField) => mandatoryField.id == firstMandatory.id,
              orElse: () => const UserInputText.empty(),
            )
            .text;

        if (firstMandatoryText.contains(search)) return true;
      }

      return false;
    }).toList();

    final searchAtConsentForm = state.userConsents.where((userConsent) {
      for (ConsentFormModel consent in state.consentForms) {
        if (consent.id == userConsent.consentFormId) {
          final title = consent.title
              .firstWhere(
                (item) => item.language == language,
                orElse: () => const LocalizedModel.empty(),
              )
              .text;

          if (title.contains(search)) return true;
        }
      }

      return false;
    }).toList();

    final currentResultIds =
        searchResult.map((userConsent) => userConsent.id).toList();
    for (UserConsentModel userConsent in searchAtConsentForm) {
      if (!currentResultIds.contains(userConsent.id)) {
        searchResult.add(userConsent);
      }
    }
    emit(
      state.copyWith(
        userConsents: searchResult
          ..sort(((a, b) => b.updatedDate.compareTo(a.updatedDate))),
      ),
    );
  }
}
