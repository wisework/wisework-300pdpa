import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class CreateConsentFormSuccessScreen extends StatefulWidget {
  const CreateConsentFormSuccessScreen({
    super.key,
    required this.consentForm,
    required this.mandatoryFields,
    required this.purposeCategories,
    required this.purposes,
    required this.customFields,
    required this.currentUser,
  });

  final ConsentFormModel consentForm;
  final List<MandatoryFieldModel> mandatoryFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;
  final List<CustomFieldModel> customFields;
  final UserModel currentUser;

  @override
  State<CreateConsentFormSuccessScreen> createState() =>
      _CreateConsentFormSuccessScreenState();
}

class _CreateConsentFormSuccessScreenState
    extends State<CreateConsentFormSuccessScreen> {
  final String language = 'en-US';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: CustomIconButton(
          onPressed: () {
            // final event = UpdateConsentFormEvent(
            //   consentForm: widget.consentForm,
            //   updateType: UpdateType.created,
            // );
            // context.read<ConsentFormBloc>().add(event);

            // final url = UtilFunctions.getUserConsentFormUrl(
            //   widget.consentForm.id,
            //   widget.currentUser.currentCompany,
            // );

            // final cubit = context.read<CurrentConsentFormSettingsCubit>();
            // cubit.generateConsentFormUrl(url);

            // consentForm = widget.consentForm.copyWith(
            //   consentFormUrl: url,
            // );

            // context.read<EditConsentFormBloc>().add(
            //       UpdateCurrentConsentFormEvent(
            //         consentForm: consentForm,
            //         companyId: widget.currentUser.currentCompany,
            //       ),
            //     );

            // context.push(
            //   ConsentFormRoute.consentForm.path,
            // );
          },
          icon: Ionicons.chevron_back_outline,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tr('consentManagement.consentForm.congratulations.title'),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            CustomContainer(
              child: _buildConsentForm(context),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            CustomContainer(
              child: _buildShortcutSettingForm(context),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
          ],
        ),
      ),
    );
  }

  Column _buildConsentForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('consentManagement.consentForm.congratulations.created'),
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Theme.of(context).colorScheme.secondary),
        ),
        widget.consentForm.id.isNotEmpty
            ? _buildConsentInfo(context)
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    tr('consentManagement.consentForm.congratulations.noConsentDetails'),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: UiConfig.lineSpacing),
          child: Divider(
            color: Theme.of(context).colorScheme.outline,
            thickness: 0.3,
          ),
        ),
        _buildCustomFieldInfo(context),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: UiConfig.lineSpacing),
          child: Divider(
            color: Theme.of(context).colorScheme.outline,
            thickness: 0.3,
          ),
        ),
        _buildPurposeCategoriesInfo(context),
      ],
    );
  }

  Column _buildConsentInfo(BuildContext context) {
    final title = widget.consentForm.title.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );

    final description = widget.consentForm.description.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "ID: ${widget.consentForm.id}",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title.text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  height: 1.6,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ),
        if (description.text.isNotEmpty)
          Text(
            description.text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  height: 1.8,
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
      ],
    );
  }

  Column _buildCustomFieldInfo(BuildContext context) {
    final mandatoryFiltered = UtilFunctions.filterMandatoryFieldsByIds(
      widget.mandatoryFields,
      widget.consentForm.mandatoryFields,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            tr('consentManagement.consentForm.consentFormDetails.storedInformation'),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.surfaceTint),
          ),
        ),
        mandatoryFiltered.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mandatoryFiltered.length,
                itemBuilder: (_, index) {
                  final title = mandatoryFiltered[index].title.firstWhere(
                        (item) => item.language == language,
                        orElse: () => const LocalizedModel.empty(),
                      );

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: widget.mandatoryFields.last !=
                              widget.mandatoryFields[index]
                          ? 8.0
                          : 0.0,
                    ),
                    child: Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.circle,
                          size: 8,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          title.text,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    tr('consentManagement.consentForm.consentFormDetails.noInputField'),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              ),
      ],
    );
  }

  Column _buildPurposeCategoriesInfo(BuildContext context) {
    final purposeCategoryFiltered = UtilFunctions.filterPurposeCategoriesByIds(
      widget.purposeCategories,
      widget.consentForm.purposeCategories
          .map((category) => category.id)
          .toList(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            tr('consentManagement.consentForm.consentFormDetails.Purposes'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.surfaceTint,
                ),
          ),
        ),
        purposeCategoryFiltered.isNotEmpty
            ? ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: purposeCategoryFiltered.length,
                itemBuilder: (_, index) {
                  final title = purposeCategoryFiltered[index].title.firstWhere(
                        (item) => item.language == language,
                        orElse: () => const LocalizedModel.empty(),
                      );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          title.text,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                height: 1.6,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ),
                      _buildPurposesInfo(
                        context,
                        purposeCategory: purposeCategoryFiltered[index],
                      ),
                    ],
                  );
                },
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
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    tr('consentManagement.consentForm.consentFormDetails.noPurposes'),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ),
      ],
    );
  }

  ListView _buildPurposesInfo(
    BuildContext context, {
    required PurposeCategoryModel purposeCategory,
  }) {
    final purposeFiltered = UtilFunctions.filterPurposeByIds(
      widget.purposes,
      purposeCategory.purposes.map((purpose) => purpose.id).toList(),
    );

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: purposeFiltered.length,
      itemBuilder: (_, index) {
        final description = purposeFiltered[index].description.firstWhere(
              (item) => item.language == language,
              orElse: () => const LocalizedModel.empty(),
            );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    description.text,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          height: 1.8,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Text(
                    "${purposeFiltered[index].retentionPeriod} ${purposeFiltered[index].periodUnit}",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
      separatorBuilder: (context, _) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: UiConfig.lineSpacing,
        ),
        child: Divider(
          height: 0.1,
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.6),
        ),
      ),
    );
  }

  Column _buildShortcutSettingForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          tr('consentManagement.consentForm.congratulations.settingConsentTheme'),
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.secondary),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              onPressed: () {
                // final event = UpdateConsentFormEvent(
                //   consentForm: widget.consentForm,
                //   updateType: UpdateType.created,
                // );
                // context.read<ConsentFormBloc>().add(event);

                // final url = UtilFunctions.getUserConsentFormUrl(
                //   widget.consentForm.id,
                //   widget.currentUser.currentCompany,
                // );

                // consentForm = widget.consentForm.copyWith(
                //   consentFormUrl: url,
                // );

                // context.read<EditConsentFormBloc>().add(
                //       UpdateCurrentConsentFormEvent(
                //         consentForm: consentForm,
                //         companyId: widget.currentUser.currentCompany,
                //       ),
                //     );

                // context.push(
                //   ConsentFormRoute.consentForm.path,
                // );
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  )),
              child: Text(
                tr('consentManagement.consentForm.congratulations.later'),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            const SizedBox(width: 10.0),
            ElevatedButton(
              onPressed: () async {
                // final url = UtilFunctions.getUserConsentFormUrl(
                //   widget.consentForm.id,
                //   widget.currentUser.currentCompany,
                // );

                // consentForm = widget.consentForm.copyWith(
                //   consentFormUrl: url,
                // );

                // context.read<EditConsentFormBloc>().add(
                //       UpdateCurrentConsentFormEvent(
                //         consentForm: consentForm,
                //         companyId: widget.currentUser.currentCompany,
                //       ),
                //     );
                // context.push(
                //   ConsentFormRoute.consentFormSettings.path
                //       .replaceFirst(':id', widget.consentForm.id),
                // );
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  )),
              child: Text(
                tr('consentManagement.consentForm.congratulations.ok'),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ],
        )
      ],
    );
  }
}

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:pdpa/app/config/config.dart';
// import 'package:pdpa/app/data/models/authentication/user_model.dart';
// import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
// import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
// import 'package:pdpa/app/data/models/master_data/localized_model.dart';
// import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
// import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
// import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
// import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
// import 'package:pdpa/app/features/consent_management/consent_form/bloc/consent_form/consent_form_bloc.dart';
// import 'package:pdpa/app/features/consent_management/consent_form/bloc/consent_form_detail/consent_form_detail_bloc.dart';
// import 'package:pdpa/app/features/consent_management/consent_form/bloc/edit_consent_form/edit_consent_form_bloc.dart';
// import 'package:pdpa/app/features/consent_management/consent_form/routes/consent_form_route.dart';
// import 'package:pdpa/app/injection.dart';
// import 'package:pdpa/app/shared/utils/constants.dart';
// import 'package:pdpa/app/shared/utils/functions.dart';
// import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
// import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
// import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

