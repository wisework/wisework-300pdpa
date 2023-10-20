import 'dart:ui' as ui;
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:pdpa/app/config/config.dart';

import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';

import 'package:pdpa/app/features/consent_management/consent_form/widgets/consent_form_preview.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';

import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';

import 'package:qr_flutter/qr_flutter.dart';

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
  final GlobalKey qrCodeKey = GlobalKey();
  Future<bool> _downloadQrCode() async {
    final boundary =
        qrCodeKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    final qrCodeImage = await boundary?.toImage();

    if (qrCodeImage != null) {
      final byteData = await qrCodeImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      final bytes = byteData!.buffer.asUint8List();

      await ImageGallerySaver.saveImage(bytes);

      return true;
    }
    return false;
  }

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
                                      Theme.of(context).colorScheme.background,
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
                              await _downloadQrCode().then((value) {
                                if (value) {
                                  BotToast.showText(
                                    text: 'QR code has been downloaded',
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
                                    text: 'Failed to download QR code',
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
                                text: 'URL Copied',
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
                  child: ConsentFormPreview(
                    consentForm: widget.consentForm,
                    mandatoryFields: widget.mandatoryFields,
                    purposeCategories: widget.purposeCategories,
                    purposes: widget.purposes,
                    customFields: widget.customFields,
                    consentTheme: widget.consentTheme,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
