import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';

class CustomFieldScreen extends StatelessWidget {
  const CustomFieldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomFieldView();
  }
}

class CustomFieldView extends StatefulWidget {
  const CustomFieldView({super.key});

  @override
  State<CustomFieldView> createState() => _CustomFieldViewState();
}

class _CustomFieldViewState extends State<CustomFieldView> {
  // final customfield = [
  //  CustomFieldModel(
  //     id: '1',
  //     title: const [
  //       LocalizedText(language: 'en-US', text: 'title 1 EN'),
  //       LocalizedText(language: 'th-TH', text: 'title 1 TH'),
  //     ],
  //     inputType: 'Text',
  //     lengthLimit: 1,
  //     maxLines: 10,
  //     minLines: 1,
  //     placeholder: const [
  //       LocalizedText(language: 'en-US', text: 'placeholder 1 EN'),
  //       LocalizedText(language: 'th-TH', text: 'placeholder 1 TH'),
  //     ],
  //     uid: 'uid',
  //     language: 'en-US',
  //     companies: const [],
  //     status: ActiveStatus.active,
  //     createdBy: 'Admin',
  //     createdDate: DateTime.fromMillisecondsSinceEpoch(0),
  //     updatedBy: 'Admin',
  //     updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
  //   ),
  //   CustomFieldModel(
  //     id: '2',
  //     title: const [
  //       LocalizedText(language: 'en-US', text: 'Description 1 EN'),
  //       LocalizedText(language: 'th-TH', text: 'Description 1 TH'),
  //     ],
  //     inputType: 'Text',
  //     lengthLimit: 1,
  //     maxLines: 10,
  //     minLines: 1,
  //     placeholder: const [
  //       LocalizedText(language: 'en-US', text: 'Description 1 EN'),
  //       LocalizedText(language: 'th-TH', text: 'Description 1 TH'),
  //     ],
  //     uid: 'uid',
  //     language: 'en-US',
  //     companies: const [],
  //     status: ActiveStatus.active,
  //     createdBy: 'Admin',
  //     createdDate: DateTime.fromMillisecondsSinceEpoch(0),
  //     updatedBy: 'Admin',
  //     updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: UiConfig.lineSpacing),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              // child: ListView.builder(
              //   itemCount: customfield.length,
              //   itemBuilder: (context, index) {
              //     return _buildItemCard(
              //       context,
              //       customfield: customfield[index],
              //     );
              //   },
              // ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(MasterDataRoute.editCustomField.path);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // MasterDataItemCard _buildItemCard(
  //   BuildContext context, {
  //   required CustomFieldModel customfield,
  // }) {
  //   const language = 'en-US';
  //   final description = customfield.title.firstWhere(
  //     (item) => item.language == language,
  //     orElse: LocalizedText.empty,
  //   );
  //   final warningDescription = customfield.placeholder.firstWhere(
  //     (item) => item.language == language,
  //     orElse: LocalizedText.empty,
  //   );

  //   return MasterDataItemCard(
  //     title: description.text,
  //     subtitle: warningDescription.text,
  //     status: customfield.status,
  //   );
  // }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          CustomIconButton(
            onPressed: () {
              context.pop();
            },
            icon: Ionicons.arrow_back,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
          Text(tr('masterData.cm.customfields.name'))
        ],
      ),
      elevation: 1.0,
      shadowColor: Theme.of(context).colorScheme.background,
      surfaceTintColor: Theme.of(context).colorScheme.onBackground,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }
}
