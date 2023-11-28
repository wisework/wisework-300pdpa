import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/etc/updated_return.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/data/presets/reason_types_preset.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/reason_type/reason_type_bloc.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/features/master_data/widgets/master_data_item_card.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/loading_indicator.dart';
import 'package:pdpa/app/shared/widgets/screens/example_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class ReasonTypeScreen extends StatefulWidget {
  const ReasonTypeScreen({super.key});

  @override
  State<ReasonTypeScreen> createState() => _ReasonTypeScreenState();
}

class _ReasonTypeScreenState extends State<ReasonTypeScreen> {
  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    final bloc = context.read<SignInBloc>();

    String companyId = '';
    if (bloc.state is SignedInUser) {
      companyId = (bloc.state as SignedInUser).user.currentCompany;
    }

    context
        .read<ReasonTypeBloc>()
        .add(GetReasonTypeEvent(companyId: companyId));
  }

  @override
  Widget build(BuildContext context) {
    return const ReasonTypeView();
  }
}

class ReasonTypeView extends StatefulWidget {
  const ReasonTypeView({super.key});

  @override
  State<ReasonTypeView> createState() => _ReasonTypeViewState();
}

class _ReasonTypeViewState extends State<ReasonTypeView> {
  void _onUpdated(UpdatedReturn<ReasonTypeModel> updated) {
    final event = UpdateReasonTypeEvent(
      reasonType: updated.object,
      updateType: updated.type,
    );
    context.read<ReasonTypeBloc>().add(event);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SignInBloc>();

    String language = '';
    if (bloc.state is SignedInUser) {
      language = (bloc.state as SignedInUser).user.defaultLanguage;
    }
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: CustomIconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icons.chevron_left_outlined,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          tr('masterData.dsr.reason.list'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildPresetSection(language, context),
            buildCustomSection(language),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context
              .push(MasterDataRoute.createReasonType.path)
              .then((value) {
            if (value != null) {
              _onUpdated(value as UpdatedReturn<ReasonTypeModel>);
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  ContentWrapper buildCustomSection(String language) {
    return ContentWrapper(
      child: BlocBuilder<ReasonTypeBloc, ReasonTypeState>(
        builder: (context, state) {
          if (state is GotReasonTypes) {
            return CustomContainer(
              margin: const EdgeInsets.all(UiConfig.lineSpacing),
              child: state.reasonTypes.isNotEmpty
                  ? Column(
                      children: [
                        Text(
                          tr('masterData.dsr.reason.title2'),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: UiConfig.textSpacing),
                        Text(
                          tr('masterData.dsr.reason.descriptiontitle2'),
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: UiConfig.lineGap),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.reasonTypes.length,
                          itemBuilder: (context, index) {
                            return _buildItemCard(
                              context,
                              reasonType: state.reasonTypes[index],
                              onUpdated: _onUpdated,
                              language: language,
                            );
                          },
                        ),
                      ],
                    )
                  : ExampleScreen(
                      headderText: tr(
                        'masterData.dsr.reason.title2',
                      ),
                      buttonText: tr(
                        'masterData.dsr.reason.create',
                      ),
                      onPress: () async {
                        await context
                            .push(MasterDataRoute.createReasonType.path)
                            .then((value) {
                          if (value != null) {
                            _onUpdated(value as UpdatedReturn<ReasonTypeModel>);
                          }
                        });
                      },
                    ),
            );
          }
          if (state is ReasonTypeError) {
            return CustomContainer(
              margin: const EdgeInsets.all(UiConfig.lineSpacing),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: UiConfig.defaultPaddingSpacing * 4,
                ),
                child: Center(
                  child: Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            );
          }
          return const CustomContainer(
            margin: EdgeInsets.all(UiConfig.lineSpacing),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: UiConfig.defaultPaddingSpacing * 4,
              ),
              child: Center(
                child: LoadingIndicator(),
              ),
            ),
          );
        },
      ),
    );
  }

  ContentWrapper buildPresetSection(String language, BuildContext context) {
    return ContentWrapper(
      child: CustomContainer(
        child: reasonTypesPreset.isNotEmpty
            ? Column(
                children: [
                  Text(
                    tr('masterData.dsr.reason.title1'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: UiConfig.textSpacing),
                  Text(
                    tr('masterData.dsr.reason.descriptiontitle1'),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: UiConfig.lineGap),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: reasonTypesPreset.length,
                    itemBuilder: (context, index) {
                      return _buildItemCardPreset(
                        context,
                        reasonType: reasonTypesPreset[index],
                        language: language,
                      );
                    },
                  ),
                ],
              )
            : ExampleScreen(
                headderText: tr(
                  'masterData.dsr.reason.title1',
                ),
                buttonText: tr(
                  'masterData.dsr.reason.create',
                ),
                onPress: () {
                  context.push(MasterDataRoute.createReasonType.path);
                },
              ),
      ),
    );
  }

  MasterDataItemCard _buildItemCard(
    BuildContext context, {
    required ReasonTypeModel reasonType,
    required Function(UpdatedReturn<ReasonTypeModel> updated) onUpdated,
    required String language,
  }) {
    final description = reasonType.description.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );
    final reasonTypeCode = reasonType.reasonCode;

    return MasterDataItemCard(
        title: description.text,
        subtitle: reasonTypeCode,
        status: reasonType.status,
        onTap: reasonType.editable == true
            ? () async {
                if (reasonType.editable == true) {
                  await context
                      .push(MasterDataRoute.editReasonType.path
                          .replaceFirst(':id', reasonType.id))
                      .then((value) {
                    if (value != null) {
                      onUpdated(value as UpdatedReturn<ReasonTypeModel>);
                    }
                  });
                }
              }
            : null);
  }

  MasterDataItemCard _buildItemCardPreset(
    BuildContext context, {
    required ReasonTypeModel reasonType,
    required String language,
  }) {
    final description = reasonType.description.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );
    final reasonTypeCode = reasonType.reasonCode;

    return MasterDataItemCard(
      title: description.text,
      subtitle: reasonTypeCode,
      status: reasonType.status,
    );
  }
}
