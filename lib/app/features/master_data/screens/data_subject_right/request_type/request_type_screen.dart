import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/etc/updated_return.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/data/presets/request_types_preset.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/request_type/request_type_bloc.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/features/master_data/widgets/master_data_item_card.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/loading_indicator.dart';
import 'package:pdpa/app/shared/widgets/screens/example_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class RequestTypeScreen extends StatefulWidget {
  const RequestTypeScreen({super.key});

  @override
  State<RequestTypeScreen> createState() => _RequestTypeScreenState();
}

class _RequestTypeScreenState extends State<RequestTypeScreen> {
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
        .read<RequestTypeBloc>()
        .add(GetRequestTypesEvent(companyId: companyId));
  }

  @override
  Widget build(BuildContext context) {
    return const RequestTypeView();
  }
}

class RequestTypeView extends StatefulWidget {
  const RequestTypeView({super.key});

  @override
  State<RequestTypeView> createState() => _RequestTypeViewState();
}

class _RequestTypeViewState extends State<RequestTypeView> {
  void _onUpdated(UpdatedReturn<RequestTypeModel> updated) {
    final event = UpdateRequestTypesChangedEvent(
      requestType: updated.object,
      updateType: updated.type,
    );
    context.read<RequestTypeBloc>().add(event);
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
          tr('masterData.dsr.request.list2'),
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
              .push(MasterDataRoute.createRequestType.path)
              .then((value) {
            if (value != null) {
              _onUpdated(value as UpdatedReturn<RequestTypeModel>);
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  ContentWrapper buildCustomSection(String language) {
    return ContentWrapper(
      child: BlocBuilder<RequestTypeBloc, RequestTypeState>(
        builder: (context, state) {
          if (state is GotRequestTypes) {
            return CustomContainer(
              child: state.requestTypes.isNotEmpty
                  ? Column(
                      children: [
                        Text(
                          tr(
                            'masterData.dsr.request.title2',
                          ),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: UiConfig.textSpacing),
                        Text(
                          tr(
                            'masterData.dsr.request.descriptiontitle2',
                          ),
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: UiConfig.lineGap),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.requestTypes.length,
                          itemBuilder: (context, index) {
                            return _buildItemCard(
                              context,
                              requestType: state.requestTypes[index],
                              onUpdated: _onUpdated,
                              language: language,
                            );
                          },
                        ),
                      ],
                    )
                  : ExampleScreen(
                      headderText: tr(
                        'masterData.dsr.request.title3',
                      ),
                      buttonText: tr(
                        'masterData.dsr.request.create',
                      ),
                      onPress: () async {
                        await context
                            .push(MasterDataRoute.createRequestType.path)
                            .then((value) {
                          if (value != null) {
                            _onUpdated(
                                value as UpdatedReturn<RequestTypeModel>);
                          }
                        });
                      },
                    ),
            );
          }
          if (state is RequestTypeError) {
            return CustomContainer(
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
        child: requestTypesPreset.isNotEmpty
            ? Column(
                children: [
                  Text(
                    tr('masterData.dsr.request.title1'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: UiConfig.textSpacing),
                  Text(
                    tr('masterData.dsr.request.descriptiontitle1'),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: UiConfig.lineGap),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: requestTypesPreset.length,
                    itemBuilder: (context, index) {
                      return _buildItemCardPreset(
                        context,
                        requestType: requestTypesPreset[index],
                        language: language,
                      );
                    },
                  ),
                ],
              )
            : ExampleScreen(
                headderText: tr(
                  'masterData.dsr.request.title1',
                ),
                buttonText: tr(
                  'masterData.dsr.request.create',
                ),
                onPress: () {
                  context.push(MasterDataRoute.createRequestType.path);
                },
              ),
      ),
    );
  }

  MasterDataItemCard _buildItemCard(
    BuildContext context, {
    required RequestTypeModel requestType,
    required Function(UpdatedReturn<RequestTypeModel> updated) onUpdated,
    required String language,
  }) {
    final description = requestType.description.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );
    final requestTypeCode = requestType.requestCode;

    return MasterDataItemCard(
        title: description.text,
        subtitle: requestTypeCode,
        status: requestType.status,
        onTap: requestType.editable == true
            ? () async {
                if (requestType.editable == true) {
                  await context
                      .push(MasterDataRoute.editRequestType.path
                          .replaceFirst(':id', requestType.id))
                      .then((value) {
                    if (value != null) {
                      onUpdated(value as UpdatedReturn<RequestTypeModel>);
                    }
                  });
                }
              }
            : null);
  }

  MasterDataItemCard _buildItemCardPreset(
    BuildContext context, {
    required RequestTypeModel requestType,
    required String language,
  }) {
    final description = requestType.description.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );
    final requestTypeCode = requestType.requestCode;

    return MasterDataItemCard(
      title: description.text,
      subtitle: requestTypeCode,
      status: requestType.status,
    );
  }
}
