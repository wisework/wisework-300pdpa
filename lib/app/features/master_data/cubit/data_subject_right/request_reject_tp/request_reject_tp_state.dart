part of 'request_reject_tp_cubit.dart';

class RequestRejectTpState extends Equatable {
  const RequestRejectTpState({
    required this.rejects,
    required this.rejectList,
    required this.request,
  });

  final List<String> rejects;
  final List<RejectTypeModel> rejectList;
  final String request;

  RequestRejectTpState copyWith({
    List<String>? rejects,
    List<RejectTypeModel>? rejectList,
    String? request,
  }) {
    return RequestRejectTpState(
      rejects: rejects ?? this.rejects,
      rejectList: rejectList ?? this.rejectList,
      request: request ?? this.request,
    );
  }

  @override
  List<Object> get props => [rejects, rejectList, request];
}
