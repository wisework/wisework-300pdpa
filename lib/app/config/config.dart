import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

class AppConfig {
  static const String appName = 'PDPA Management Platform';
  static const String baseUrl = 'https://pdpa-300.web.app';
  static const String defaultLanguage = 'th-TH';
  static const int generatePasswordLength = 6;

  //? Google Sign-In
  static const String webClientId =
      '336013362570-eno456l69gfsf0ulk6porsffvrg8hhhu.apps.googleusercontent.com';

  //? Bitly
  static const String accessTokenBitly =
      '1a4228869e688dba97d940375d04122e2341ec40';

  //? Email JS
  static const String emailJsUrl =
      'https://api.emailjs.com/api/v1.0/email/send';
  static const String serviceId = 'service_yu0bzoh';
  static const String templateId = 'template_638hul8';
  static const String userId = 'zAusZtWTuLIJ5NRsW';
  static const String notificationEmail = 'notifications.wisework@gmail.com';
  static const List<String> godIds = [
    'm23GKVPRbjVtZv5PjURy',
    'eR4l6QOXAUvmyaL3TFHj',
    'DNx3u82tT1QoVWwO9a0j',
    '0nJUnuW765fkHuw0NlQC',
    '2bKRYP8z1Qf2dLKK2UGk',
    'yMaDeJIa8kkvHxapqXjd',
  ];
}

class AppPreferences {
  static const String rememberEmail = 'remember_email';
  static const String isFirstLaunch = 'is_first_launch';
  static const String isDarkMode = 'is_dark_mode';
}

class UiConfig {
  static const double maxWidthContent = 768.0;
  static const double appBarTitleSpacing = 10.0;
  static const double defaultPaddingSpacing = 15.0;
  static const double lineSpacing = 15.0;
  static const double lineGap = 10.0;
  static const double paragraphSpacing = 15.0;
  static const double textSpacing = 6.0;
  static const double textLineSpacing = 4.0;
  static const double actionSpacing = 10.0;
  static const Duration toastDuration = Duration(milliseconds: 1500);
}

class DefaultMasterData {
  static List<RequestTypeModel> requestType = [
    RequestTypeModel(
      id: 'REQ-001',
      requestCode: 'REQ-001',
      description: const [
        LocalizedModel(language: 'en-US', text: 'Consent withdrawal'),
        LocalizedModel(language: 'th-TH', text: 'เพิกถอนความยินยอม'),
      ],
      status: ActiveStatus.active,
      createdBy: '',
      createdDate: DateTime.fromMillisecondsSinceEpoch(0),
      updatedBy: '',
      updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
    ),
    RequestTypeModel(
      id: 'REQ-002',
      requestCode: 'REQ-002',
      description: const [
        LocalizedModel(language: 'en-US', text: 'Access request'),
        LocalizedModel(language: 'th-TH', text: 'เข้าถึงและขอรับสำเนา '),
      ],
      status: ActiveStatus.active,
      createdBy: '',
      createdDate: DateTime.fromMillisecondsSinceEpoch(0),
      updatedBy: '',
      updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
    ),
    RequestTypeModel(
      id: 'REQ-003',
      requestCode: 'REQ-003',
      description: const [
        LocalizedModel(
            language: 'en-US',
            text: 'Informed where personal data are collected'),
        LocalizedModel(
            language: 'th-TH',
            text: 'ขอให้เปิดเผยถึงการได้มาซึ้นข้อมูลส่วนบุคคล'),
      ],
      status: ActiveStatus.active,
      createdBy: '',
      createdDate: DateTime.fromMillisecondsSinceEpoch(0),
      updatedBy: '',
      updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
    ),
    RequestTypeModel(
      id: 'REQ-004',
      requestCode: 'REQ-004',
      description: const [
        LocalizedModel(
            language: 'en-US', text: 'Rectification of personal data'),
        LocalizedModel(
            language: 'th-TH', text: 'แก้ไขข้อมูลส่วนบุคคลให้ถูกต้อง'),
      ],
      status: ActiveStatus.active,
      createdBy: '',
      createdDate: DateTime.fromMillisecondsSinceEpoch(0),
      updatedBy: '',
      updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
    ),
    RequestTypeModel(
      id: 'REQ-005',
      requestCode: 'REQ-005',
      description: const [
        LocalizedModel(language: 'en-US', text: 'Erasure of personal data'),
        LocalizedModel(language: 'th-TH', text: 'ลบข้อมูลส่วนบุคคล'),
      ],
      status: ActiveStatus.active,
      createdBy: '',
      createdDate: DateTime.fromMillisecondsSinceEpoch(0),
      updatedBy: '',
      updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
    ),
    RequestTypeModel(
      id: 'REQ-006',
      requestCode: 'REQ-006',
      description: const [
        LocalizedModel(
            language: 'en-US', text: 'Restriction of processing personal data'),
        LocalizedModel(
            language: 'th-TH', text: 'ระงับการประมวลผลข้อมูลส่วนบุคคล'),
      ],
      status: ActiveStatus.active,
      createdBy: '',
      createdDate: DateTime.fromMillisecondsSinceEpoch(0),
      updatedBy: '',
      updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
    ),
    RequestTypeModel(
      id: 'REQ-007',
      requestCode: 'REQ-007',
      description: const [
        LocalizedModel(
            language: 'en-US', text: 'Personal data portability request'),
        LocalizedModel(language: 'th-TH', text: 'ให้โอนย้ายข้อมูลส่วนบุคคล'),
      ],
      status: ActiveStatus.active,
      createdBy: '',
      createdDate: DateTime.fromMillisecondsSinceEpoch(0),
      updatedBy: '',
      updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
    ),
    RequestTypeModel(
      id: 'REQ-008',
      requestCode: 'REQ-008',
      description: const [
        LocalizedModel(
            language: 'en-US',
            text: 'Objection to processing of personal data'),
        LocalizedModel(language: 'th-TH', text: 'คัดค้านการประมวลผลข้อมูล'),
      ],
      status: ActiveStatus.active,
      createdBy: '',
      createdDate: DateTime.fromMillisecondsSinceEpoch(0),
      updatedBy: '',
      updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
    ),
    RequestTypeModel(
      id: 'REQ-009',
      requestCode: 'REQ-009',
      description: const [
        LocalizedModel(
            language: 'en-US', text: 'Personal Data Breach Notification'),
        LocalizedModel(language: 'th-TH', text: 'แจ้งเหตุละเมิด'),
      ],
      status: ActiveStatus.active,
      createdBy: '',
      createdDate: DateTime.fromMillisecondsSinceEpoch(0),
      updatedBy: '',
      updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
    )
  ];

