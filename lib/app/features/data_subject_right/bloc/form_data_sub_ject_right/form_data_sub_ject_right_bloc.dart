// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/data/presets/reason_types_preset.dart';
import 'package:pdpa/app/data/presets/request_types_preset.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'form_data_sub_ject_right_event.dart';
part 'form_data_sub_ject_right_state.dart';

class FormDataSubJectRightBloc
    extends Bloc<FormDataSubJectRightEvent, FormDataSubJectRightState> {
  FormDataSubJectRightBloc({
    required MasterDataRepository masterDataRepository,
  })  : _masterDataRepository = masterDataRepository,
        super(const FormDataSubJectRightInitial()) {
    on<GetFormDataSubJectRightEvent>(_getFormDataSubJectRightHandler);
  }

  final MasterDataRepository _masterDataRepository;

  Future<void> _getFormDataSubJectRightHandler(
    GetFormDataSubJectRightEvent event,
    Emitter<FormDataSubJectRightState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const FormDataSubJectRightError('Required company ID'));
      return;
    }

    emit(const GettingFormDataSubJectRight());

    List<RequestTypeModel> gotRequestTypes =
        requestTypesPreset.map((reject) => reject).toList();
    final requestTypeResult = await _masterDataRepository.getRequestTypes(
      event.companyId,
    );
    requestTypeResult.fold(
      (failure) => emit(FormDataSubJectRightError(failure.errorMessage)),
      (requestTypes) {
        requestTypes.sort((a, b) => a.updatedDate.compareTo(b.updatedDate));

        final ids = gotRequestTypes.map((type) => type.id).toList();
        for (RequestTypeModel request in requestTypes) {
          if (!ids.contains(request.id)) {
            gotRequestTypes.add(request);
          }
        }
      },
    );

    List<ReasonTypeModel> gotReasonTypes =
        reasonTypesPreset.map((reject) => reject).toList();
    final reasonTypeResult = await _masterDataRepository.getReasonTypes(
      event.companyId,
    );
    reasonTypeResult.fold(
      (failure) => emit(FormDataSubJectRightError(failure.errorMessage)),
      (reasonTypes) {
        reasonTypes.sort((a, b) => a.updatedDate.compareTo(b.updatedDate));

        final ids = gotRequestTypes.map((type) => type.id).toList();
        for (ReasonTypeModel reason in reasonTypes) {
          if (!ids.contains(reason.id)) {
            gotReasonTypes.add(reason);
          }
        }
      },
    );

    emit(GotTypeofRequest(
      gotRequestTypes,
      gotReasonTypes,
    ));
  }
}
