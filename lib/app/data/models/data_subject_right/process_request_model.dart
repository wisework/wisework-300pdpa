import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/etc/user_input_text.dart';

import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class ProcessRequestModel extends Equatable {
  const ProcessRequestModel({
    required this.id,
    required this.personalData,
    required this.foundSource,
    required this.requestType,
    required this.requestAction,
    required this.reasonTypes,
    required this.considerRequestStatus,
    required this.rejectTypes,
    required this.rejectConsiderReason,
    required this.notifyEmail,
    required this.proofOfActionFile,
    required this.proofOfActionText,
  });

  /// Process request ID.
  final String id;

  /// What personal data does user found?
  final String personalData;

  /// Where user found personal data?
  final String foundSource;

  /// Request type ID that the user requested in this form.
  final String requestType;

  /// What action does user want to do for this request?
  final String requestAction;

  /// Reasons to support this request.
  final List<UserInputText> reasonTypes;

  /// Consider request status of this request [pass, fail, none].
  final RequestResultStatus considerRequestStatus;

  /// List of Reject type ID for rejecting the request in this form.
  final List<String> rejectTypes;

  /// What reason why rejecting this request?
  final String rejectConsiderReason;

  /// Email notification to relevant people.
  final List<String> notifyEmail;

  /// File link to proof that the request has been processed.
  final String proofOfActionFile;

  /// File link description to proof that the request has been processed.
  final String proofOfActionText;

  ProcessRequestModel.empty()
      : this(
          id: '',
          personalData: '',
          foundSource: '',
          requestType: '',
          requestAction: '',
          reasonTypes: [],
          considerRequestStatus: RequestResultStatus.none,
          rejectTypes: [],
          rejectConsiderReason: '',
          notifyEmail: [],
          proofOfActionFile: '',
          proofOfActionText: '',
        );

  ProcessRequestModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          personalData: map['personalData'] as String,
          foundSource: map['foundSource'] as String,
          requestType: map['requestType'] as String,
          requestAction: map['requestAction'] as String,
          reasonTypes: List<UserInputText>.from(
            (map['reasonTypes'] as DataMap).entries.map<UserInputText>((item) =>
                UserInputText.fromMap({'id': item.key, 'text': item.value})),
          ),
          considerRequestStatus:
              RequestResultStatus.values[map['considerRequestStatus'] as int],
          rejectTypes: List<dynamic>.from((map['rejectTypes'] as List<dynamic>))
              .map((item) => item.toString())
              .toList(),
          rejectConsiderReason: map['rejectConsiderReason'] as String,
          notifyEmail: List<String>.from(map['notifyEmail'] as List<dynamic>),
          proofOfActionFile: map['proofOfActionFile'] as String,
          proofOfActionText: map['proofOfActionText'] as String,
        );

  DataMap toMap() => {
        id: {
          'personalData': personalData,
          'foundSource': foundSource,
          'requestType': requestType,
          'requestAction': requestAction,
          'reasonTypes': reasonTypes.fold(
            {},
            (map, userInputText) => map..addAll(userInputText.toMap()),
          ),
          'considerRequestStatus': considerRequestStatus.index,
          'rejectTypes': rejectTypes,
          'rejectConsiderReason': rejectConsiderReason,
          'notifyEmail': notifyEmail,
          'proofOfActionFile': proofOfActionFile,
          'proofOfActionText': proofOfActionText,
        }
      };

  ProcessRequestModel copyWith({
    String? id,
    String? personalData,
    String? foundSource,
    String? requestType,
    String? requestAction,
    List<UserInputText>? reasonTypes,
    RequestResultStatus? considerRequestStatus,
    List<String>? rejectTypes,
    String? rejectConsiderReason,
    List<String>? notifyEmail,
    String? proofOfActionFile,
    String? proofOfActionText,
  }) {
    return ProcessRequestModel(
      id: id ?? this.id,
      personalData: personalData ?? this.personalData,
      foundSource: foundSource ?? this.foundSource,
      requestType: requestType ?? this.requestType,
      requestAction: requestAction ?? this.requestAction,
      reasonTypes: reasonTypes ?? this.reasonTypes,
      considerRequestStatus:
          considerRequestStatus ?? this.considerRequestStatus,
      rejectTypes: rejectTypes ?? this.rejectTypes,
      rejectConsiderReason: rejectConsiderReason ?? this.rejectConsiderReason,
      notifyEmail: notifyEmail ?? this.notifyEmail,
      proofOfActionFile: proofOfActionFile ?? this.proofOfActionFile,
      proofOfActionText: proofOfActionText ?? this.proofOfActionText,
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      personalData,
      foundSource,
      requestType,
      requestAction,
      reasonTypes,
      considerRequestStatus,
      rejectTypes,
      rejectConsiderReason,
      notifyEmail,
      proofOfActionFile,
      proofOfActionText,
    ];
  }
}
