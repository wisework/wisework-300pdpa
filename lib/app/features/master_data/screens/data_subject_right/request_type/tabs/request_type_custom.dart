import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/etc/updated_return.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/request_type/request_type_bloc.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/features/master_data/widgets/master_data_item_card.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/loading_indicator.dart';
import 'package:pdpa/app/shared/widgets/screens/example_screen.dart';

class RequestTypeCustomTab extends StatefulWidget {
  const RequestTypeCustomTab({super.key});

  @override
  State<RequestTypeCustomTab> createState() => _RequestTypeCustomTabState();
}

class _RequestTypeCustomTabState extends State<RequestTypeCustomTab> {
  late UserModel currentUser;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    final bloc = context.read<SignInBloc>();
    if (bloc.state is SignedInUser) {
      currentUser = (bloc.state as SignedInUser).user;
    } else {
      currentUser = UserModel.empty();
    }
  }

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
}
