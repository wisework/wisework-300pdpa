import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';

final List<RequestTypeModel> requestTypesPreset = [
  RequestTypeModel.empty().copyWith(
    id: 'DSR-REQ-001',
    requestCode: 'REQ-001',
    description: const [
      LocalizedModel(
        language: 'en-US',
        text: "Withdrawal of Consent",
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'เพิกถอนความยินยอม',
      ),
    ],
    rejectTypes: [],
    editable: false,
  ),
  RequestTypeModel.empty().copyWith(
    id: 'DSR-REQ-002',
    requestCode: 'REQ-002',
    description: const [
      LocalizedModel(
        language: 'en-US',
        text: "Request for Access to Personal Data",
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'เข้าถึงและขอรับสำเนา',
      ),
    ],
    rejectTypes: [
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-001'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-002'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-006'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-007'),
    ],
    editable: false,
  ),
  RequestTypeModel.empty().copyWith(
    id: 'DSR-REQ-003',
    requestCode: 'REQ-003',
    description: const [
      LocalizedModel(
        language: 'en-US',
        text: "Request for Information on Data Collection",
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'ขอให้เปิดเผยถึงการได้มาซึ่งข้อมูลส่วนบุคคล',
      ),
    ],
    rejectTypes: [
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-001'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-002'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-006'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-007'),
    ],
    editable: false,
  ),
  RequestTypeModel.empty().copyWith(
    id: 'DSR-REQ-004',
    requestCode: 'REQ-004',
    description: const [
      LocalizedModel(
        language: 'en-US',
        text: "Correction of Personal Data",
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'แก้ไขข้อมูลส่วนบุคคลให้ถูกต้อง',
      ),
    ],
    rejectTypes: [
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-001'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-002'),
    ],
    editable: false,
  ),
  RequestTypeModel.empty().copyWith(
    id: 'DSR-REQ-005',
    requestCode: 'REQ-005',
    description: const [
      LocalizedModel(
        language: 'en-US',
        text: "Deletion of Personal Data",
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'ลบข้อมูลส่วนบุคคล',
      ),
    ],
    rejectTypes: [
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-001'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-002'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-004'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-006'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-008'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-009'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-010'),
    ],
    editable: false,
  ),
  RequestTypeModel.empty().copyWith(
    id: 'DSR-REQ-006',
    requestCode: 'REQ-006',
    description: const [
      LocalizedModel(
        language: 'en-US',
        text: "Restriction of Personal Data Processing",
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'ระงับการประมวลผลข้อมูล',
      ),
    ],
    rejectTypes: [
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-001'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-002'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-007'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-009'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-0010'),
    ],
    editable: false,
  ),
  RequestTypeModel.empty().copyWith(
    id: 'DSR-REQ-007',
    requestCode: 'REQ-007',
    description: const [
      LocalizedModel(
        language: 'en-US',
        text: "Request for Personal Data Portability",
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'ให้โอนย้ายข้อมูลส่วนบุคคล',
      ),
    ],
    rejectTypes: [
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-001'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-002'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-007'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-009'),
    ],
    editable: false,
  ),
  RequestTypeModel.empty().copyWith(
    id: 'DSR-REQ-008',
    requestCode: 'REQ-008',
    description: const [
      LocalizedModel(
        language: 'en-US',
        text: "Objection to Personal Data Processing",
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'คัดค้านการประมวลผลข้อมูล',
      ),
    ],
    rejectTypes: [
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-001'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-002'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-009'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-010'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-011'),
    ],
    editable: false,
  ),
  RequestTypeModel.empty().copyWith(
    id: 'DSR-REQ-009',
    requestCode: 'REQ-009',
    description: const [
      LocalizedModel(
        language: 'en-US',
        text: "Report a data breach",
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'แจ้งเหตุละเมิด',
      ),
    ],
    rejectTypes: [
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-001'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-002'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-003'),
      RejectTypeModel.empty().copyWith(id: 'DSR-REJ-006'),
    ],
    editable: false,
  ),
];