// class CreateConsentFormSuccessScreen1 extends StatefulWidget {
//   const CreateConsentFormSuccessScreen1({
//     super.key,
//     required this.consentFormId,
//   });

//   final String consentFormId;

//   @override
//   State<CreateConsentFormSuccessScreen1> createState() =>
//       _CreateConsentFormSuccessScreen1State();
// }

// class _CreateConsentFormSuccessScreen1State
//     extends State<CreateConsentFormSuccessScreen1> {
//   late UserModel currentUser;

//   @override
//   void initState() {
//     super.initState();

//     _initialData();
//   }

//   void _initialData() {
//     final bloc = context.read<SignInBloc>();
//     if (bloc.state is SignedInUser) {
//       currentUser = (bloc.state as SignedInUser).user;
//     } else {
//       currentUser = UserModel.empty();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => serviceLocator<ConsentFormDetailBloc>()
//             ..add(
//               GetConsentFormEvent(
//                 consentFormId: widget.consentFormId,
//                 companyId: currentUser.currentCompany,
//               ),
//             ),
//         ),
//         BlocProvider(
//             create: (context) => serviceLocator<EditConsentFormBloc>()),
//       ],
//       child: BlocBuilder<ConsentFormDetailBloc, ConsentFormDetailState>(
//         builder: (context, state) {
//           if (state is GotConsentFormDetail) {
//             return CreateConsentFormSuccessView(
//               consentForm: state.consentForm,
//               mandatoryFields: state.mandatoryFields,
//               purposeCategories: state.purposeCategories,
//               purposes: state.purposes,
//               customFields: state.customFields,
//               currentUser: currentUser,
//             );
//           }

