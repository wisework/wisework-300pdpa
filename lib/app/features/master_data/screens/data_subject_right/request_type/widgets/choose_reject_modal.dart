import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/etc/updated_return.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';

class ChooseRejectTypeModal extends StatefulWidget {
  const ChooseRejectTypeModal({
    super.key,
    required this.initialRejectTypes,
    required this.rejectTypes,
    required this.onChanged,
    required this.onUpdated,
    required this.language,
  });

  final List<RejectTypeModel> initialRejectTypes;
  final List<RejectTypeModel> rejectTypes;
  final Function(List<RejectTypeModel> rejectTypes) onChanged;
  final Function(UpdatedReturn<RejectTypeModel> reject) onUpdated;
  final String language;

  @override
  State<ChooseRejectTypeModal> createState() => _ChooseRejectTypeModalState();
}

class _ChooseRejectTypeModalState extends State<ChooseRejectTypeModal> {
  late List<RejectTypeModel> rejectTypes;
  late List<RejectTypeModel> selectRejectTypes;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    rejectTypes = widget.rejectTypes
        .where((reject) => reject.status != ActiveStatus.inactive)
        .map((reject) => reject)
        .toList();
    selectRejectTypes = widget.initialRejectTypes
        .where((reject) => reject.status != ActiveStatus.inactive)
        .map((reject) => reject)
        .toList();
  }

  void _selectReject(RejectTypeModel reject) {
    final selectIds = selectRejectTypes.map((selected) => selected.id).toList();

    setState(() {
      if (selectIds.contains(reject.id)) {
        selectRejectTypes = selectRejectTypes
            .where((selected) => selected.id != reject.id)
            .toList();
      } else {
        selectRejectTypes =
            selectRejectTypes.map((selected) => selected).toList()..add(reject);
      }
    });

    widget.onChanged(selectRejectTypes);
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
                    tr('masterData.cm.reject.list'),
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
            itemCount: rejectTypes.length,
            itemBuilder: (_, index) {
              if (rejectTypes.isEmpty) {
                return Text(
                  tr('masterData.cm.rejectCategory.noData'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ); //!
              }
              return Column(
                children: <Widget>[
                  _buildCheckBoxListTile(
                    context,
                    reject: rejectTypes[index],
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
    required RejectTypeModel reject,
    required String language,
  }) {
    final description = reject.description.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );

    final selectIds = selectRejectTypes.map((category) => category.id).toList();

    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 4.0,
            right: UiConfig.actionSpacing,
          ),
          child: CustomCheckBox(
            value: selectIds.contains(reject.id),
            onChanged: (_) {
              _selectReject(reject);
            },
          ),
        ),
        Expanded(
          child: Text(
            description.text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  CustomIconButton _buildAddButton(BuildContext context) {
    return CustomIconButton(
      onPressed: () async {
        await context.push(MasterDataRoute.createRejectType.path).then((value) {
          if (value != null) {
            final updated = value as UpdatedReturn<RejectTypeModel>;

            rejectTypes = rejectTypes..add(updated.object);
            _selectReject(updated.object);

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
