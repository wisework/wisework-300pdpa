import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/features/data_subject_right/widgets/data_subject_right_status.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';

class DataSubjectRightCard extends StatelessWidget {
  const DataSubjectRightCard({
    super.key,
    required this.dataSubjectRight,
    required this.processRequest,
  });

  final DataSubjectRightModel dataSubjectRight;
  final ProcessRequestModel processRequest;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onBackground,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.outline,
            blurRadius: 6.0,
            offset: const Offset(0, 4.0),
          ),
        ],
      ),
      child: MaterialInkWell(
        hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        onTap: () {
          String path = DataSubjectRightRoute.editDataSubjectRight.path;
          path = path.replaceFirst(':id1', dataSubjectRight.id);
          path = path.replaceFirst(':id2', processRequest.id);

          context.push(path);
        },
        child: Padding(
          padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: _buildProcessRequestInfo(context),
                  ),
                  Expanded(
                    flex: 1,
                    child: DataSubjectRightStatus(
                      status: UtilFunctions.getProcessRequestStatus(
                        processRequest,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'วันที่ยื่นคำร้อง',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: UiConfig.textLineSpacing),
                        Text(
                          dateFormatter.format(dataSubjectRight.createdDate),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'วันครบกำหนด',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: UiConfig.textLineSpacing),
                        Text(
                          dateFormatter
                              .format(dataSubjectRight.requestExpirationDate),
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildProcessRequestInfo(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          processRequest.requestType,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
          overflow: TextOverflow.ellipsis,
        ),
        Visibility(
          visible: dataSubjectRight.dataRequester.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(
              top: UiConfig.textLineSpacing,
            ),
            child: Text(
              dataSubjectRight.dataRequester.first.text,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
