import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';

class ChoosePurposeModal extends StatelessWidget {
  const ChoosePurposeModal({
    super.key,
    required this.purposes,
  });

  final List<PurposeModel> purposes;

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

  SingleChildScrollView _buildModalContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: UiConfig.defaultPaddingSpacing,
            ),
            child: Row(
              children: <Widget>[
                Text(
                  tr(
                    'masterData.cm.purposeCategory.purposeList',
                  ),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ), //!
          const SizedBox(height: UiConfig.lineSpacing),
          Padding(
            padding: const EdgeInsets.only(
              left: 2.0,
              right: UiConfig.defaultPaddingSpacing,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: purposes.length,
              itemBuilder: (_, index) {
                if (purposes.isEmpty) {
                  return Text(
                    'masterData.cm.purposeCategory.noData',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ); //!
                }
                return _buildCheckBoxListTile(context, purposes[index]);
              },
            ),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: UiConfig.defaultPaddingSpacing,
            ),
            child: _buildCreatePurposeButton(context),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
        ],
      ),
    );
  }

  CheckboxListTile _buildCheckBoxListTile(
    BuildContext context,
    PurposeModel purpose,
  ) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(
        purpose.description.first.text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      value: false,
      onChanged: (bool? newValue) {
        // cubit.choosePurposeCategorySelected(item.id);
        // _setPurpose(cubit.state.purposes);
      },
    );
  }

  Widget _buildCreatePurposeButton(BuildContext context) {
    return MaterialInkWell(
      onTap: () async {
        context.push(MasterDataRoute.createPurpose.path);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Icon(
                Ionicons.add,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: UiConfig.actionSpacing + 11),
            Expanded(
              child: Text(
                tr('masterData.cm.purposeCategory.addnewPurpose'), //!
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
