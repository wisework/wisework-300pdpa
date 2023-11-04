import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/user_consent_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';

part 'search_user_consent_state.dart';

class SearchUserConsentCubit extends Cubit<SearchUserConsentState> {
  SearchUserConsentCubit()
      : super(const SearchUserConsentState(
          initialUserConsents: [],
          userConsents: [],
        ));

  void initialUserConsent(List<UserConsentModel> userConsents) {
    emit(
      state.copyWith(
        initialUserConsents: userConsents,
        userConsents: userConsents,
      ),
    );
  }

  void searchUserConsent(String search, String language) {
    if (search.isEmpty) {
      emit(state.copyWith(userConsents: state.initialUserConsents));
      return;
    }

    List<UserConsentModel> searchResult = [];
//!
    // searchResult = state.initialUserConsents.where((userConsent) {
    //   if (userConsent.title.isNotEmpty) {
    //     final title = userConsent.title
    //         .firstWhere(
    //           (item) => item.language == language,
    //           orElse: () => const LocalizedModel.empty(),
    //         )
    //         .text;
    //     final description = userConsent.description
    //         .firstWhere(
    //           (item) => item.language == language,
    //           orElse: () => const LocalizedModel.empty(),
    //         )
    //         .text;

    //     if (title.contains(search) || description.contains(search)) return true;
    //   }

    //   return false;
    // }).toList();

    // final searchAtPurposeCategory =
    //     state.initialUserConsents.where((userConsent) {
    //   for (PurposeCategoryModel category in userConsent.purposeCategories) {
    //     final title = category.title
    //         .firstWhere(
    //           (item) => item.language == language,
    //           orElse: () => const LocalizedModel.empty(),
    //         )
    //         .text;
    //     final description = category.description
    //         .firstWhere(
    //           (item) => item.language == language,
    //           orElse: () => const LocalizedModel.empty(),
    //         )
    //         .text;

    //     if (title.contains(search) || description.contains(search)) return true;
    //   }

    //   return false;
    // }).toList();

    final currentResultIds =
        searchResult.map((userConsent) => userConsent.id).toList();
    // for (UserConsentModel userConsent in searchAtPurposeCategory) {
    //   if (!currentResultIds.contains(userConsent.id)) {
    //     searchResult.add(userConsent);
    //   }
    // }

    emit(
      state.copyWith(
        userConsents: searchResult
          ..sort(((a, b) => b.updatedDate.compareTo(a.updatedDate))),
      ),
    );
  }
}
