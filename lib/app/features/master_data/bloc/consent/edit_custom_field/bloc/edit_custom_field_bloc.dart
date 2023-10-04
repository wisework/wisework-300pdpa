// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'edit_custom_field_event.dart';
part 'edit_custom_field_state.dart';

class EditCustomFieldBloc
    extends Bloc<EditCustomFieldEvent, EditCustomFieldState> {
  EditCustomFieldBloc({
    required MasterDataRepository masterDataRepository,
  })  : _masterDataRepository = masterDataRepository,
        super(
          const EditCustomFieldInitial(),
        ) {
    on<GetCurrentCustomFieldEvent>(_getCurrentCustomFieldHandler);
    on<CreateCurrentCustomFieldEvent>(_createCurrentCustomFieldHandler);
    on<UpdateCurrentCustomFieldEvent>(_updateCurrentCustomFieldHandler);
    on<DeleteCurrentCustomFieldEvent>(_deleteCurrentCustomFieldHandler);
  }

  final MasterDataRepository _masterDataRepository;

  Future<void> _getCurrentCustomFieldHandler(
    GetCurrentCustomFieldEvent event,
    Emitter<EditCustomFieldState> emit,
  ) async {
    if (event.customfieldId.isEmpty) {
      emit(GotCurrentCustomField(CustomFieldModel.empty()));
      return;
    }
    if (event.companyId.isEmpty) {
      emit(const EditCustomFieldError('Required company ID'));
      return;
    }

    emit(const GetingCurrentCustomField());

    final result = await _masterDataRepository.getCustomFieldById(
      event.customfieldId,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditCustomFieldError(failure.errorMessage)),
      (customfield) => emit(GotCurrentCustomField(customfield)),
    );
  }

  Future<void> _createCurrentCustomFieldHandler(
    CreateCurrentCustomFieldEvent event,
    Emitter<EditCustomFieldState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditCustomFieldError('Required company ID'));
      return;
    }

    emit(const CreatingCurrentCustomField());

    final result = await _masterDataRepository.createCustomField(
      event.customfield,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditCustomFieldError(failure.errorMessage)),
      (customfield) => emit(CreatedCurrentCustomField(customfield)),
    );
  }

  Future<void> _updateCurrentCustomFieldHandler(
    UpdateCurrentCustomFieldEvent event,
    Emitter<EditCustomFieldState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditCustomFieldError('Required company ID'));
      return;
    }

    emit(const UpdatingCurrentCustomField());

    final result = await _masterDataRepository.updateCustomField(
      event.customfield,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditCustomFieldError(failure.errorMessage)),
      (_) => emit(UpdatedCurrentCustomField(event.customfield)),
    );
  }

  Future<void> _deleteCurrentCustomFieldHandler(
    DeleteCurrentCustomFieldEvent event,
    Emitter<EditCustomFieldState> emit,
  ) async {
    if (event.customfieldId.isEmpty) return;

    if (event.companyId.isEmpty) {
      emit(const EditCustomFieldError('Required company ID'));
      return;
    }

    emit(const DeletingCurrentCustomField());

    final result = await _masterDataRepository.deleteCustomField(
      event.customfieldId,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditCustomFieldError(failure.errorMessage)),
      (_) => emit(DeletedCurrentCustomField(event.customfieldId)),
    );
  }
}
