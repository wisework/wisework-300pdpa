import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class PurposeCategorySetting extends StatefulWidget {
  const PurposeCategorySetting({
    super.key,
    required this.purposeCategory,
  });

  final PurposeCategoryModel purposeCategory;

  @override
  State<PurposeCategorySetting> createState() => _PurposeCategorySettingState();
}

class _PurposeCategorySettingState extends State<PurposeCategorySetting> {
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();

    descriptionController = TextEditingController(
      text: widget.purposeCategory.description.first.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                widget.purposeCategory.title.first.text,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'Description',
            required: true,
          ),
          CustomTextField(
            controller: descriptionController,
            hintText: 'Enter description',
          ),
        ],
      ),
    );
  }
}