//           return const LoadingScreen();
//         },
//       ),
//     );
//   }
// }

// class CreateConsentFormSuccessView extends StatefulWidget {
//   const CreateConsentFormSuccessView({
//     super.key,
//     required this.consentForm,
//     required this.mandatoryFields,
//     required this.purposeCategories,
//     required this.customFields,
//     required this.purposes,
//     required this.currentUser,
//   });

//   final ConsentFormModel consentForm;
//   final List<MandatoryFieldModel> mandatoryFields;
//   final List<CustomFieldModel> customFields;
//   final List<PurposeCategoryModel> purposeCategories;
//   final List<PurposeModel> purposes;
//   final UserModel currentUser;

//   @override
//   State<CreateConsentFormSuccessView> createState() =>
//       _CreateConsentFormSuccessViewState();
// }

// class _CreateConsentFormSuccessViewState
//     extends State<CreateConsentFormSuccessView> {
//   @override
//   Widget build(BuildContext context) {
//     ConsentFormModel consentForm = widget.consentForm;
//     const String language = 'en-US';

//     final title = widget.consentForm.title.firstWhere(
//       (item) => item.language == language,
//       orElse: () => const LocalizedModel.empty(),
//     );

//     final description = widget.consentForm.description.firstWhere(
//       (item) => item.language == language,
//       orElse: () => const LocalizedModel.empty(),
//     );
//     return Scaffold(
//       appBar: PdpaAppBar(
//         title: Text(
//           tr('consentManagement.consentForm.congratulations.title'),
//           style: Theme.of(context)
//               .textTheme
//               .titleLarge
//               ?.copyWith(color: Theme.of(context).colorScheme.primary),
//           textAlign: TextAlign.center,
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: CustomContainer(
//           padding: const EdgeInsets.all(0),
//           margin: const EdgeInsets.all(0),
//           color: Theme.of(context).colorScheme.background,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: UiConfig.lineSpacing),
//               CustomContainer(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       tr('consentManagement.consentForm.congratulations.created'),
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           color: Theme.of(context).colorScheme.secondary),
//                     ),
//                     widget.consentForm.id.isNotEmpty
//                         ? _consentInfo(
//                             context,
//                             title,
//                             description,
//                           )
//                         : Padding(
//                             padding: const EdgeInsets.all(20.0),
//                             child: Center(
//                               child: Text(
//                                 tr('consentManagement.consentForm.congratulations.noConsentDetails'),
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .labelLarge
//                                     ?.copyWith(
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .secondary),
//                               ),
//                             ),
//                           ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: UiConfig.lineSpacing),
//                       child: Divider(
//                         color: Theme.of(context).colorScheme.outline,
//                         thickness: 0.3,
//                       ),
//                     ),
//                     _customFieldInfo(context, language),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: UiConfig.lineSpacing),
//                       child: Divider(
//                         color: Theme.of(context).colorScheme.outline,
//                         thickness: 0.3,
//                       ),
//                     ),
//                     _purposeCategoriesInfo(context, language),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: UiConfig.lineSpacing),
//               CustomContainer(
//                 margin: const EdgeInsets.all(0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       tr('consentManagement.consentForm.congratulations.settingConsentTheme'),
//                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           color: Theme.of(context).colorScheme.secondary),
//                     ),
//                     const SizedBox(height: UiConfig.lineSpacing),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: <Widget>[
//                         TextButton(
//                           onPressed: () {
//                             final event = UpdateConsentFormEvent(
//                               consentForm: widget.consentForm,
//                               updateType: UpdateType.created,
//                             );
//                             context.read<ConsentFormBloc>().add(event);