  static List<ReasonTypeModel> reasonType = [
    ReasonTypeModel(
      id: 'RES-001',
      reasonCode: 'RES-001',
      description: const [
        LocalizedModel(
          language: 'th-TH',
          text:
              'อยู่ในระหว่างการตรวจสอบตามที่เจ้าของข้อมูลส่วนบุคคลร้องขอให้บริษัทแก้ไขข้อมูลส่วนบุคคล',
        ),
        LocalizedModel(language: 'en-US', text: ''),
      ],
      requiredInputReasonText: false,
      status: ActiveStatus.active,
      createdBy: '',
      createdDate: DateTime.fromMillisecondsSinceEpoch(0),
      updatedBy: '',
      updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
    ),
    ReasonTypeModel(
      id: 'RES-002',
      reasonCode: 'RES-002',
      description: const [
        LocalizedModel(
          language: 'th-TH',
          text:
              'เป็นข้อมูลส่วนบุคคลที่ต้องลบหรือทำลาย เพราะเป็นการประมวลผลข้อมูลส่วนบุคคลโดยไม่ชอบด้วยกฎหมายแต่เจ้าของข้อมูลส่วนบุคคลประสงค์ขอให้ระงับการใช้แทน',
        ),
        LocalizedModel(language: 'en-US', text: ''),
      ],
      requiredInputReasonText: false,
      status: ActiveStatus.active,
      createdBy: '',
      createdDate: DateTime.fromMillisecondsSinceEpoch(0),
      updatedBy: '',
      updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
    ),
    ReasonTypeModel(
      id: 'RES-003',
      reasonCode: 'RES-003',
      description: const [
        LocalizedModel(
          language: 'th-TH',
          text:
              'ข้อมูลส่วนบุคคลหมดความจำเป็นในการเก็บรักษาไว้ตามวัตถุประสงค์ในการประมวลผลแต่เจ้าของข้อมูลส่วนบุคคลมีความจำเป็นต้องขอให้เก็บรักษาไว้เพื่อใช้ในการก่อตั้งสิทธิเรียกร้องตามกฎหมายการปฏิบัติตามหรือการใช้สิทธิเรียกร้องตามกฎหมาย หรือการยกขึ้นต่อสู้สิทธิเรียกร้องตามกฎหมาย',
        ),
        LocalizedModel(language: 'en-US', text: ''),
      ],
      requiredInputReasonText: false,
      status: ActiveStatus.active,
      createdBy: '',
      createdDate: DateTime.fromMillisecondsSinceEpoch(0),
      updatedBy: '',
      updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
    ),
    ReasonTypeModel(
      id: 'RES-004',
      reasonCode: 'RES-004',
      description: const [
        LocalizedModel(
          language: 'th-TH',
          text: 'อื่นๆ (โปรดระบุ)',
        ),
        LocalizedModel(language: 'en-US', text: ''),
      ],
      requiredInputReasonText: false,
      status: ActiveStatus.active,
      createdBy: '',
      createdDate: DateTime.fromMillisecondsSinceEpoch(0),
      updatedBy: '',
      updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
    ),
  ];
}
