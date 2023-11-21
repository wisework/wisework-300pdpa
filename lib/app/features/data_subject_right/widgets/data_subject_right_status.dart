import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

class DataSubjectRightStatus extends StatefulWidget {
  const DataSubjectRightStatus({
    super.key,
    required this.status,
  });

  final ProcessRequestStatus status;

  @override
  State<DataSubjectRightStatus> createState() => _DataSubjectRightStatusState();
}

class _DataSubjectRightStatusState extends State<DataSubjectRightStatus> {
  final Map<ProcessRequestStatus, String> statusTexts = {
    ProcessRequestStatus.notProcessed: 'ยังไม่ดำเนินการ',
    ProcessRequestStatus.inProgress: 'อยู่ระหว่างการดำเนินการ',
    ProcessRequestStatus.refused: 'ปฏิเสธการดำเนินการ',
    ProcessRequestStatus.completed: 'ดำเนินการเสร็จสิ้น',
  };
  final Map<ProcessRequestStatus, Color> statusColors = {
    ProcessRequestStatus.notProcessed: const Color(0xFF878787),
    ProcessRequestStatus.inProgress: const Color(0xFF0172E6),
    ProcessRequestStatus.refused: const Color(0xFFDF2200),
    ProcessRequestStatus.completed: const Color(0xFF4FC1B1),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 6.0,
        horizontal: 12.0,
      ),
      decoration: BoxDecoration(
        color: statusColors[widget.status]?.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.circle,
            size: 6.0,
            color: statusColors[widget.status],
          ),
          const SizedBox(width: UiConfig.actionSpacing),
          Expanded(
            child: Text(
              statusTexts[widget.status].toString(),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}
