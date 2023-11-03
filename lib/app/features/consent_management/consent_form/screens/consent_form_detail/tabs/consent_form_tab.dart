import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/consent_management/consent_form/widgets/consent_form_preview.dart';

import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:pdpa/app/features/consent_management/consent_form/widgets/download_fuctions/netive_download.dart'
    if (dart.library.html) 'package:pdpa/app/features/consent_management/consent_form/widgets/download_fuctions/web_download.dart'
    // ignore: library_prefixes
    as downloadQrCode;

class ConsentFormTab extends StatefulWidget {
  const ConsentFormTab({
    super.key,
    required this.consentForm,
    required this.mandatoryFields,
    required this.purposeCategories,
    required this.purposes,
    required this.customFields,
    required this.consentTheme,
  });

  final ConsentFormModel consentForm;
  final List<MandatoryFieldModel> mandatoryFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;
  final List<CustomFieldModel> customFields;
  final ConsentThemeModel consentTheme;

  @override
  State<ConsentFormTab> createState() => _ConsentFormTabState();
}

class _ConsentFormTabState extends State<ConsentFormTab> {
  final qrCodeKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: UiConfig.lineSpacing),
          CustomContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(UiConfig.textLineSpacing),
                  child: Text(
                      tr(
                          "consentManagement.consentForm.consentFormDetails.form.shareLinkForm"),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface)),
                ),
                Padding(
                  padding: const EdgeInsets.all(UiConfig.textLineSpacing),
                  child: Text(
                      tr(
                          "consentManagement.consentForm.consentFormDetails.form.descriptionShare"),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: UiConfig.lineSpacing),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onPrimary,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  width: 1.0,
                                  color:
                                      Theme.of(context).colorScheme.primary,
                                )),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                child: Column(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: RepaintBoundary(
                                        key: qrCodeKey,
                                        child: QrImageView(
                                          data:
                                              widget.consentForm.consentFormUrl,
                                          size: 160,
                                          backgroundColor: Colors.white,
                                          version: QrVersions.auto,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: IconButton(
                            onPressed: () async {
                              // downloadQrCode.downloadQrcode(qrKey);
                              await downloadQrCode
                                  .downloadQrCode(qrCodeKey)
                                  .then((value) {
                                if (value) {
                                  BotToast.showText(
                                    text: tr(
                                        'consentManagement.consentForm.urltab.qrCodeHasBeenDownloaded'),
                                    contentColor: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.75),
                                    borderRadius: BorderRadius.circular(8.0),
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                    duration: UiConfig.toastDuration,
                                  );
                                } else {
                                  BotToast.showText(
                                    text: tr(
                                        'consentManagement.consentForm.urltab.failedToDownloadQrCode'),
                                    contentColor: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.75),
                                    borderRadius: BorderRadius.circular(8.0),
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                    duration: UiConfig.toastDuration,
                                  );
                                }
                              });
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
                                  Icons.file_download_outlined,
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
                    const SizedBox(height: UiConfig.lineSpacing),
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
                              widget.consentForm.consentFormUrl,
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
                              Clipboard.setData(
                                ClipboardData(
                                    text: widget.consentForm.consentFormUrl),
                              );

                              BotToast.showText(
                                text: tr(
                                    'consentManagement.consentForm.urltab.urlCopied'),
                                contentColor: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.75),
                                borderRadius: BorderRadius.circular(8.0),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                duration: UiConfig.toastDuration,
                              );
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
                    const SizedBox(height: UiConfig.lineSpacing),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          CustomContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: UiConfig.lineSpacing),
                Text(tr("consentManagement.consentForm.formExample"),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface)),
                const SizedBox(height: UiConfig.lineSpacing),
                SingleChildScrollView(
                  child: ConsentFormPreview(
                    consentForm: widget.consentForm,
                    mandatoryFields: widget.mandatoryFields,
                    purposeCategories: widget.purposeCategories,
                    purposes: widget.purposes,
                    customFields: widget.customFields,
                    consentTheme: widget.consentTheme,
                  ),
                ),
                const SizedBox(height: UiConfig.lineSpacing),
              ],
            ),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
        ],
      ),
    );
  }
}
