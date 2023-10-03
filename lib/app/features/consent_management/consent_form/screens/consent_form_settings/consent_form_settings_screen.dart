import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/features/consent_management/consent_form/screens/consent_form_settings/widgets/consent_form_drawer.dart';
import 'package:pdpa/app/services/apis/consent_api.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

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
        Text(
          'URL Tab',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        ElevatedButton(
          onPressed: () async {
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

            final api = ConsentApi(FirebaseFirestore.instance);
            const companyId = 'C7q7rpbkjgLMeROuJQhi';

            await api.createConsentTheme(consentTheme, companyId).then((value) {
              BotToast.showText(text: value.id);
            });
          },
          child: const Text('Add'),
        ),
        ElevatedButton(
          onPressed: () async {
            final consentTheme = ConsentThemeModel(
              id: 'ftpfgZwoDSyDRk0Oj2Et',
              title: 'Meow theme',
              headerTextColor: 'ff044035',
              headerBackgroundColor: 'ffffffff',
              bodyBackgroundColor: 'ffffffff',
              formTextColor: 'ff2b2b2b',
              categoryTitleTextColor: 'ff044035',
              acceptConsentTextColor: 'ff0a6152',
              linkToPolicyTextColor: 'ff0a6152',
              acceptButtonColor: 'ff044035',
              acceptTextColor: 'ffffffff',
              cancelButtonColor: 'ffffffff',
              cancelTextColor: 'ff044035',
              actionButtonColor: 'ff0a6152',
              createdBy: 'meow@gmail.com',
              createdDate: DateTime.now(),
              updatedBy: 'meow@gmail.com',
              updatedDate: DateTime.now(),
            );
            final api = ConsentApi(FirebaseFirestore.instance);
            const companyId = 'C7q7rpbkjgLMeROuJQhi';

            await api.updateConsentTheme(consentTheme, companyId).then((_) {
              BotToast.showText(text: 'Updated');
            });
          },
          child: const Text('Update'),
        ),
        ElevatedButton(
          onPressed: () async {
            final api = ConsentApi(FirebaseFirestore.instance);
            const companyId = 'C7q7rpbkjgLMeROuJQhi';

            await api.getConsentThemes(companyId).then((value) {
              print(value);
            });
          },
          child: const Text('Get'),
        ),
        ElevatedButton(
          onPressed: () async {
            final api = ConsentApi(FirebaseFirestore.instance);
            const companyId = 'C7q7rpbkjgLMeROuJQhi';

            await api
                .getConsentThemeById('ftpfgZwoDSyDRk0Oj2Et', companyId)
                .then((value) {
              print(value);
            });
          },
          child: const Text('Get by ID'),
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
