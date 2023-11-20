import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/etc/updated_return.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/reason_type/reason_type_bloc.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/features/master_data/widgets/master_data_item_card.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/loading_indicator.dart';
import 'package:pdpa/app/shared/widgets/screens/example_screen.dart';

class ReasonTypeCustomTab extends StatefulWidget {
  const ReasonTypeCustomTab({super.key});

  @override
  State<ReasonTypeCustomTab> createState() => _ReasonTypeCustomTabState();
}

class _ReasonTypeCustomTabState extends State<ReasonTypeCustomTab> {
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
      body: SingleChildScrollView(
        child: ContentWrapper(
          child: BlocBuilder<ReasonTypeBloc, ReasonTypeState>(
            builder: (context, state) {
              if (state is GotReasonTypes) {
                return CustomContainer(
                  margin: const EdgeInsets.all(UiConfig.lineSpacing),
                  child: state.reasonTypes.isNotEmpty
                      ? ListView.builder(
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
                        )
                      : ExampleScreen(
                          headderText: tr(
                            'masterData.cm.ReasonType.list',
                          ),
                          buttonText: tr(
                            'masterData.cm.ReasonType.create',
                          ),
                          descriptionText: tr(
                            'masterData.cm.ReasonType.explain',
                          ),
                          onPress: () {
                            context
                                .push(MasterDataRoute.createReasonType.path);
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
}
