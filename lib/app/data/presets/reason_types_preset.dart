import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';

final List<ReasonTypeModel> reasonTypesPreset = [
  ReasonTypeModel.empty().copyWith(
    id: 'DSR-RES-001',
    reasonCode: 'RES-001',
    description: const [
      LocalizedModel(
        language: 'en-US',
        text:
            "It is under investigation as the owner of personal data requests the company to correct personal data.",
      ),
      LocalizedModel(
        language: 'th-TH',
        text:
            'อยู่ในระหว่างการตรวจสอบตามที่เจ้าของข้อมูลส่วนบุคคลร้องขอให้บริษัทแก้ไขข้อมูลส่วนบุคคล',
      ),
    ],
    requiredInputReasonText: false,
    editable: false,
  ),
  ReasonTypeModel.empty().copyWith(
    id: 'DSR-RES-002',
    reasonCode: 'RES-002',
    description: const [
      LocalizedModel(
        language: 'en-US',
        text:
            "It is personal information that must be deleted or destroyed. Because it is an unlawful processing of personal data, but the owner of the personal data wishes to request that the use be suspended instead.",
      ),
      LocalizedModel(
        language: 'th-TH',
        text:
            'เป็นข้อมูลส่วนบุคคลที่ต้องลบหรือทำลาย เพราะเป็นการประมวลผลข้อมูลส่วนบุคคลโดยไม่ชอบด้วยกฎหมายแต่เจ้าของข้อมูลส่วนบุคคลประสงค์ขอให้ระงับการใช้แทน',
      ),
    ],
    requiredInputReasonText: false,
    editable: false,
  ),
  ReasonTypeModel.empty().copyWith(
    id: 'DSR-RES-003',
    reasonCode: 'RES-003',
    description: const [
      LocalizedModel(
        language: 'en-US',
        text:
            "Personal data is no longer necessary to be kept for the purpose of processing, but the owner of the personal data is required to request its retention in order to establish legal claims, comply with the law, or exercise rights. Legal claim",
      ),
      LocalizedModel(
        language: 'th-TH',
        text:
            'ข้อมูลส่วนบุคคลหมดความจำเป็นในการเก็บรักษาไว้ตามวัตถุประสงค์ในการประมวลผลแต่เจ้าของข้อมูลส่วนบุคคลมีความจำเป็นต้องขอให้เก็บรักษาไว้เพื่อใช้ในการก่อตั้งสิทธิเรียกร้องตามกฎหมายการปฏิบัติตามหรือการใช้สิทธิเรียกร้องตามกฎหมาย หรือการยกขึ้นต่อสู้สิทธิเรียกร้องตามกฎหมาย',
      ),
    ],
    requiredInputReasonText: false,
    editable: false,
  ),
  ReasonTypeModel.empty().copyWith(
    id: 'DSR-RES-004',
    reasonCode: 'RES-004',
    description: const [
      LocalizedModel(
        language: 'en-US',
        text: "Other reasons, please specify.",
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'เหตุผลอื่นๆ โปรดระบุ',
      ),
    ],
    requiredInputReasonText: true,
    editable: false,
  ),
];
