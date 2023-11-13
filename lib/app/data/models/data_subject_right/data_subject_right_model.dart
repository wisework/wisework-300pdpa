import 'package:equatable/equatable.dart';

import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/requester_input_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/requester_verification_model.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class DataSubjectRightModel extends Equatable {
  const DataSubjectRightModel({
    required this.id,
    required this.dataRequester,
    required this.dataOwner,
    required this.isDataOwner,
    required this.powerVerifications,
    required this.identityVerifications,
    required this.processRequests,
    required this.requestExpirationDate,
    required this.notifyEmail,
    required this.requestFormVerified,
    required this.requestVerifyingStatus,
    required this.resultRequest,
    required this.verifyReason,
    required this.lastSeenBy,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  final String id;
  final List<RequesterInputModel> dataRequester;
  final List<RequesterInputModel> dataOwner;
  final bool isDataOwner;
  final List<RequesterVerificationModel> powerVerifications;
  final List<RequesterVerificationModel> identityVerifications;
  final List<ProcessRequestModel> processRequests;
  final DateTime requestExpirationDate;
  final List<String> notifyEmail;
  final bool requestFormVerified;
  final RequestVerifyingStatus requestVerifyingStatus;
  final bool resultRequest;
  final String verifyReason;
  final String lastSeenBy;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

  DataSubjectRightModel.empty()
      : this(
          id: '',
          dataRequester: [],
          dataOwner: [],
          isDataOwner: true,
          powerVerifications: [],
          identityVerifications: [],
          processRequests: [],
          requestExpirationDate: DateTime.fromMillisecondsSinceEpoch(0),
          notifyEmail: [],
          requestFormVerified: false,
          requestVerifyingStatus: RequestVerifyingStatus.none,
          resultRequest: false,
          verifyReason: '',
          lastSeenBy: '',
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        );

  DataSubjectRightModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          dataRequester: List<RequesterInputModel>.from(
            (map['dataRequester'] as DataMap).entries.map<RequesterInputModel>(
                (item) => RequesterInputModel.fromMap(
                    {'id': item.key, ...item.value})),
          ),
          dataOwner: List<RequesterInputModel>.from(
            (map['dataOwner'] as DataMap).entries.map<RequesterInputModel>(
                (item) => RequesterInputModel.fromMap(
                    {'id': item.key, ...item.value})),
          ),
          isDataOwner: map['isDataOwner'] as bool,
          powerVerifications: List<RequesterVerificationModel>.from(
            (map['powerVerifications'] as DataMap)
                .entries
                .map<RequesterVerificationModel>((item) =>
                    RequesterVerificationModel.fromMap(
                        {'id': item.key, ...item.value})),
          ),
          identityVerifications: List<RequesterVerificationModel>.from(
            (map['identityVerifications'] as DataMap)
                .entries
                .map<RequesterVerificationModel>((item) =>
                    RequesterVerificationModel.fromMap(
                        {'id': item.key, ...item.value})),
          ),
          processRequests: List<ProcessRequestModel>.from(
            (map['processRequests'] as DataMap)
                .entries
                .map<ProcessRequestModel>((item) => ProcessRequestModel.fromMap(
                    {'id': item.key, ...item.value})),
          ),
          requestExpirationDate:
              DateTime.parse(map['requestExpirationDate'] as String),
          notifyEmail: List<String>.from(map['notifyEmail'] as List<dynamic>),
          requestFormVerified: map['requestFormVerified'] as bool,
          requestVerifyingStatus: RequestVerifyingStatus
              .values[map['requestVerifyingStatus'] as int],
          resultRequest: map['resultRequest'] as bool,
          verifyReason: map['verifyReason'] as String,
          lastSeenBy: map['lastSeenBy'] as String,
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
        );

  factory DataSubjectRightModel.fromDocument(FirebaseDocument document) {
    DataMap response = document.data()!;
    response['id'] = document.id;
    return DataSubjectRightModel.fromMap(response);
  }

  DataMap toMap() => {
        'id': id,
        'dataRequester': dataRequester.fold(
          {},
          (map, requesterInput) => map..addAll(requesterInput.toMap()),
        ),
        'dataOwner': dataOwner.fold(
          {},
          (map, requesterInput) => map..addAll(requesterInput.toMap()),
        ),
        'isDataOwner': isDataOwner,
        'powerVerifications': powerVerifications.fold(
          {},
          (map, requesterVerification) =>
              map..addAll(requesterVerification.toMap()),
        ),
        'identityVerifications': identityVerifications.fold(
          {},
          (map, requesterVerification) =>
              map..addAll(requesterVerification.toMap()),
        ),
        'processRequests': processRequests.fold(
          {},
          (map, processRequest) => map..addAll(processRequest.toMap()),
        ),
        'requestExpirationDate': requestExpirationDate.toIso8601String(),
        'notifyEmail': notifyEmail,
        'requestFormVerified': requestFormVerified,
        'requestVerifyingStatus': requestVerifyingStatus.index,
        'resultRequest': resultRequest,
        'verifyReason': verifyReason,
        'lastSeenBy': lastSeenBy,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  DataSubjectRightModel copyWith({
    String? id,
    List<RequesterInputModel>? dataRequester,
    List<RequesterInputModel>? dataOwner,
    bool? isDataOwner,
    List<RequesterVerificationModel>? powerVerifications,
    List<RequesterVerificationModel>? identityVerifications,
    List<ProcessRequestModel>? processRequests,
    DateTime? requestExpirationDate,
    List<String>? notifyEmail,
    bool? requestFormVerified,
    RequestVerifyingStatus? requestVerifyingStatus,
    bool? resultRequest,
    String? verifyReason,
    String? lastSeenBy,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
  }) {
    return DataSubjectRightModel(
      id: id ?? this.id,
      dataRequester: dataRequester ?? this.dataRequester,
      dataOwner: dataOwner ?? this.dataOwner,
      isDataOwner: isDataOwner ?? this.isDataOwner,
      powerVerifications: powerVerifications ?? this.powerVerifications,
      identityVerifications:
          identityVerifications ?? this.identityVerifications,
      processRequests: processRequests ?? this.processRequests,
      requestExpirationDate:
          requestExpirationDate ?? this.requestExpirationDate,
      notifyEmail: notifyEmail ?? this.notifyEmail,
      requestFormVerified: requestFormVerified ?? this.requestFormVerified,
      requestVerifyingStatus:
          requestVerifyingStatus ?? this.requestVerifyingStatus,
      resultRequest: resultRequest ?? this.resultRequest,
      verifyReason: verifyReason ?? this.verifyReason,
      lastSeenBy: lastSeenBy ?? this.lastSeenBy,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  DataSubjectRightModel setCreate(String email, DateTime date) => copyWith(
        createdBy: email,
        createdDate: date,
        updatedBy: email,
        updatedDate: date,
      );

  DataSubjectRightModel setUpdate(String email, DateTime date) => copyWith(
        updatedBy: email,
        updatedDate: date,
      );

  @override
  List<Object> get props {
    return [
      id,
      dataRequester,
      dataOwner,
      isDataOwner,
      powerVerifications,
      identityVerifications,
      processRequests,
      requestExpirationDate,
      notifyEmail,
      requestFormVerified,
      requestVerifyingStatus,
      resultRequest,
      verifyReason,
      lastSeenBy,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
