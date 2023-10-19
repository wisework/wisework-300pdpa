import 'dart:ui' as ui;

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/features/consent_management/consent_form/cubit/current_consent_form_settings/current_consent_form_settings_cubit.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UrlTab extends StatefulWidget {
  const UrlTab({
    super.key,
    required this.consentForm,
    required this.companyId,
  });

  final ConsentFormModel consentForm;
  final String companyId;

  @override
  State<UrlTab> createState() => _UrlTabState();
}

class _UrlTabState extends State<UrlTab> {
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
          const SizedBox(height: UiConfig.lineSpacing),
          _buildUrlSection(context),
          const SizedBox(height: UiConfig.lineSpacing),
          _buildQrCodeSection(context),
          const SizedBox(height: UiConfig.lineSpacing),
        ],
      ),
    );
  }

  CustomContainer _buildUrlSection(BuildContext context) {
    return CustomContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'URL ลิงค์แบบฟอร์ม', //!
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Row(
            children: <Widget>[
              Expanded(
                child: CustomTextField(
                  controller: TextEditingController(
                    text: widget.consentForm.consentFormUrl,
                  ),
                  readOnly: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: CustomIconButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: widget.consentForm.consentFormUrl),
                    );

                    BotToast.showText(
                      text: 'URL Copied', //!
                      contentColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.75),
                      borderRadius: BorderRadius.circular(8.0),
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                              color: Theme.of(context).colorScheme.onPrimary),
                      duration: UiConfig.toastDuration,
                    );
                  },
                  icon: Ionicons.copy_outline,
                  iconColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'If you have a problem with URL, Click ', //!
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                  text: 'here', //!
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: Theme.of(context).colorScheme.primary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      final url = UtilFunctions.getUserConsentForm(
                        widget.consentForm.id,
                        widget.companyId,
                      );
                      final cubit =
                          context.read<CurrentConsentFormSettingsCubit>();
                      cubit.generateConsentFormUrl(url);
                    },
                ),
                TextSpan(
                  text: ' to regenerate a new one.', //!
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  CustomContainer _buildQrCodeSection(BuildContext context) {
    return CustomContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'QR Code ลิงค์แบบฟอร์ม', //!
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          _buildQrImageView(widget.consentForm.consentFormUrl),
          const SizedBox(height: UiConfig.lineSpacing),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220.0),
            child: CustomButton(
              height: 40.0,
              onPressed: () async {
                await _downloadQrCode().then((value) {
                  if (value) {
                    BotToast.showText(
                      text: 'QR code has been downloaded', //!
                      contentColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.75),
                      borderRadius: BorderRadius.circular(8.0),
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                              color: Theme.of(context).colorScheme.onPrimary),
                      duration: UiConfig.toastDuration,
                    );
                  } else {
                    BotToast.showText(
                      text: 'Failed to download QR code', //!
                      contentColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.75),
                      borderRadius: BorderRadius.circular(8.0),
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                              color: Theme.of(context).colorScheme.onPrimary),
                      duration: UiConfig.toastDuration,
                    );
                  }
                });
              },
              buttonType: CustomButtonType.outlined,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                    child: Icon(
                      Ionicons.download_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Download', //!
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  RepaintBoundary _buildQrImageView(String url) {
    return RepaintBoundary(
      key: qrCodeKey,
      child: QrImageView(
        data: url,
        size: 220.0,
        backgroundColor: Colors.white,
        version: QrVersions.auto,
      ),
    );
  }
}
