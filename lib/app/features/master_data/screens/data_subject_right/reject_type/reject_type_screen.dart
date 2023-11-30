import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/etc/updated_return.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/data/presets/reject_types_preset.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/reject_type/reject_type_bloc.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/features/master_data/widgets/master_data_item_card.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/loading_indicator.dart';
import 'package:pdpa/app/shared/widgets/screens/example_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class RejectTypeScreen extends StatefulWidget {
  const RejectTypeScreen({super.key});

  @override
  State<RejectTypeScreen> createState() => _RejectTypeScreenState();
}

class _RejectTypeScreenState extends State<RejectTypeScreen> {
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
        .read<RejectTypeBloc>()
        .add(GetRejectTypeEvent(companyId: companyId));
  }

  @override
  Widget build(BuildContext context) {
    return const RejectTypeView();
  }
}

class RejectTypeView extends StatefulWidget {
  const RejectTypeView({super.key});

  @override
  State<RejectTypeView> createState() => _RejectTypeViewState();
}

class _RejectTypeViewState extends State<RejectTypeView> {
  void _onUpdated(UpdatedReturn<RejectTypeModel> updated) {
    final event = UpdateRejectTypeEvent(
      rejectType: updated.object,
      updateType: updated.type,
    );
    context.read<RejectTypeBloc>().add(event);
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
            // print(rejectTypesPreset);
          },
          icon: Icons.chevron_left_outlined,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          tr('masterData.dsr.rejections.title'),
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
              .push(MasterDataRoute.createRejectType.path)
              .then((value) {
            if (value != null) {
              _onUpdated(value as UpdatedReturn<RejectTypeModel>);
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  ContentWrapper buildCustomSection(String language) {
    return ContentWrapper(
      child: BlocBuilder<RejectTypeBloc, RejectTypeState>(
        builder: (context, state) {
          if (state is GotRejectTypes) {
            return CustomContainer(
              child: state.rejectTypes.isNotEmpty
                  ? Column(
                      children: [
                        Text(
                          tr(
                            'masterData.dsr.rejections.title2',
                          ),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: UiConfig.textSpacing),
                        Text(
                          tr(
                            'masterData.dsr.rejections.descriptiontitle2',
                          ),
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: UiConfig.lineGap),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.rejectTypes.length,
                          itemBuilder: (context, index) {
                            return _buildItemCard(
                              context,
                              rejectType: state.rejectTypes[index],
                              onUpdated: _onUpdated,
                              language: language,
                            );
                          },
                        ),
                      ],
                    )
                  : ExampleScreen(
                      headderText: tr(
                        'masterData.dsr.rejections.title2',
                      ),
                      buttonText: tr(
                        'masterData.dsr.rejections.create',
                      ),
                      onPress: () async {
                        await context
                            .push(MasterDataRoute.createRejectType.path)
                            .then((value) {
                          if (value != null) {
                            _onUpdated(value as UpdatedReturn<RejectTypeModel>);
                          }
                        });
                      },
                    ),
            );
          }
          if (state is RejectTypeError) {
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
        margin: const EdgeInsets.all(UiConfig.lineSpacing),
        child: rejectTypesPreset.isNotEmpty
            ? Column(
                children: [
                  Text(
                    tr(
                      'masterData.dsr.rejections.title1',
                    ),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: UiConfig.textSpacing),
                  Text(
                    tr(
                      'masterData.dsr.rejections.descriptiontitle1',
                    ),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: UiConfig.lineGap),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: rejectTypesPreset.length,
                    itemBuilder: (context, index) {
                      return _buildItemCardPreset(
                        context,
                        rejectType: rejectTypesPreset[index],
                        language: language,
                      );
                    },
                  ),
                ],
              )
            : ExampleScreen(
                headderText: tr(
                  'masterData.dsr.rejections.title1',
                ),
                buttonText: tr(
                  'masterData.dsr.rejections.create',
                ),
                onPress: () {
                  context.push(MasterDataRoute.createRejectType.path);
                },
              ),
      ),
    );
  }

  MasterDataItemCard _buildItemCard(
    BuildContext context, {
    required RejectTypeModel rejectType,
    required Function(UpdatedReturn<RejectTypeModel> updated) onUpdated,
    required String language,
  }) {
    final description = rejectType.description.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );
    final rejectTypeCode = rejectType.rejectCode;

    return MasterDataItemCard(
        title: description.text,
        subtitle: rejectTypeCode,
        status: rejectType.status,
        onTap: rejectType.editable == true
            ? () async {
                if (rejectType.editable == true) {
                  await context
                      .push(MasterDataRoute.editRejectType.path
                          .replaceFirst(':id', rejectType.id))
                      .then((value) {
                    if (value != null) {
                      onUpdated(value as UpdatedReturn<RejectTypeModel>);
                    }
                  });
                }
              }
            : null);
  }

  MasterDataItemCard _buildItemCardPreset(
    BuildContext context, {
    required RejectTypeModel rejectType,
    required String language,
  }) {
    final description = rejectType.description.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );
    final rejectTypeCode = rejectType.rejectCode;

    return MasterDataItemCard(
      title: description.text,
      subtitle: rejectTypeCode,
      status: rejectType.status,
    );
  }
}
