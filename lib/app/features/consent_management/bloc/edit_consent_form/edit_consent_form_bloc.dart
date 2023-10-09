// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/repositories/consent_repository.dart';

part 'edit_consent_form_event.dart';
part 'edit_consent_form_state.dart';

class EditConsentFormBloc
    extends Bloc<EditConsentFormEvent, EditConsentFormState> {
  EditConsentFormBloc({
    required ConsentRepository consentRepository,
  })  : _consentRepository = consentRepository,
        super(const EditConsentFormInitial()) {
    on<GetCurrentConsentFormEvent>(_getCurrentConsentFormHandler);
    on<CreateCurrentConsentFormEvent>(_createCurrentConsentFormHandler);
    on<UpdateCurrentConsentFormEvent>(_updateCurrentConsentFormHandler);
  }

  final ConsentRepository _consentRepository;

  Future<void> _getCurrentConsentFormHandler(
    GetCurrentConsentFormEvent event,
    Emitter<EditConsentFormState> emit,
  ) async {
    if (event.consentFormId.isEmpty) {
      emit(GotCurrentConsentForm(ConsentFormModel.empty()));
      return;
    }
    if (event.companyId.isEmpty) {
      emit(const EditConsentFormError('Required company ID'));
      return;
    }

    emit(const GetingCurrentConsentForm());

    final result = await _consentRepository.getConsentFormById(
      event.consentFormId,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditConsentFormError(failure.errorMessage)),
      (purpose) => emit(GotCurrentConsentForm(purpose)),
    );
  }

  Future<void> _createCurrentConsentFormHandler(
    CreateCurrentConsentFormEvent event,
    Emitter<EditConsentFormState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditConsentFormError('Required company ID'));
      return;
    }

    emit(const CreatingCurrentConsentForm());

    final result = await _consentRepository.createConsentForm(
      event.consentForm,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditConsentFormError(failure.errorMessage)),
      (purpose) => emit(CreatedCurrentConsentForm(purpose)),
    );
  }

  Future<void> _updateCurrentConsentFormHandler(
    UpdateCurrentConsentFormEvent event,
    Emitter<EditConsentFormState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditConsentFormError('Required company ID'));
      return;
    }

    emit(const UpdatingCurrentConsentForm());

    final result = await _consentRepository.updateConsentForm(
      event.consentForm,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditConsentFormError(failure.errorMessage)),
      (_) => emit(UpdatedCurrentConsentForm(event.consentForm)),
    );
  }

}
