import 'package:easy_localization/easy_localization.dart';
import 'package:pdpa/app/data/models/data_subject_right/power_verification_model.dart';

List<PowerVerificationModel> identityProofingPreset = [
  PowerVerificationModel(
    id: '1',
    title: tr('dataSubjectRight.identityVerification.copyOfHouseRegistration'),
    additionalReq: false,
  ),
  PowerVerificationModel(
    id: '2',
    title: tr('dataSubjectRight.identityVerification.copyOfIdentificationCare'),
    additionalReq: false,
  ),
  PowerVerificationModel(
    id: '3',
    title: tr('dataSubjectRight.identityVerification.copyOfPassport'),
    additionalReq: false,
  ),
  PowerVerificationModel(
    id: '4',
    title: tr('dataSubjectRight.identityVerification.other'),
    additionalReq: true,
  ),
];
