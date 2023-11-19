part of 'request_reason_tp_cubit.dart';

class RequestReasonTpState extends Equatable {
  const RequestReasonTpState({
    required this.reasons,
    required this.reasonList,
    required this.request,
  });

  final List<String> reasons;
  final List<ReasonTypeModel> reasonList;
  final String request;

  RequestReasonTpState copyWith({
    List<String>? reasons,
    List<ReasonTypeModel>? reasonList,
    String? request,
  }) {
    return RequestReasonTpState(
      reasons: reasons ?? this.reasons,
      reasonList: reasonList ?? this.reasonList,
      request: request ?? this.request,
    );
  }

  @override
  List<Object> get props => [reasons, reasonList, request];
}