//                             final url = UtilFunctions.getUserConsentFormUrl(
//                               widget.consentForm.id,
//                               widget.currentUser.currentCompany,
//                             );

//                             // final cubit = context.read<CurrentConsentFormSettingsCubit>();
//                             // cubit.generateConsentFormUrl(url);

//                             consentForm = widget.consentForm.copyWith(
//                               consentFormUrl: url,
//                             );

//                             context.read<EditConsentFormBloc>().add(
//                                   UpdateCurrentConsentFormEvent(
//                                     consentForm: consentForm,
//                                     companyId:
//                                         widget.currentUser.currentCompany,
//                                   ),
//                                 );

//                             context.push(
//                               ConsentFormRoute.consentForm.path,
//                             );
//                           },
//                           style: ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all<Color>(
//                                 Theme.of(context).colorScheme.onPrimary,
//                               ),
//                               shape: MaterialStateProperty.all<
//                                   RoundedRectangleBorder>(
//                                 RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8.0),
//                                 ),
//                               )),
//                           child: Text(
//                             tr('consentManagement.consentForm.congratulations.later'),
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyMedium
//                                 ?.copyWith(
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .secondary),
//                           ),
//                         ),
//                         const SizedBox(width: 10.0),
//                         ElevatedButton(
//                           onPressed: () async {
//                             final url = UtilFunctions.getUserConsentFormUrl(
//                               widget.consentForm.id,
//                               widget.currentUser.currentCompany,
//                             );

//                             // final cubit = context.read<CurrentConsentFormSettingsCubit>();
//                             // cubit.generateConsentFormUrl(url);

//                             consentForm = widget.consentForm.copyWith(
//                               consentFormUrl: url,
//                             );

//                             context.read<EditConsentFormBloc>().add(
//                                   UpdateCurrentConsentFormEvent(
//                                     consentForm: consentForm,
//                                     companyId:
//                                         widget.currentUser.currentCompany,
//                                   ),
//                                 );
//                             context.push(
//                               ConsentFormRoute.consentFormSettings.path
//                                   .replaceFirst(':id', widget.consentForm.id),
//                             );
//                           },
//                           style: ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all<Color>(
//                                 Theme.of(context).colorScheme.primary,
//                               ),
//                               shape: MaterialStateProperty.all<
//                                   RoundedRectangleBorder>(
//                                 RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8.0),
//                                 ),
//                               )),
//                           child: Text(
//                             tr('consentManagement.consentForm.congratulations.ok'),
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyMedium
//                                 ?.copyWith(
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .onPrimary),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Column _purposeCategoriesInfo(BuildContext context, String language) {
//     final purposeCategoryFiltered = UtilFunctions.filterPurposeCategoriesByIds(
//       widget.purposeCategories,
//       [],
//       // widget.consentForm.purposeCategories,
//     );
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.only(bottom: 8.0),
//           child: Text(
//             tr('consentManagement.consentForm.consentFormDetails.Purposes'),
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   color: Theme.of(context).colorScheme.surfaceTint,
//                 ),
//           ),
//         ),
//         purposeCategoryFiltered.isNotEmpty
//             ? ListView.separated(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: purposeCategoryFiltered.length,
//                 itemBuilder: (_, index) {
//                   final title = purposeCategoryFiltered[index].title.firstWhere(
//                         (item) => item.language == language,
//                         orElse: () => const LocalizedModel.empty(),
//                       );
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 8.0),
//                         child: Text(
//                           title.text,
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleSmall
//                               ?.copyWith(
//                                 height: 1.6,
//                                 color: Theme.of(context).colorScheme.secondary,
//                               ),
//                         ),
//                       ),
//                       _purposesInfo(
//                           language, context, purposeCategoryFiltered[index]),
//                     ],
//                   );
//                 },
//                 separatorBuilder: (context, _) => Padding(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: UiConfig.lineSpacing,
//                   ),
//                   child: Divider(
//                     height: 0.1,
//                     color: Theme.of(context)
//                         .colorScheme
//                         .outlineVariant
//                         .withOpacity(0.6),
//                   ),
//                 ),
//               )
//             : Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Center(
//                   child: Text(
//                     tr('consentManagement.consentForm.consentFormDetails.noPurposes'),
//                     style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                         color: Theme.of(context).colorScheme.secondary),
//                   ),
//                 ),
//               ),
//       ],
//     );
//   }

