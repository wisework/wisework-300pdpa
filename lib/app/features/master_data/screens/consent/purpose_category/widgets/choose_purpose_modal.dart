import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/etc/updated_return.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';

class ChoosePurposeModal extends StatefulWidget {
  const ChoosePurposeModal({
    super.key,
    required this.initialPurposes,
    required this.purposes,
    required this.onChanged,
    required this.onUpdated,
  });

  final List<PurposeModel> initialPurposes;
  final List<PurposeModel> purposes;
  final Function(List<PurposeModel> purposes) onChanged;
  final Function(UpdatedReturn<PurposeModel> purpose) onUpdated;

  @override
  State<ChoosePurposeModal> createState() => _ChoosePurposeModalState();
}

class _ChoosePurposeModalState extends State<ChoosePurposeModal> {
  late List<PurposeModel> purposes;
  late List<PurposeModel> selectPurposes;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    purposes = widget.purposes.map((purpose) => purpose).toList();
    selectPurposes = widget.initialPurposes.map((purpose) => purpose).toList();
  }

  void _selectPurpose(PurposeModel purpose) {
    final selectIds = selectPurposes.map((selected) => selected.id).toList();

    setState(() {
      if (selectIds.contains(purpose.id)) {
        selectPurposes = selectPurposes
            .where((selected) => selected.id != purpose.id)
            .toList();
      } else {
        selectPurposes = selectPurposes.map((selected) => selected).toList()
          ..add(purpose);
      }
    });

    widget.onChanged(selectPurposes);
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
                    tr('masterData.cm.purpose.list'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200.0),
                  child: _buildAddButton(context),
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
            itemCount: purposes.length,
            itemBuilder: (_, index) {
              if (purposes.isEmpty) {
                return Text(
                  tr('masterData.cm.purposeCategory.noData'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ); //!
              }
              return Column(
                children: <Widget>[
                  _buildCheckBoxListTile(
                    context,
                    purpose: purposes[index],
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
    required PurposeModel purpose,
  }) {
    const language = 'en-US';
    final description = purpose.description.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );

    final selectIds = selectPurposes.map((category) => category.id).toList();

    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 4.0,
            right: UiConfig.actionSpacing,
          ),
          child: CustomCheckBox(
            value: selectIds.contains(purpose.id),
            onChanged: (_) {
              _selectPurpose(purpose);
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
        await context.push(MasterDataRoute.createPurpose.path).then((value) {
          if (value != null) {
            final updated = value as UpdatedReturn<PurposeModel>;

            purposes = purposes..add(updated.object);
            _selectPurpose(updated.object);

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
