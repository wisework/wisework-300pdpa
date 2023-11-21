import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/request_action_model.dart';

final List<RequestActionModel> requestActionsPreset = [
  RequestActionModel.empty().copyWith(
    id: 'DSR-REA-001',
    title: const [
      LocalizedModel(
        language: 'en-US',
        text: "Delete",
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'ลบ',
      ),
    ],
    priority: 1,
  ),
  RequestActionModel.empty().copyWith(
    id: 'DSR-REA-002',
    title: const [
      LocalizedModel(
        language: 'en-US',
        text: "Destroy",
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'ทำลาย',
      ),
    ],
    priority: 2,
  ),
  RequestActionModel.empty().copyWith(
    id: 'DSR-REA-003',
    title: const [
      LocalizedModel(
        language: 'en-US',
        text: "This makes the information non-personally identifiable.",
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'ทำให้ข้อมูลไม่สามารถระบุถึงตัวตนได้',
      ),
    ],
    priority: 3,
  ),
];
