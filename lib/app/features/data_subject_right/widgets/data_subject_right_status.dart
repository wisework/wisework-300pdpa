import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

class DataSubjectRightStatus extends StatefulWidget {
  const DataSubjectRightStatus({
    super.key,
    required this.status,
  });

  final RequestProcessStatus status;

  @override
  State<DataSubjectRightStatus> createState() => _DataSubjectRightStatusState();
}

class _DataSubjectRightStatusState extends State<DataSubjectRightStatus> {
  final Map<RequestProcessStatus, String> requestProcessNames = {
    RequestProcessStatus.newRequest: tr('dataSubjectRight.status.newRequest'),
    RequestProcessStatus.pending: tr('dataSubjectRight.status.pending'),
    RequestProcessStatus.rejected: tr('dataSubjectRight.status.rejected'),
    RequestProcessStatus.considering: tr('dataSubjectRight.status.considering'),
    RequestProcessStatus.inProgress: tr('dataSubjectRight.status.inProgress'),
    RequestProcessStatus.completed: tr('dataSubjectRight.status.completed'),
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
