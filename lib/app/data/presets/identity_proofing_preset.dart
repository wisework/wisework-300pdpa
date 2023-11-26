import 'package:easy_localization/easy_localization.dart';
import 'package:pdpa/app/data/models/data_subject_right/power_verification_model.dart';

List<PowerVerificationModel> identityProofingPreset = [
  PowerVerificationModel(
    id: 'DSR-IV-001',
    title: tr('dataSubjectRight.identityVerification.copyOfHouseRegistration'),
    additionalReq: false,
  ),
  PowerVerificationModel(
    id: 'DSR-IV-002',
    title: tr('dataSubjectRight.identityVerification.copyOfIdentificationCare'),
    additionalReq: false,
  ),
  PowerVerificationModel(
    id: 'DSR-IV-003',
    title: tr('dataSubjectRight.identityVerification.copyOfPassport'),
    additionalReq: false,
  ),
  PowerVerificationModel(
    id: 'DSR-IV-004',
    title: tr('dataSubjectRight.identityVerification.other'),
    additionalReq: true,
  ),
];
