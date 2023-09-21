import 'package:equatable/equatable.dart';


class UserConsent extends Equatable {
  const UserConsent({
    required this.id,
    required this.inputFields,
    required this.purposes,
    required this.isAcceptConsent,
    required this.consentFormId,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
    required this.companyId,
  });

  UserConsent.empty()
      : this(
          id: '',
          inputFields: [],
          purposes: [],
          isAcceptConsent: false,
          consentFormId: '',
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
          companyId: '',
        );

  final String id;
  final List<String> inputFields;
  final List<String> purposes;
  final bool isAcceptConsent;
  final String consentFormId;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;
  final String companyId;

  @override
  List<Object?> get props {
    return [
      id,
      inputFields,
      purposes,
      isAcceptConsent,
      consentFormId,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
      companyId,
    ];
  }
}
