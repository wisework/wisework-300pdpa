import 'package:flutter/material.dart';

class EditDataSubjectRight extends StatelessWidget {
  const EditDataSubjectRight({
    super.key,
    required this.dataSubjectRightId,
  });

  final String dataSubjectRightId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(
        'Edit DSR $dataSubjectRightId',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