//   ListView _purposesInfo(String language, BuildContext context,
//       PurposeCategoryModel purposeCategory) {
//     final purposeFiltered = UtilFunctions.filterPurposeByIds(
//       widget.purposes,
//       purposeCategory.purposes.map((purpose) => purpose.id).toList(),
//     );
//     return ListView.separated(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: purposeFiltered.length,
//       itemBuilder: (_, index) {
//         final description = purposeFiltered[index].description.firstWhere(
//               (item) => item.language == language,
//               orElse: () => const LocalizedModel.empty(),
//             );

//         return Padding(
//           padding: const EdgeInsets.only(left: 20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Expanded(
//                     child: Text(
//                       description.text,
//                       style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                             height: 1.8,
//                             color: Theme.of(context).colorScheme.secondary,
//                           ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 30.0),
//                     child: Text(
//                       "${purposeFiltered[index].retentionPeriod} ${purposeFiltered[index].periodUnit}",
//                       style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                             color: Theme.of(context).colorScheme.secondary,
//                           ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//       separatorBuilder: (context, _) => Padding(
//         padding: const EdgeInsets.symmetric(
//           vertical: UiConfig.lineSpacing,
//         ),
//         child: Divider(
//           height: 0.1,
//           color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.6),
//         ),
//       ),
//     );
//   }

//   Column _customFieldInfo(BuildContext context, String language) {
//     final mandatoryFiltered = UtilFunctions.filterMandatoryFieldsByIds(
//       widget.mandatoryFields,
//       widget.consentForm.mandatoryFields,
//     );
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.only(bottom: 8.0),
//           child: Text(
//             tr('consentManagement.consentForm.consentFormDetails.storedInformation'),
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   color: Theme.of(context).colorScheme.surfaceTint,
//                 ),
//           ),
//         ),
//         mandatoryFiltered.isNotEmpty
//             ? ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: mandatoryFiltered.length,
//                 itemBuilder: (_, index) {
//                   final title = mandatoryFiltered[index].title.firstWhere(
//                         (item) => item.language == language,
//                         orElse: () => const LocalizedModel.empty(),
//                       );
//                   return Padding(
//                     padding: EdgeInsets.only(
//                         bottom: widget.mandatoryFields.last !=
//                                 widget.mandatoryFields[index]
//                             ? 8.0
//                             : 0.0),
//                     child: Wrap(
//                       direction: Axis.horizontal,
//                       crossAxisAlignment: WrapCrossAlignment.center,
//                       children: <Widget>[
//                         Icon(
//                           Icons.circle,
//                           size: 8,
//                           color: Theme.of(context).colorScheme.secondary,
//                         ),
//                         const SizedBox(width: 10.0),
//                         Text(title.text,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .labelLarge
//                                 ?.copyWith(
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .secondary)),
//                       ],
//                     ),
//                   );
//                 },
//               )
//             : Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Center(
//                   child: Text(
//                     tr('consentManagement.consentForm.consentFormDetails.noInputField'),
//                     style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                         color: Theme.of(context).colorScheme.onSurface),
//                   ),
//                 ),
//               ),
//       ],
//     );
//   }

//   Column _consentInfo(
//       BuildContext context, LocalizedModel title, LocalizedModel description) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           "ID: ${widget.consentForm.id}",
//           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                 color: Theme.of(context).colorScheme.secondary,
//               ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           child: Text(
//             title.text,
//             style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                   height: 1.6,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//           ),
//         ),
//         if (description.text.isNotEmpty)
//           Text(
//             description.text,
//             style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                   height: 1.8,
//                   color: Theme.of(context).colorScheme.secondary,
//                 ),
//           ),
//       ],
//     );
//   }
// }
