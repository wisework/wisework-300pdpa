// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/data/models/consent_management/user_consent_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
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
    on<GetUserConsentFormDetailEvent>(_getUserConsentFormDetailHandler);
  }

  final ConsentRepository _consentRepository;
  final MasterDataRepository _masterDataRepository;

  Future<void> _getUserConsentFormDetailHandler(
    GetUserConsentFormDetailEvent event,
    Emitter<UserConsentDetailState> emit,
  ) async {
    if (event.userConsentId.isEmpty) {
      emit(const UserConsentDetailError('Required user consent ID'));
      return;
    }
    if (event.companyId.isEmpty) {
      emit(const UserConsentDetailError('Required company ID'));
      return;
    }

    emit(const GettingUserConsentDetail());

    ConsentFormModel gotConsentForm = ConsentFormModel.empty();
    List<MandatoryFieldModel> gotMandatoryFields = [];
    List<PurposeCategoryModel> gotPurposeCategories = [];
    List<PurposeModel> gotPurposes = [];
    List<CustomFieldModel> gotCustomFields = [];
    ConsentThemeModel gotConsentTheme = ConsentThemeModel.initial();
    UserConsentModel gotUserConsent = UserConsentModel.empty();

    final result = await _consentRepository.getUserConsentById(
      event.userConsentId,
      event.companyId,
    );

    await result.fold(
      (failure) {
        emit(UserConsentDetailError(failure.errorMessage));
        return;
      },
      (userConsent) async {
        gotUserConsent = userConsent;

        final result = await _consentRepository.getConsentFormById(
          userConsent.consentFormId,
          event.companyId,
        );

        await result.fold(
          (failure) {
            emit(UserConsentDetailError(failure.errorMessage));
            return;
          },
          (consentForm) async {
            gotConsentForm = consentForm;

            for (String mandatoryFieldId in consentForm.mandatoryFields) {
              final result = await _masterDataRepository.getMandatoryFieldById(
                mandatoryFieldId,
                event.companyId,
              );

              result.fold(
                (failure) => emit(UserConsentDetailError(failure.errorMessage)),
                (mandatoryField) => gotMandatoryFields.add(mandatoryField),
              );
            }

            for (String purposeCategoryId in consentForm.purposeCategories) {
              final result = await _masterDataRepository.getPurposeCategoryById(
                purposeCategoryId,
                event.companyId,
              );

              await result.fold(
                (failure) {
                  emit(UserConsentDetailError(failure.errorMessage));
                  return;
                },
                (purposeCategory) async {
                  gotPurposeCategories.add(purposeCategory);

                  for (String purposeId in purposeCategory.purposes) {
                    final result = await _masterDataRepository.getPurposeById(
                      purposeId,
                      event.companyId,
                    );

                    result.fold(
                      (failure) => emit(
                        UserConsentDetailError(failure.errorMessage),
                      ),
                      (purpose) => gotPurposes.add(purpose),
                    );
                  }
                },
              );
            }

            for (String customFieldId in consentForm.customFields) {
              final result = await _masterDataRepository.getCustomFieldById(
                customFieldId,
                event.companyId,
              );

              result.fold(
                (failure) => emit(UserConsentDetailError(failure.errorMessage)),
                (customField) => gotCustomFields.add(customField),
              );
            }

            final result = await _consentRepository.getConsentThemeById(
              consentForm.consentThemeId,
              event.companyId,
            );

            result.fold(
              (failure) => emit(UserConsentDetailError(failure.errorMessage)),
              (consentThemes) {
                gotConsentTheme = consentThemes;
              },
            );
          },
        );
      },
    );

    emit(
      GotUserConsentDetail(
        gotConsentForm,
        gotMandatoryFields,
        gotPurposeCategories,
        gotPurposes,
        gotCustomFields,
        gotConsentTheme,
        gotUserConsent,
      ),
    );
  }
}
