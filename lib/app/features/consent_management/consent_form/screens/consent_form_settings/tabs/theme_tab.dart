import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/features/consent_management/consent_form/cubit/current_consent_form_settings/current_consent_form_settings_cubit.dart';
import 'package:pdpa/app/features/consent_management/consent_form/routes/consent_form_route.dart';
import 'package:pdpa/app/features/consent_management/consent_form/screens/consent_form_settings/widgets/consent_theme_tile.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';

class ThemeTab extends StatelessWidget {
  const ThemeTab({
    super.key,
    required this.consentForm,
    required this.consentThemes,
  });

  final ConsentFormModel consentForm;
  final List<ConsentThemeModel> consentThemes;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ContentWrapper(
        child: Column(
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            _buildThemeSection(context),
            const SizedBox(height: UiConfig.lineSpacing),
          ],
        ),
      ),
    );
  }

  CustomContainer _buildThemeSection(BuildContext context) {
    return CustomContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                tr('consentManagement.consentForm.themetab.themes'), //!
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Visibility(
            visible: consentThemes.isNotEmpty,
            child: _buildConsentThemeView(),
          ),
          _buildNewThemeBUtton(context),
        ],
      ),
    );
  }

  Column _buildConsentThemeView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListView.separated(
          shrinkWrap: true,
          itemCount: consentThemes.length,
          itemBuilder: (context, index) => ConsentThemeTile(
            consentTheme: consentThemes[index],
            selectedValue: consentForm.consentThemeId,
            onChanged: (value) {
              context
                  .read<CurrentConsentFormSettingsCubit>()
                  .setConsentTheme(consentThemes[index]);
            },
          ),
          separatorBuilder: (context, _) => const SizedBox(
            height: UiConfig.lineSpacing,
          ),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
      ],
    );
  }

  MaterialInkWell _buildNewThemeBUtton(BuildContext context) {
    return MaterialInkWell(
      onTap: () {
        context.push(ConsentFormRoute.createConsentTheme.path);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Icon(
                Ionicons.add,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: UiConfig.actionSpacing + 11),
            Expanded(
              child: Text(
                tr('consentManagement.consentForm.themetab.newTheme'), //!
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
