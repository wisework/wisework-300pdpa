part of 'form_data_sub_ject_right_bloc.dart';

abstract class FormDataSubJectRightState extends Equatable {
  const FormDataSubJectRightState();

  @override
  List<Object> get props => [];
}

class FormDataSubJectRightInitial extends FormDataSubJectRightState {
  const FormDataSubJectRightInitial();

  @override
  List<Object> get props => [];
}

class FormDataSubJectRightError extends FormDataSubJectRightState {
  const FormDataSubJectRightError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GettingFormDataSubJectRight extends FormDataSubJectRightState {
  const GettingFormDataSubJectRight();

  @override
  List<Object> get props => [];
}

class GotTypeofRequest extends FormDataSubJectRightState {
  const GotTypeofRequest(this.requestTypes, this.reasonTypes);

  final List<RequestTypeModel> requestTypes;
  final List<ReasonTypeModel> reasonTypes;

  @override
  List<Object> get props => [
        requestTypes,
        reasonTypes,
      ];
}
