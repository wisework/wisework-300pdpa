import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';

final List<RejectTypeModel> rejectTypesPreset = [
  
    RejectTypeModel.empty().copyWith(
      id: 'DSR-REJ-001',
      rejectCode: '',
      description: const [
        LocalizedModel(
          language: 'en-US',
          text: "Unreasonable Requests",
        ),
        LocalizedModel(
          language: 'th-TH',
          text: 'คำขอไม่สมเหตุผล',
        ),
      ],
      editable: false,
    ),
    RejectTypeModel.empty().copyWith(
      id: 'DSR-REJ-002',
      rejectCode: '',
      description: const [
        LocalizedModel(
          language: 'en-US',
          text: "Excessive requests",
        ),
        LocalizedModel(
          language: 'th-TH',
          text: 'คำขอฟุ่มเฟือย',
        ),
      ],
      editable: false,
    ),
    RejectTypeModel.empty().copyWith(
      id: 'DSR-REJ-003',
      rejectCode: '',
      description: const [
        LocalizedModel(
          language: 'en-US',
          text: "Data Subject already possesses data",
        ),
        LocalizedModel(
          language: 'th-TH',
          text: 'เจ้าของข้อมูลมีข้อมูลอยู่แล้ว',
        ),
      ],
      editable: false,
    ),
    RejectTypeModel.empty().copyWith(
      id: 'DSR-REJ-004',
      rejectCode: '',
      description: const [
        LocalizedModel(
          language: 'en-US',
          text: "Freedom of Expression",
        ),
        LocalizedModel(
          language: 'th-TH',
          text: 'เก็บเพื่อเสรีภาพในการแสดงความคิดเห็น',
        ),
      ],
      editable: false,
    ),
    RejectTypeModel.empty().copyWith(
      id: 'DSR-REJ-005',
      rejectCode: '',
      description: const [
        LocalizedModel(
          language: 'en-US',
          text: "Contractual Performance",
        ),
        LocalizedModel(
          language: 'th-TH',
          text: 'เกี่ยวกับการทำตามสัญญา',
        ),
      ],
      editable: false,
    ),
    RejectTypeModel.empty().copyWith(
      id: 'DSR-REJ-006',
      rejectCode: '',
      description: const [
        LocalizedModel(
          language: 'en-US',
          text: "Legal Authorization",
        ),
        LocalizedModel(
          language: 'th-TH',
          text: 'กฎหมายอนุญาต',
        ),
      ],
      editable: false,
    ),
    RejectTypeModel.empty().copyWith(
      id: 'DSR-REJ-007',
      rejectCode: '',
      description: const [
        LocalizedModel(
          language: 'en-US',
          text: "Negative Impact on others",
        ),
        LocalizedModel(
          language: 'th-TH',
          text: 'เกิดผลกระทบด้านลบแก่บุคคลอื่น',
        ),
      ],
      editable: false,
    ),
    RejectTypeModel.empty().copyWith(
      id: 'DSR-REJ-008',
      rejectCode: '',
      description: const [
        LocalizedModel(
          language: 'en-US',
          text: "Required for Processing",
        ),
        LocalizedModel(
          language: 'th-TH',
          text: 'จำเป็นสำหรับการประมวลผล',
        ),
      ],
      editable: false,
    ),
    RejectTypeModel.empty().copyWith(
      id: 'DSR-REJ-009',
      rejectCode: '',
      description: const [
        LocalizedModel(
          language: 'en-US',
          text: "Public Interest, State Power, or Legal Duty",
        ),
        LocalizedModel(
          language: 'th-TH',
          text: 'ประโยชน์สาธารณะ หรืออำนาจรัฐ หรือหน้าที่ตามกฎหมาย',
        ),
      ],
      editable: false,
    ),
    RejectTypeModel.empty().copyWith(
      id: 'DSR-REJ-010',
      rejectCode: '',
      description: const [
        LocalizedModel(
          language: 'en-US',
          text: "Legal Rights Establishment, Exercise, or Protection",
        ),
        LocalizedModel(
          language: 'th-TH',
          text: 'ก่อตั้งใช้ หรือป้องกันสิทธิตามกฎหมาย',
        ),
      ],
      editable: false,
    ),
    RejectTypeModel.empty().copyWith(
      id: 'DSR-REJ-011',
      rejectCode: '',
      description: const [
        LocalizedModel(
          language: 'en-US',
          text: "Legitimate Interest",
        ),
        LocalizedModel(
          language: 'th-TH',
          text: 'ประโยชน์โดยชอบด้วยกฎหมาย',
        ),
      ],
      editable: false,
    ),
  ];
