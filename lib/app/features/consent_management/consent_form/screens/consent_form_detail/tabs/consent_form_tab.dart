import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/consent_management/consent_form/widgets/preview/purpose_radio_option.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ConsentFormTab extends StatelessWidget {
  const ConsentFormTab({
    super.key,
    required this.consentForm,
    required this.customFields,
    required this.purposeCategories,
    required this.purposes,
    required this.consentTheme,
  });

  final ConsentFormModel consentForm;
  final List<CustomFieldModel> customFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;
  final ConsentThemeModel consentTheme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          CustomContainer(
            margin: const EdgeInsets.only(top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text("แชร์ลิงค์แบบฟอร์ม",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                      "สามารถใช้แบบฟอร์มนี้ในการเก็บข้อมูลจากผู้ใช้งานด้วยการเปิดลิงค์ หรือ การแสกน QR Code",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: QrImageView(
                        data: consentForm.consentFormUrl,
                        size: 150,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 12.0,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                width: 1.0,
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                            child: Text(
                              consentForm.consentFormUrl,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: IconButton(
                            onPressed: () {
                              if (consentForm.linkToPolicyUrl.isNotEmpty) {
                                Clipboard.setData(ClipboardData(
                                    text: consentForm.consentFormUrl));
                                BotToast.showText(text: "URL copied");
                              } else {
                                BotToast.showText(text: "URL copy fail");
                              }
                            },
                            icon: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.content_copy_outlined,
                                  size: 28,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          CustomContainer(
            margin: const EdgeInsets.only(top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text("ตัวอย่างแบบฟอร์ม",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface)),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding:
                        const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
                    decoration: BoxDecoration(
                      color: consentTheme.backgroundColor,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: consentTheme.bodyBackgroundColor,
                      ),
                      child: Column(
                        children: <Widget>[
                          Visibility(
                            visible: consentForm.logoImage.isNotEmpty ||
                                consentForm.headerBackgroundImage.isNotEmpty,
                            child: _buildHeaderImage(),
                          ),
                          _buildConsentForm(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _buildHeaderImage() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: consentTheme.headerBackgroundColor,
        image: consentForm.headerBackgroundImage.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(
                  consentForm.headerBackgroundImage,
                ),
                fit: BoxFit.fitWidth,
              )
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: UiConfig.lineSpacing,
        ),
        child: SizedBox(
          height: 90.0,
          child: Visibility(
            visible: consentForm.logoImage.isNotEmpty,
            child: Image.network(
              consentForm.logoImage,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Container _buildConsentForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
      decoration: BoxDecoration(
        image: consentForm.bodyBackgroundImage.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(
                  consentForm.bodyBackgroundImage,
                ),
                fit: BoxFit.fitHeight,
              )
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            consentForm.headerText.first.text,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: consentTheme.headerTextColor),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Align(
            alignment: Alignment.centerLeft,
            child: _buildHeaderDescription(context),
          ),
          _buildCustomFieldSection(context),
          _buildPurposeCategorySection(context),
          _buildFooterDescription(context),
          Row(
            children: <Widget>[
              CustomCheckBox(
                value: false,
                onChanged: (value) {},
                activeColor: consentTheme.actionButtonColor,
              ),
              const SizedBox(width: UiConfig.actionSpacing),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: consentForm.acceptConsentText.first.text,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: consentTheme.formTextColor),
                      ),
                      const WidgetSpan(
                        child: SizedBox(width: UiConfig.textSpacing),
                      ),
                      TextSpan(
                        text: consentForm.linkToPolicyText.first.text,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: consentTheme.linkToPolicyTextColor,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineGap * 2),
          CustomButton(
            height: 40.0,
            onPressed: () {},
            buttonColor: consentTheme.submitButtonColor,
            splashColor: consentTheme.submitTextColor,
            child: Text(
              consentForm.acceptText.first.text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: consentTheme.submitTextColor),
            ),
          ),
          const SizedBox(height: UiConfig.lineGap),
          CustomButton(
            height: 40.0,
            onPressed: () {},
            buttonColor: consentTheme.cancelButtonColor,
            splashColor: consentTheme.cancelTextColor,
            child: Text(
              consentForm.cancelText.first.text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: consentTheme.cancelTextColor),
            ),
          ),
        ],
      ),
    );
  }

  Visibility _buildHeaderDescription(BuildContext context) {
    return Visibility(
      visible: consentForm.headerDescription.first.text.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: UiConfig.lineSpacing,
        ),
        child: Text(
          consentForm.headerDescription.first.text,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: consentTheme.formTextColor),
        ),
      ),
    );
  }

  Visibility _buildFooterDescription(BuildContext context) {
    return Visibility(
      visible: consentForm.headerDescription.first.text.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(
            height: 0.1,
            color:
                Theme.of(context).colorScheme.outlineVariant.withOpacity(0.6),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: UiConfig.lineSpacing),
            child: Text(
              consentForm.footerDescription.first.text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: consentTheme.formTextColor),
            ),
          ),
          Divider(
            height: 0.1,
            color:
                Theme.of(context).colorScheme.outlineVariant.withOpacity(0.6),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
        ],
      ),
    );
  }

  Visibility _buildCustomFieldSection(BuildContext context) {
    final customFieldFiltered = UtilFunctions.filterCustomFieldsByIds(
      customFields,
      consentForm.customFields,
    );

    return Visibility(
      visible: customFieldFiltered.isNotEmpty,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: customFieldFiltered.length,
            itemBuilder: (context, index) => _buildCustomField(
              context,
              customField: customFieldFiltered[index],
            ),
            separatorBuilder: (context, _) => const SizedBox(
              height: UiConfig.lineSpacing,
            ),
          ),
          const SizedBox(height: UiConfig.lineSpacing)
        ],
      ),
    );
  }

  Column _buildCustomField(
    BuildContext context, {
    required CustomFieldModel customField,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TitleRequiredText(
          text: customField.title.first.text,
        ),
        CustomTextField(
          hintText: customField.hintText.first.text,
        ),
      ],
    );
  }

  Visibility _buildPurposeCategorySection(BuildContext context) {
    final purposeCategoryFiltered = UtilFunctions.filterPurposeCategoriesByIds(
      purposeCategories,
      consentForm.purposeCategories,
    );

    return Visibility(
      visible: purposeCategoryFiltered.isNotEmpty,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: purposeCategoryFiltered.length,
            itemBuilder: (context, index) => _buildPurposeCategory(
              context,
              index: index + 1,
              purposeCategory: purposeCategoryFiltered[index],
            ),
            separatorBuilder: (context, _) => Padding(
              padding: const EdgeInsets.symmetric(
                vertical: UiConfig.lineSpacing,
              ),
              child: Divider(
                height: 0.1,
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
        ],
      ),
    );
  }

  Row _buildPurposeCategory(
    BuildContext context, {
    required int index,
    required PurposeCategoryModel purposeCategory,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(11.0),
          decoration: BoxDecoration(
            color: consentTheme.categoryIconColor,
            shape: BoxShape.circle,
          ),
          child: Text(
            index.toString(),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        const SizedBox(width: UiConfig.actionSpacing),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 11.0),
              Text(
                purposeCategory.title.first.text,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: consentTheme.categoryTitleTextColor),
              ),
              const SizedBox(height: UiConfig.lineGap),
              Text(
                purposeCategory.description.first.text,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: consentTheme.formTextColor),
              ),
              const SizedBox(height: UiConfig.lineGap),
              _buildPurposeSection(
                context,
                purposeCategory: purposeCategory,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Visibility _buildPurposeSection(
    BuildContext context, {
    required PurposeCategoryModel purposeCategory,
  }) {
    final purposeFiltered = UtilFunctions.filterPurposeByIds(
      purposes,
      purposeCategory.purposes,
    );

    return Visibility(
      visible: purposeFiltered.isNotEmpty,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: purposeFiltered.length - 1,
            itemBuilder: (context, index) => PurposeRadioOption(
              purpose: purposeFiltered[index],
              consentTheme: consentTheme,
            ),
            separatorBuilder: (context, _) => const SizedBox(
              height: UiConfig.lineSpacing,
            ),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
        ],
      ),
    );
  }
}
