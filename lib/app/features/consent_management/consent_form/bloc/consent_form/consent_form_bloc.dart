// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/data/repositories/consent_repository.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

part 'consent_form_event.dart';
part 'consent_form_state.dart';

class ConsentFormBloc extends Bloc<ConsentFormEvent, ConsentFormState> {
  ConsentFormBloc({
    required ConsentRepository consentRepository,
    required MasterDataRepository masterDataRepository,
  })  : _consentRepository = consentRepository,
        _masterDataRepository = masterDataRepository,
        super(const ConsentFormInitial()) {
    on<GetConsentFormsEvent>(_getConstFormsHandler);
    on<UpdateConsentFormEvent>(_updateConsentFormsEvent);
  }

  final ConsentRepository _consentRepository;
  final MasterDataRepository _masterDataRepository;

  Future<void> _getConstFormsHandler(
    GetConsentFormsEvent event,
    Emitter<ConsentFormState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const ConsentFormError('Required company ID'));
      return;
    }

    emit(const GettingConsentForms());

    List<ConsentFormModel> gotConsentForms = [];
    List<PurposeModel> gotPurposes = [];
    List<PurposeCategoryModel> gotPurposeCategories = [];

    final purposeResult = await _masterDataRepository.getPurposes(
      event.companyId,
    );
    purposeResult.fold(
      (failure) {
        emit(ConsentFormError(failure.errorMessage));
        return;
      },
      (purposes) {
        gotPurposes = purposes;
      },
    );

    final purposeCategoryResult =
        await _masterDataRepository.getPurposeCategories(
      event.companyId,
    );
    purposeCategoryResult.fold(
      (failure) {
        emit(ConsentFormError(failure.errorMessage));
        return;
      },
      (purposeCategories) {
        for (PurposeCategoryModel category in purposeCategories) {
          final purposeIds =
              category.purposes.map((purpose) => purpose.id).toList();
          final purposes = gotPurposes
              .where((purpose) => purposeIds.contains(purpose.id))
              .toList();

          gotPurposeCategories.add(category.copyWith(purposes: purposes));
        }
      },
    );

    final consentFormsResult = await _consentRepository.getConsentForms(
      event.companyId,
    );
    consentFormsResult.fold(
      (failure) {
        emit(ConsentFormError(failure.errorMessage));
        return;
      },
      (consentForms) {
        for (ConsentFormModel consentForm in consentForms) {
          gotConsentForms.add(
            consentForm.copyWith(
              purposeCategories: consentForm.purposeCategories.map((category) {
                final purposeCategory = gotPurposeCategories.firstWhere(
                  (pc) => pc.id == category.id,
                  orElse: () => category,
                );

                return purposeCategory.copyWith(priority: category.priority);
              }).toList(),
            ),
          );
        }
      },
    );

    emit(
      GotConsentForms(
        gotConsentForms..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
      ),
    );
  }

  Future<void> _updateConsentFormsEvent(
    UpdateConsentFormEvent event,
    Emitter<ConsentFormState> emit,
  ) async {
    if (state is GotConsentForms) {
      final consentForms = (state as GotConsentForms).consentForms;

      List<ConsentFormModel> updated = [];

      switch (event.updateType) {
        case UpdateType.created:
          break;
        case UpdateType.updated:
          for (ConsentFormModel consentForm in consentForms) {
            if (consentForm.id == event.consentForm.id) {
              updated.add(event.consentForm);
            } else {
              updated.add(consentForm);
            }
          }
          break;
        case UpdateType.deleted:
          break;
      }

      emit(
        GotConsentForms(
          updated..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
        ),
      );
    }
  }
}
