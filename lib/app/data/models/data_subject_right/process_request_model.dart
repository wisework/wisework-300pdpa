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
    required this.rejectType,
    required this.rejectText,
    required this.considerRequestStatus,
    required this.proofOfActionFile,
    required this.proofOfActionText,
  });

  final String id;
  final String personalData;
  final String foundSource;
  final String requestType;
  final String requestAction;
  final List<UserInputText> reasonTypes;
  final String rejectType;
  final String rejectText;
  final ConsiderRequestStatus considerRequestStatus;
  final String proofOfActionFile;
  final String proofOfActionText;

  ProcessRequestModel.empty()
      : this(
          id: '',
          personalData: '',
          foundSource: '',
          requestType: '',
          requestAction: '',
          reasonTypes: [],
          rejectType: '',
          rejectText: '',
          considerRequestStatus: ConsiderRequestStatus.none,
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
          rejectType: map['rejectType'] as String,
          rejectText: map['rejectText'] as String,
          considerRequestStatus:
              ConsiderRequestStatus.values[map['considerRequestStatus'] as int],
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
            (map, userInputField) => map..addAll(userInputField.toMap()),
          ),
          'rejectType': rejectType,
          'rejectText': rejectText,
          'considerRequestStatus': considerRequestStatus.index,
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
    String? rejectType,
    String? rejectText,
    ConsiderRequestStatus? considerRequestStatus,
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
      rejectType: rejectType ?? this.rejectType,
      rejectText: rejectText ?? this.rejectText,
      considerRequestStatus:
          considerRequestStatus ?? this.considerRequestStatus,
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
      rejectType,
      rejectText,
      considerRequestStatus,
      proofOfActionFile,
      proofOfActionText,
    ];
  }
}
