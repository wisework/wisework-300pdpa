// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

part 'custom_field_event.dart';
part 'custom_field_state.dart';

class CustomFieldBloc extends Bloc<CustomFieldEvent, CustomFieldState> {
  CustomFieldBloc({
    required MasterDataRepository masterDataRepository,
  })  : _masterDataRepository = masterDataRepository,
        super(const CustomFieldInitial()) {
    on<GetCustomFieldEvent>(_getCustomFieldsHandler);
    on<UpdateCustomFieldEvent>(_updateCustomFieldsHandler);
  }
  final MasterDataRepository _masterDataRepository;

  Future<void> _getCustomFieldsHandler(
    GetCustomFieldEvent event,
    Emitter<CustomFieldState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const CustomfieldError('Required company ID'));
      return;
    }

    emit(const GettingCustomField());

    final result = await _masterDataRepository.getCustomFields(event.companyId);

    result.fold(
      (failure) => emit(CustomfieldError(failure.errorMessage)),
      (customfields) => emit(GotCustomFields(
        customfields..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
      )),
    );
  }

  Future<void> _updateCustomFieldsHandler(
    UpdateCustomFieldEvent event,
    Emitter<CustomFieldState> emit,
  ) async {
    if (state is GotCustomFields) {
      final customfields = (state as GotCustomFields).customfields;

      List<CustomFieldModel> updated = [];

      switch (event.updateType) {
        case UpdateType.created:
          updated = customfields.map((customfield) => customfield).toList()
            ..add(event.customfield);
          break;
        case UpdateType.updated:
          for (CustomFieldModel customfield in customfields) {
            if (customfield.id == event.customfield.id) {
              updated.add(event.customfield);
            } else {
              updated.add(customfield);
            }
          }
          break;
        case UpdateType.deleted:
          updated = customfields
              .where((customfield) => customfield.id != event.customfield.id)
              .toList();
          break;
      }

      emit(
        GotCustomFields(
          updated..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
        ),
      );
    }
  }
}
