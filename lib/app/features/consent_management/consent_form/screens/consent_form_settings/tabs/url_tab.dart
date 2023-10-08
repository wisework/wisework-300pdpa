import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UrlTab extends StatelessWidget {
  const UrlTab({
    super.key,
    required this.consentForm,
  });

  final ConsentFormModel consentForm;

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
                'URL ลิงค์แบบฟอร์ม',
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
                    text: consentForm.consentFormUrl,
                  ),
                  readOnly: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: CustomIconButton(
                  onPressed: () {},
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
                  text: 'If you have a problem with URL, Click ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                  text: 'here',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: Theme.of(context).colorScheme.primary),
                ),
                TextSpan(
                  text: ' to regenerate a new one.',
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
                'QR Code ลิงค์แบบฟอร์ม',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          QrImageView(
            data: consentForm.consentFormUrl,
            version: QrVersions.auto,
            size: 220.0,
            // embeddedImage: const AssetImage(
            //   'assets/images/wisework-logo.png',
            // ),
            // embeddedImageStyle: const QrEmbeddedImageStyle(
            //   size: Size(120.0, 0),
            // ),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220.0),
            child: CustomButton(
              height: 40.0,
              onPressed: () {},
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
                    'Download',
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
}
