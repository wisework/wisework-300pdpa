import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/etc/user_input_text.dart';
import 'package:pdpa/app/data/models/etc/user_input_purpose.dart';
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
  final List<UserInputText> mandatoryFields;
  final List<UserInputText> customFields;
  final List<UserInputPurpose> purposes;
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
          mandatoryFields: List<UserInputText>.from(
            (map['mandatoryFields'] as DataMap).entries.map<UserInputText>(
                (item) => UserInputText.fromMap(
                    {'id': item.key, 'text': item.value})),
          ),
          customFields: List<UserInputText>.from(
            (map['customFields'] as DataMap).entries.map<UserInputText>(
                (item) => UserInputText.fromMap(
                    {'id': item.key, 'text': item.value})),
          ),
          purposes: List<UserInputPurpose>.from(
            (map['purposes'] as DataMap).entries.map<UserInputPurpose>((item) =>
                UserInputPurpose.fromMap({'id': item.key, ...item.value})),
          ),
          isAcceptConsent: map['isAcceptConsent'] as bool,
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
        );

  factory UserConsentModel.fromDocument(FirebaseDocument document) {
    DataMap response = document.data()!;
    response['id'] = document.id;
    return UserConsentModel.fromMap(response);
  }

  DataMap toMap() => {
        'consentFormId': consentFormId,
        'mandatoryFields': mandatoryFields.fold(
          {},
          (map, userInputField) => map..addAll(userInputField.toMap()),
        ),
        'customFields': customFields.fold(
          {},
          (map, userInputField) => map..addAll(userInputField.toMap()),
        ),
        'purposes': purposes.fold(
          {},
          (map, userInputOption) => map..addAll(userInputOption.toMap()),
        ),
        'isAcceptConsent': isAcceptConsent,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  UserConsentModel copyWith({
    String? id,
    String? consentFormId,
    List<UserInputText>? mandatoryFields,
    List<UserInputText>? customFields,
    List<UserInputPurpose>? purposes,
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
