import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';

final List<PurposeCategoryModel> purposeCategoriesPreset = [
  PurposeCategoryModel.empty().copyWith(
    title: const [
      LocalizedModel(
        language: 'en-US',
        text: 'Consent for CCTV Data Processing',
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'การประมวลผลข้อมูลกรณีการใช้กล้องวงจรปิด (CCTV)',
      ),
    ],
    description: const [
      LocalizedModel(
        language: 'en-US',
        text: '',
      ),
      LocalizedModel(
        language: 'th-TH',
        text: '',
      ),
    ],
  ),
  PurposeCategoryModel.empty().copyWith(
    title: const [
      LocalizedModel(
        language: 'en-US',
        text: 'Job Recruitment (HR Recruitment)',
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'กรณีรับสมัครงาน (HR Recruitment)',
      ),
    ],
    description: const [
      LocalizedModel(
        language: 'en-US',
        text: '',
      ),
      LocalizedModel(
        language: 'th-TH',
        text: '',
      ),
    ],
  ),
  PurposeCategoryModel.empty().copyWith(
    title: const [
      LocalizedModel(
        language: 'en-US',
        text: 'Consent-Based Marketing',
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'วัตถุประสงค์ทางการตลาด (Marketing)',
      ),
    ],
    description: const [
      LocalizedModel(
        language: 'en-US',
        text: '',
      ),
      LocalizedModel(
        language: 'th-TH',
        text: '',
      ),
    ],
  ),
  PurposeCategoryModel.empty().copyWith(
    title: const [
      LocalizedModel(
        language: 'en-US',
        text:
            'Consent for the Disclosure of Personal Information (General Case)',
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'ความยินยอมการเปิดเผยข้อมูลส่วนบุคคล (กรณีทั่วไป)',
      ),
    ],
    description: const [
      LocalizedModel(
        language: 'en-US',
        text: '',
      ),
      LocalizedModel(
        language: 'th-TH',
        text: '',
      ),
    ],
  ),
  PurposeCategoryModel.empty().copyWith(
    title: const [
      LocalizedModel(
        language: 'en-US',
        text: 'Internal Network System (IT Service)',
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'เข้าใช้งานระบบเครือข่ายภายใน (IT service)',
      ),
    ],
    description: const [
      LocalizedModel(
        language: 'en-US',
        text: '',
      ),
      LocalizedModel(
        language: 'th-TH',
        text: '',
      ),
    ],
  ),
  PurposeCategoryModel.empty().copyWith(
    title: const [
      LocalizedModel(
        language: 'en-US',
        text: 'Consent for Identity Verification',
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'ขอความยินยอมกรณีการยืนยันตัวตน',
      ),
    ],
    description: const [
      LocalizedModel(
        language: 'en-US',
        text: '',
      ),
      LocalizedModel(
        language: 'th-TH',
        text: '',
      ),
    ],
  ),
];
