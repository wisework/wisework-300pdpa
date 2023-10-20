// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';


part 'current_edit_consent_form_state.dart';

class CurrentEditConsentFormCubit extends Cubit<CurrentEditConsentFormState> {
  CurrentEditConsentFormCubit()
      : super(CurrentEditConsentFormState(
          consentForm: ConsentFormModel.empty(),
          purposeCategory: const [],
          purposeCategories: const [],
        ));

  Future<void> initialSettings(
    ConsentFormModel consentForm,
    List<PurposeCategoryModel> purposeCategory,
  ) async {
    emit(
      state.copyWith(
        consentForm: consentForm,
        purposeCategory: purposeCategory,
      ),
    );
  }

  void setConsentForm(ConsentFormModel consentForm) {
    emit(state.copyWith(consentForm: consentForm));
  }

  void setPurposeCategory(List<String> purposeCategoryList,
      List<PurposeCategoryModel> purposeCategories) {
    emit(state.copyWith(
      consentForm: state.consentForm.copyWith(
        purposeCategories: purposeCategoryList,
      ),
      purposeCategory: purposeCategories,
    ));
  }
}
