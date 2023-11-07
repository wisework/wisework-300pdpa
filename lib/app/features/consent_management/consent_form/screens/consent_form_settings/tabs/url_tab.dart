import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/features/consent_management/consent_form/cubit/current_consent_form_settings/current_consent_form_settings_cubit.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/utils/toast.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:pdpa/app/features/consent_management/consent_form/widgets/download_fuctions/netive_download.dart'
    if (dart.library.html) 'package:pdpa/app/features/consent_management/consent_form/widgets/download_fuctions/web_download.dart'
    // ignore: library_prefixes
    as downloadQrCode;

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
                tr('consentManagement.consentForm.urltab.formLinkURL'), //!
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

                    showToast(
                      context,
                      text: tr(
                        'consentManagement.consentForm.urltab.urlCopied',
                      ),
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
                  text: tr(
                      'consentManagement.consentForm.urltab.description'), //!
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                  text: tr('consentManagement.consentForm.urltab.here'), //!
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: Theme.of(context).colorScheme.primary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      final url = UtilFunctions.getUserConsentFormUrl(
                        widget.consentForm.id,
                        widget.companyId,
                      );
                      final cubit =
                          context.read<CurrentConsentFormSettingsCubit>();
                      cubit.generateConsentFormUrl(url);
                    },
                ),
                TextSpan(
                  text: tr(
                      'consentManagement.consentForm.urltab.toRegenerateANewOne'), //!
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
                tr('consentManagement.consentForm.urltab.qrCodeFormLink'),
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
                await downloadQrCode.downloadQrCode(qrCodeKey).then((value) {
                  if (value) {
                    showToast(
                      context,
                      text: tr(
                        'consentManagement.consentForm.urltab.qrCodeHasBeenDownloaded',
                      ),
                    );
                  } else {
                    showToast(
                      context,
                      text: tr(
                        'consentManagement.consentForm.urltab.failedToDownloadQrCode',
                      ),
                    );
                  }
                });
              },
              buttonType: CustomButtonType.outlined,
              backgroundColor: Theme.of(context).colorScheme.onBackground,
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
                    tr('consentManagement.consentForm.urltab.download'), //!
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
