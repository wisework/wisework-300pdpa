import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/etc/updated_return.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
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
          tr('masterData.dsr.request.list'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: ContentWrapper(
          child: BlocBuilder<RequestTypeBloc, RequestTypeState>(
            builder: (context, state) {
              if (state is GotRequestTypes) {
                return CustomContainer(
                  margin: const EdgeInsets.all(UiConfig.lineSpacing),
                  child: state.requestTypes.isNotEmpty
                      ? ListView.builder(
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
                        )
                      : ExampleScreen(
                          headderText: tr(
                            'masterData.cm.RequestType.list',
                          ),
                          buttonText: tr(
                            'masterData.cm.RequestType.create',
                          ),
                          descriptionText: tr(
                            'masterData.cm.RequestType.explain',
                          ),
                          onPress: () {
                            context
                                .push(MasterDataRoute.createRequestType.path);
                          },
                        ),
                );
              }
              if (state is RequestTypeError) {
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

  MasterDataItemCard _buildItemCard(
    BuildContext context, {
    required RequestTypeModel requestType,
    required Function(UpdatedReturn<RequestTypeModel> updated) onUpdated,
    required String language,
  }) {
    final title = requestType.description.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );
    // final description = RequestType.description.firstWhere(
    //   (item) => item.language == language,
    //   orElse: () => const LocalizedModel.empty(),
    // );

    return MasterDataItemCard(
      title: title.text,
      subtitle: '',
      status: requestType.status,
      onTap: () async {
        await context
            .push(MasterDataRoute.editRequestType.path
                .replaceFirst(':id', requestType.id))
            .then((value) {
          if (value != null) {
            onUpdated(value as UpdatedReturn<RequestTypeModel>);
          }
        });
      },
    );
  }
}
