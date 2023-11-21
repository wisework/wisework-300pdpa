import 'package:flutter/material.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

class DataSubjectRightStatus extends StatefulWidget {
  const DataSubjectRightStatus({
    super.key,
    required this.status,
  });

  final ProcessDataSubjectRightStatus status;

  @override
  State<DataSubjectRightStatus> createState() => _DataSubjectRightStatusState();
}

class _DataSubjectRightStatusState extends State<DataSubjectRightStatus> {
  final Map<ProcessDataSubjectRightStatus, String> requestProcessNames = {
    ProcessDataSubjectRightStatus.notStarted: 'Not started',
    ProcessDataSubjectRightStatus.inProgress: 'In Progress',
    ProcessDataSubjectRightStatus.completed: 'Completed',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 2.0,
        horizontal: 10.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.circle,
            size: 10.0,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 5.0),
          Text(
            requestProcessNames[widget.status].toString(),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
