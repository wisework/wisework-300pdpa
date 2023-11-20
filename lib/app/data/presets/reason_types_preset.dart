import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';

final List<ReasonTypeModel> reasonTypesPreset = [
  ReasonTypeModel.empty().copyWith(
    id: 'DSR-RES-001',
    reasonCode: '',
    description: const [
      LocalizedModel(
        language: 'en-US',
        text: "",
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
    reasonCode: '',
    description: const [
      LocalizedModel(
        language: 'en-US',
        text: "",
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
    reasonCode: '',
    description: const [
      LocalizedModel(
        language: 'en-US',
        text: "",
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
    reasonCode: '',
    description: const [
      LocalizedModel(
        language: 'en-US',
        text: "",
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'เหตุผลอื่นๆ โปรดระบุ',
      ),
    ],
    requiredInputReasonText: false,
    editable: false,
  ),
];
