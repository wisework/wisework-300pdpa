import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class DataSubjectRightRequestModel extends Equatable {
  const DataSubjectRightRequestModel(
      {required this.id,
      required this.dataRequester,
      required this.dataOwner,
      required this.isDataOwner,
      required this.powerVerifications,
      required this.identityVerifications,
      required this.processRequests,
      required this.requestExpirationDate,
      required this.notifyEmail,
      required this.requestFormVerified,
      required this.verifyRequest,
      required this.resultRequest,
      required this.verifyReason,
      required this.lastSeenBy,
      required this.status,
      required this.createdBy,
      required this.createdDate,
      required this.updatedBy,
      required this.updatedDate});

  final String id;
  final List<LocalizedModel> dataRequester;
  final List<LocalizedModel> dataOwner;
  final bool isDataOwner;
  final List<LocalizedModel> powerVerifications;
  final List<LocalizedModel> identityVerifications;
  final List<LocalizedModel> processRequests;
  final DateTime requestExpirationDate;
  final List<LocalizedModel> notifyEmail;
  final bool requestFormVerified;
  final List<LocalizedModel> verifyRequest;
  final bool resultRequest;
  final String verifyReason;
  final String lastSeenBy;

  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

  DataSubjectRightRequestModel.empty()
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
          requestFormVerified: true,
          verifyRequest: [],
          resultRequest: true,
          verifyReason: '',
          lastSeenBy: '',
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        );

  DataSubjectRightRequestModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          dataRequester: List<LocalizedModel>.from(
            (map['dataRequester'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          dataOwner: List<LocalizedModel>.from(
            (map['dataOwner'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          isDataOwner: map['isDataOwner'] as bool,
          powerVerifications: List<LocalizedModel>.from(
            (map['powerVerifications'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          identityVerifications: List<LocalizedModel>.from(
            (map['identityVerifications'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          processRequests: List<LocalizedModel>.from(
            (map['processRequests'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          requestExpirationDate:
              DateTime.parse(map['requestExpirationDate'] as String),
          notifyEmail: List<LocalizedModel>.from(
            (map['notifyEmail'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          requestFormVerified: map['requestFormVerified'] as bool,
          verifyRequest: List<LocalizedModel>.from(
            (map['verifyRequest'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          resultRequest: map['resultRequest'] as bool,
          verifyReason: map['verifyReason'] as String,
          lastSeenBy: map['lastSeenBy'] as String,
          status: ActiveStatus.values[map['status'] as int],
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
        );

  DataMap toMap() => {
        'dataRequester': dataRequester.map((item) => item.toMap()).toList(),
        'dataOwner': dataOwner.map((item) => item.toMap()).toList(),
        'isDataOwner': isDataOwner,
        'powerVerifications':
            powerVerifications.map((item) => item.toMap()).toList(),
        'identityVerifications':
            identityVerifications.map((item) => item.toMap()).toList(),
        'processRequests': processRequests.map((item) => item.toMap()).toList(),
        'requestExpirationDate': requestExpirationDate,
        'notifyEmail': notifyEmail.map((item) => item.toMap()).toList(),
        'requestFormVerified': requestFormVerified,
        'verifyRequest': verifyRequest.map((item) => item.toMap()).toList(),
        'resultRequest': resultRequest,
        'verifyReason': verifyReason,
        'lastSeenBy': lastSeenBy,
        'status': status.index,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  factory DataSubjectRightRequestModel.fromDocument(FirebaseDocument document) {
    DataMap response = document.data()!;
    response['id'] = document.id;
    return DataSubjectRightRequestModel.fromMap(response);
  }

  DataSubjectRightRequestModel copyWith({
    String? id,
    List<LocalizedModel>? dataRequester,
    List<LocalizedModel>? dataOwner,
    bool? isDataOwner,
    List<LocalizedModel>? powerVerifications,
    List<LocalizedModel>? identityVerifications,
    List<LocalizedModel>? processRequests,
    DateTime? requestExpirationDate,
    List<LocalizedModel>? notifyEmail,
    bool? requestFormVerified,
    List<LocalizedModel>? verifyRequest,
    bool? resultRequest,
    String? verifyReason,
    String? lastSeenBy,
    ActiveStatus? status,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
  }) {
    return DataSubjectRightRequestModel(
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
      verifyRequest: verifyRequest ?? this.verifyRequest,
      resultRequest: resultRequest ?? this.resultRequest,
      verifyReason: id ?? this.id,
      lastSeenBy: id ?? this.id,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

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
      verifyRequest,
      resultRequest,
      verifyReason,
      lastSeenBy,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
