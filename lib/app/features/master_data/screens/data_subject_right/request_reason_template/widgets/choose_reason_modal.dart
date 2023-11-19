import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/etc/updated_return.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';

class ChooseReasonModal extends StatefulWidget {
  const ChooseReasonModal({
    super.key,
    required this.initialReasons,
    required this.reasons,
    required this.onChanged,
    required this.onUpdated,
    required this.language,
  });

  final List<ReasonTypeModel> initialReasons;
  final List<ReasonTypeModel> reasons;
  final Function(List<ReasonTypeModel> reasons) onChanged;
  final Function(UpdatedReturn<ReasonTypeModel> reason) onUpdated;
  final String language;

  @override
  State<ChooseReasonModal> createState() => _ChooseReasonModalState();
}

class _ChooseReasonModalState extends State<ChooseReasonModal> {
  late List<ReasonTypeModel> reasons;
  late List<ReasonTypeModel> selectReasons;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    reasons = widget.reasons
        .where((reason) => reason.status != ActiveStatus.inactive)
        .map((reason) => reason)
        .toList();
    selectReasons = widget.initialReasons
        .where((reason) => reason.status != ActiveStatus.inactive)
        .map((reason) => reason)
        .toList();
  }

  void _selectReason(ReasonTypeModel reason) {
    final selectIds = selectReasons.map((selected) => selected.id).toList();

    setState(() {
      if (selectIds.contains(reason.id)) {
        selectReasons = selectReasons
            .where((selected) => selected.id != reason.id)
            .toList();
      } else {
        selectReasons = selectReasons.map((selected) => selected).toList()
          ..add(reason);
      }
    });

    widget.onChanged(selectReasons);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(top: UiConfig.lineSpacing),
            child: _buildModalContent(context),
          ),
        ),
      ),
    );
  }

  Column _buildModalContent(BuildContext context) {
    return Column(
      children: <Widget>[
        Material(
          elevation: 1.0,
          color: Theme.of(context).colorScheme.onBackground,
          child: Padding(
            padding: const EdgeInsets.only(
              left: UiConfig.defaultPaddingSpacing,
              right: UiConfig.defaultPaddingSpacing,
              bottom: UiConfig.lineGap,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    tr('masterData.cm.reason.list'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200.0),
                  child: _buildAddButton(context),
                ),
                const SizedBox(width: UiConfig.defaultPaddingSpacing),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 95.0),
                  child: CustomButton(
                    height: 40.0,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      tr('app.done'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ), //!
        const SizedBox(height: UiConfig.lineSpacing),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: UiConfig.defaultPaddingSpacing,
            ),
            itemCount: reasons.length,
            itemBuilder: (_, index) {
              if (reasons.isEmpty) {
                return Text(
                  tr('masterData.cm.reasonCategory.noData'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ); //!
              }
              return Column(
                children: <Widget>[
                  _buildCheckBoxListTile(
                    context,
                    reason: reasons[index],
                    language: widget.language,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    child: Divider(
                      color: Theme.of(context)
                          .colorScheme
                          .outlineVariant
                          .withOpacity(0.5),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Row _buildCheckBoxListTile(
    BuildContext context, {
    required ReasonTypeModel reason,
    required String language,
  }) {
    final description = reason.description.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    ) !=
            ''
        ? reason.description.last.text
        : '';

    final selectIds = selectReasons.map((category) => category.id).toList();

    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 4.0,
            right: UiConfig.actionSpacing,
          ),
          child: CustomCheckBox(
            value: selectIds.contains(reason.id),
            onChanged: (_) {
              _selectReason(reason);
            },
          ),
        ),
        Expanded(
          child: Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  CustomIconButton _buildAddButton(BuildContext context) {
    return CustomIconButton(
      onPressed: () async {
        await context.push(MasterDataRoute.createReasonType.path).then((value) {
          if (value != null) {
            final updated = value as UpdatedReturn<ReasonTypeModel>;

            reasons = reasons..add(updated.object);
            _selectReason(updated.object);

            widget.onUpdated(updated);
          }
        });
      },
      icon: Ionicons.add,
      iconColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }
}
