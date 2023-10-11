// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/data/repositories/consent_repository.dart';

part 'edit_consent_theme_event.dart';
part 'edit_consent_theme_state.dart';

class EditConsentThemeBloc
    extends Bloc<EditConsentThemeEvent, EditConsentThemeState> {
  EditConsentThemeBloc({
    required ConsentRepository consentRepository,
  })  : _consentRepository = consentRepository,
        super(const EditConsentThemeInitial()) {
    on<GetCurrentConsentThemeEvent>(_getCurrentConsentThemeHandler);
    on<CreateCurrentConsentThemeEvent>(_createCurrentConsentThemeHandler);
    on<UpdateCurrentConsentThemeEvent>(_updateCurrentConsentThemeHandler);
    on<DeleteCurrentConsentThemeEvent>(_deleteCurrentConsentThemeHandler);
  }

  final ConsentRepository _consentRepository;

  Future<void> _getCurrentConsentThemeHandler(
    GetCurrentConsentThemeEvent event,
    Emitter<EditConsentThemeState> emit,
  ) async {
    if (event.consentThemeId.isEmpty) {
      emit(
        GotCurrentConsentTheme(
          ConsentThemeModel.initial().copyWith(title: 'New theme'),
        ),
      );
      return;
    }
    if (event.companyId.isEmpty) {
      emit(const EditConsentThemeError('Required company ID'));
      return;
    }

    emit(const GettingCurrentConsentTheme());

    final result = await _consentRepository.getConsentThemeById(
      event.consentThemeId,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditConsentThemeError(failure.errorMessage)),
      (purpose) => emit(GotCurrentConsentTheme(purpose)),
    );
  }

  Future<void> _createCurrentConsentThemeHandler(
    CreateCurrentConsentThemeEvent event,
    Emitter<EditConsentThemeState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditConsentThemeError('Required company ID'));
      return;
    }

    emit(const CreatingCurrentConsentTheme());

    final result = await _consentRepository.createConsentTheme(
      event.consentTheme,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditConsentThemeError(failure.errorMessage)),
      (purpose) => emit(CreatedCurrentConsentTheme(purpose)),
    );
  }

  Future<void> _updateCurrentConsentThemeHandler(
    UpdateCurrentConsentThemeEvent event,
    Emitter<EditConsentThemeState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditConsentThemeError('Required company ID'));
      return;
    }

    emit(const UpdatingCurrentConsentTheme());

    final result = await _consentRepository.updateConsentTheme(
      event.consentTheme,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditConsentThemeError(failure.errorMessage)),
      (_) => emit(UpdatedCurrentConsentTheme(event.consentTheme)),
    );
  }

  Future<void> _deleteCurrentConsentThemeHandler(
    DeleteCurrentConsentThemeEvent event,
    Emitter<EditConsentThemeState> emit,
  ) async {
    if (event.consentThemeId.isEmpty) return;

    if (event.companyId.isEmpty) {
      emit(const EditConsentThemeError('Required company ID'));
      return;
    }

    emit(const DeletingCurrentConsentTheme());

    final result = await _consentRepository.deleteConsentTheme(
      event.consentThemeId,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditConsentThemeError(failure.errorMessage)),
      (_) => emit(DeletedCurrentConsentTheme(event.consentThemeId)),
    );
  }
}
