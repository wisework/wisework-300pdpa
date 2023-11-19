part of 'form_data_sub_ject_right_bloc.dart';

abstract class FormDataSubJectRightEvent extends Equatable {
  const FormDataSubJectRightEvent();

  @override
  List<Object> get props => [];
}

class GetFormDataSubJectRightEvent extends FormDataSubJectRightEvent {
  const GetFormDataSubJectRightEvent({required this.companyId});

  final String companyId;

  @override
  List<Object> get props => [companyId];
}
