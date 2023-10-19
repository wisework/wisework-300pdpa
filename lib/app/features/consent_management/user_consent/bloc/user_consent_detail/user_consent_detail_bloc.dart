import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/data/models/consent_management/user_consent_model.dart';
import 'package:pdpa/app/data/models/etc/user_input_text.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/data/repositories/consent_repository.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'user_consent_detail_event.dart';
part 'user_consent_detail_state.dart';

class UserConsentDetailBloc
    extends Bloc<UserConsentDetailEvent, UserConsentDetailState> {
  UserConsentDetailBloc({
    required ConsentRepository consentRepository,
    required MasterDataRepository masterDataRepository,
  })  : _consentRepository = consentRepository,
        _masterDataRepository = masterDataRepository,
        super(const UserConsentDetailInitial()) {
    on<GetUserConsentFormEvent>(_getUserConsentHandler);
  }

  final ConsentRepository _consentRepository;
  final MasterDataRepository _masterDataRepository;

  Future<void> _getUserConsentHandler(
    GetUserConsentFormEvent event,
    Emitter<UserConsentDetailState> emit,
  ) async {
    if (event.consentFormId.isEmpty) {
      emit(const UserConsentDetailError('Required consent ID'));
      return;
    }
    if (event.companyId.isEmpty) {
      emit(const UserConsentDetailError('Required company ID'));
      return;
    }

    emit(const GettingUserConsentDetail());

    final result = await _consentRepository.getUserConsentById(
      event.consentFormId,
      event.companyId,
    );

    UserConsentModel gotUserConsent = UserConsentModel.empty();
    List<CustomFieldModel> gotCustomFields = [];
    List<PurposeCategoryModel> gotPurposeCategories = [];
    List<PurposeModel> gotPurposes = [];

    await result.fold(
      (failure) {
        emit(UserConsentDetailError(failure.errorMessage));
        return;
      },
      (userConsent) async {
        gotUserConsent = userConsent;

        // for (String customFieldId in userConsent.customFields ) {
        //   final result = await _masterDataRepository.getCustomFieldById(
        //     customFieldId,
        //     event.companyId,
        //   );

        //   result.fold(
        //     (failure) => emit(UserConsentDetailError(failure.errorMessage)),
        //     (customField) => gotCustomFields.add(customField),
        //   );
        // }

    
      },
    );

    emit(
      GotUserConsentDetail(
        gotUserConsent,
        gotCustomFields,
        gotPurposeCategories..sort((a, b) => b.priority.compareTo(a.priority)),
        gotPurposes,
      
      ),
    );
  }
}
