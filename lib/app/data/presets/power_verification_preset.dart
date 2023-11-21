import 'package:easy_localization/easy_localization.dart';
import 'package:pdpa/app/data/models/data_subject_right/power_verification_model.dart';

List<PowerVerificationModel> powerVerificationsPreset = [
  PowerVerificationModel(
    id: 'DSR-PV-001',
    title: tr('dataSubjectRight.powerVerification.powerOfAttorney'),
    additionalReq: false,
  ),
  PowerVerificationModel(
    id: 'DSR-PV-002',
    title: tr('dataSubjectRight.powerVerification.other'),
    additionalReq: true,
  ),
];
