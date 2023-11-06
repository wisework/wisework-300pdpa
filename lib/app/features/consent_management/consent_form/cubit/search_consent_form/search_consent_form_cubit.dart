// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';

part 'search_consent_form_state.dart';

class SearchConsentFormCubit extends Cubit<SearchConsentFormState> {
  SearchConsentFormCubit()
      : super(const SearchConsentFormState(
          initialConsentForms: [],
          consentForms: [],
        ));

  void initialConsentForm(List<ConsentFormModel> consentForms) {
    emit(
      state.copyWith(
        initialConsentForms: consentForms,
        consentForms: consentForms,
      ),
    );
  }

  void searchConsentForm(String search, String language) {
    if (search.isEmpty) {
      emit(state.copyWith(consentForms: state.initialConsentForms));
      return;
    }

    List<ConsentFormModel> searchResult = [];

    searchResult = state.initialConsentForms.where((consentForm) {
      if (consentForm.title.isNotEmpty) {
        final title = consentForm.title
            .firstWhere(
              (item) => item.language == language,
              orElse: () => const LocalizedModel.empty(),
            )
            .text;
        final description = consentForm.description
            .firstWhere(
              (item) => item.language == language,
              orElse: () => const LocalizedModel.empty(),
            )
            .text;

        if (title.contains(search) || description.contains(search)) return true;
      }

      return false;
    }).toList();

    final searchAtPurposeCategory =
        state.initialConsentForms.where((consentForm) {
      for (PurposeCategoryModel category in consentForm.purposeCategories) {
        final title = category.title
            .firstWhere(
              (item) => item.language == language,
              orElse: () => const LocalizedModel.empty(),
            )
            .text;
        final description = category.description
            .firstWhere(
              (item) => item.language == language,
              orElse: () => const LocalizedModel.empty(),
            )
            .text;

        if (title.contains(search) || description.contains(search)) return true;
      }

      return false;
    }).toList();

    final currentResultIds =
        searchResult.map((consentForm) => consentForm.id).toList();
    for (ConsentFormModel consentForm in searchAtPurposeCategory) {
      if (!currentResultIds.contains(consentForm.id)) {
        searchResult.add(consentForm);
      }
    }

    emit(
      state.copyWith(
        consentForms: searchResult
          ..sort(((a, b) => b.updatedDate.compareTo(a.updatedDate))),
      ),
    );
  }
}
