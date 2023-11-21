import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/etc/updated_return.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/reject_type/reject_type_bloc.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/features/master_data/widgets/master_data_item_card.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/loading_indicator.dart';
import 'package:pdpa/app/shared/widgets/screens/example_screen.dart';

class RejectTypeCustomTab extends StatefulWidget {
  const RejectTypeCustomTab({super.key});

  @override
  State<RejectTypeCustomTab> createState() => _RejectTypeCustomTabState();
}

class _RejectTypeCustomTabState extends State<RejectTypeCustomTab> {
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
      body: SingleChildScrollView(
        child: ContentWrapper(
          child: BlocBuilder<RejectTypeBloc, RejectTypeState>(
            builder: (context, state) {
              if (state is GotRejectTypes) {
                return CustomContainer(
                  margin: const EdgeInsets.all(UiConfig.lineSpacing),
                  child: state.rejectTypes.isNotEmpty
                      ? ListView.builder(
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
                        )
                      : ExampleScreen(
                          headderText: tr(
                            'masterData.cm.RejectType.list',
                          ),
                          buttonText: tr(
                            'masterData.cm.RejectType.create',
                          ),
                          descriptionText: tr(
                            'masterData.cm.RejectType.explain',
                          ),
                          onPress: () {
                            context.push(MasterDataRoute.createRejectType.path);
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
}
