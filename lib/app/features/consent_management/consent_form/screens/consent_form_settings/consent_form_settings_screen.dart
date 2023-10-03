import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/features/consent_management/consent_form/screens/consent_form_settings/widgets/consent_form_drawer.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ConsentFormSettingScreen extends StatelessWidget {
  const ConsentFormSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ConsentFormSettingView();
  }
}

class ConsentFormSettingView extends StatefulWidget {
  const ConsentFormSettingView({super.key});

  @override
  State<ConsentFormSettingView> createState() => _ConsentFormSettingViewState();
}

class _ConsentFormSettingViewState extends State<ConsentFormSettingView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final consentTheme = ConsentThemeModel(
    id: '',
    title: 'Meow theme',
    headerTextColor: 'ff0a6152',
    headerBackgroundColor: 'ffffffff',
    bodyBackgroundColor: 'ffffffff',
    formTextColor: 'ff0a6152',
    categoryTitleTextColor: 'ff0a6152',
    acceptConsentTextColor: 'ff0a6152',
    linkToPolicyTextColor: 'ff0a6152',
    acceptButtonColor: 'ff0a6152',
    acceptTextColor: 'ffffffff',
    cancelButtonColor: 'ffffffff',
    cancelTextColor: 'ff0a6152',
    actionButtonColor: 'ff0a6152',
    createdBy: 'meow@gmail.com',
    createdDate: DateTime.now(),
    updatedBy: 'meow@gmail.com',
    updatedDate: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PdpaAppBar(
          leadingIcon: CustomIconButton(
            onPressed: () {
              context.pop();
            },
            icon: Ionicons.chevron_back_outline,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
          title: Text(
            'Consent Form Settings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            CustomIconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
              icon: Ionicons.eye_outline,
              iconColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.onBackground,
            ),
          ],
          bottom: TabBar(
            tabs: const [
              Tab(text: 'URL'),
              Tab(text: 'Header'),
              Tab(text: 'Body'),
              Tab(text: 'Footer'),
              Tab(text: 'Theme'),
            ],
            // isScrollable: true,
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Theme.of(context).colorScheme.primary,
            labelStyle: Theme.of(context).textTheme.bodySmall,
          ),
          appBarHeight: 100.0,
        ),
        body: TabBarView(
          children: <Widget>[
            _buildUrlTab(),
            _buildHeaderTab(),
            _buildBodyTab(),
            _builFooterTab(),
            _buildThemeTab(),
          ],
        ),
        endDrawer: const ConsentFormDrawer(),
      ),
    );
  }

  Column _buildUrlTab() {
    return Column(
      children: <Widget>[
        const SizedBox(height: UiConfig.lineSpacing),
        CustomContainer(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'URL ลิงค์แบบฟอร์ม',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              Row(
                children: <Widget>[
                  Expanded(
                    child: CustomTextField(
                      controller:
                          TextEditingController(text: 'https://bit.ly/3y4LjmA'),
                      readOnly: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: CustomIconButton(
                      onPressed: () {},
                      icon: Ionicons.copy_outline,
                      iconColor: Theme.of(context).colorScheme.primary,
                      backgroundColor:
                          Theme.of(context).colorScheme.onBackground,
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
                          decorationColor:
                              Theme.of(context).colorScheme.primary),
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
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        CustomContainer(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'QR Code ลิงค์แบบฟอร์ม',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              QrImageView(
                data: 'https://bit.ly/3y4LjmA',
                version: QrVersions.auto,
                size: 240.0,
                embeddedImage: const AssetImage(
                  'assets/images/wisework-logo.png',
                ),
                embeddedImageStyle: const QrEmbeddedImageStyle(
                  size: Size(140.0, 0),
                ),
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 240.0),
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
        ),
      ],
    );
  }

  Column _buildHeaderTab() {
    return Column(
      children: <Widget>[
        Text(
          'Header Tab',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Column _buildBodyTab() {
    return Column(
      children: <Widget>[
        Text(
          'Body Tab',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Column _builFooterTab() {
    return Column(
      children: <Widget>[
        Text(
          'Footer Tab',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Column _buildThemeTab() {
    return Column(
      children: <Widget>[
        Text(
          'Theme Tab',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
