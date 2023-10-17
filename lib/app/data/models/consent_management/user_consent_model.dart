import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/etc/user_input_field.dart';
import 'package:pdpa/app/data/models/etc/user_input_option.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class UserConsentModel extends Equatable {
  const UserConsentModel({
    required this.id,
    required this.consentFormId,
    required this.mandatoryFields,
    required this.customFields,
    required this.purposes,
    required this.isAcceptConsent,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  final String id;
  final String consentFormId;
  final List<UserInputField> mandatoryFields;
  final List<UserInputField> customFields;
  final List<UserInputOption> purposes;
  final bool isAcceptConsent;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

  UserConsentModel.empty()
      : this(
          id: '',
          consentFormId: '',
          mandatoryFields: [],
          customFields: [],
          purposes: [],
          isAcceptConsent: false,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        );

  UserConsentModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          consentFormId: map['consentFormId'] as String,
          mandatoryFields: List<UserInputField>.from(
            (map['mandatoryFields'] as List<dynamic>).map<UserInputField>(
              (item) => UserInputField.fromMap(item as DataMap),
            ),
          ),
          customFields: List<UserInputField>.from(
            (map['customFields'] as List<dynamic>).map<UserInputField>(
              (item) => UserInputField.fromMap(item as DataMap),
            ),
          ),
          purposes: List<UserInputOption>.from(
            (map['purposes'] as List<dynamic>).map<UserInputOption>(
              (item) => UserInputOption.fromMap(item as DataMap),
            ),
          ),
          isAcceptConsent: map['isAcceptConsent'] as bool,
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
        );

  DataMap toMap() => {
        'consentFormId': consentFormId,
        'mandatoryFields': mandatoryFields.map((item) => item.toMap()).toList(),
        'customFields': customFields.map((item) => item.toMap()).toList(),
        'purposes': purposes.map((item) => item.toMap()).toList(),
        'isAcceptConsent': isAcceptConsent,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  factory UserConsentModel.fromDocument(FirebaseDocument document) {
    DataMap response = document.data()!;
    response['id'] = document.id;
    return UserConsentModel.fromMap(response);
  }

  UserConsentModel copyWith({
    String? id,
    String? consentFormId,
    List<UserInputField>? mandatoryFields,
    List<UserInputField>? customFields,
    List<UserInputOption>? purposes,
    bool? isAcceptConsent,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
  }) {
    return UserConsentModel(
      id: id ?? this.id,
      consentFormId: consentFormId ?? this.consentFormId,
      mandatoryFields: mandatoryFields ?? this.mandatoryFields,
      customFields: customFields ?? this.customFields,
      purposes: purposes ?? this.purposes,
      isAcceptConsent: isAcceptConsent ?? this.isAcceptConsent,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  UserConsentModel setCreate(String email, DateTime date) => copyWith(
        createdBy: email,
        createdDate: date,
        updatedBy: email,
        updatedDate: date,
      );

  UserConsentModel setUpdate(String email, DateTime date) => copyWith(
        updatedBy: email,
        updatedDate: date,
      );

  @override
  List<Object> get props {
    return [
      id,
      consentFormId,
      mandatoryFields,
      customFields,
      purposes,
      isAcceptConsent,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
