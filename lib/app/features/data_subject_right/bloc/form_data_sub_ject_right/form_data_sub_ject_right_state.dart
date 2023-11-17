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

class GotRequestReson extends FormDataSubJectRightState {
  const GotRequestReson(this.requestResons);

  final List<RequestReasonTemplateModel> requestResons;

  @override
  List<Object> get props => [requestResons];
}
