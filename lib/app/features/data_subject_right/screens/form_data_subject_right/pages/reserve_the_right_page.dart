import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:pdpa/app/config/config.dart';

import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';

class ReserveTheRightPage extends StatefulWidget {
  const ReserveTheRightPage({
    super.key,
  });

  @override
  State<ReserveTheRightPage> createState() => _ReserveTheRightPageState();
}

class _ReserveTheRightPageState extends State<ReserveTheRightPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: UiConfig.lineSpacing),
          CustomContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  tr('dataSubjectRight.reserveTheRight.title'), 
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        tr('dataSubjectRight.reserveTheRight.subtitle'), 
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                       tr('dataSubjectRight.reserveTheRight.decription'), 
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
