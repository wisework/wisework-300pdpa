import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/etc/updated_return.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/consent/purpose/purpose_bloc.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/features/master_data/widgets/master_data_item_card.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/loading_indicator.dart';
import 'package:pdpa/app/shared/widgets/screens/example_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class PurposeScreen extends StatefulWidget {
  const PurposeScreen({super.key});

  @override
  State<PurposeScreen> createState() => _PurposeScreenState();
}

class _PurposeScreenState extends State<PurposeScreen> {
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

    context.read<PurposeBloc>().add(GetPurposesEvent(companyId: companyId));
  }

  @override
  Widget build(BuildContext context) {
    return const PurposeView();
  }
}

class PurposeView extends StatefulWidget {
  const PurposeView({super.key});

  @override
  State<PurposeView> createState() => _PurposeViewState();
}

class _PurposeViewState extends State<PurposeView> {
  void _onUpdated(UpdatedReturn<PurposeModel> updated) {
    final event = UpdatePurposesChangedEvent(
      purpose: updated.object,
      updateType: updated.type,
    );
    context.read<PurposeBloc>().add(event);
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
          icon: Ionicons.chevron_back_outline,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          tr('masterData.cm.purpose.list'), //!
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: UiConfig.lineSpacing),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              child: BlocBuilder<PurposeBloc, PurposeState>(
                builder: (context, state) {
                  if (state is GotPurposes) {
                    if (state.purposes.isEmpty) {
                      return ExampleScreen(
                        headderText: tr('masterData.cm.purpose.list'),
                        buttonText: tr('masterData.cm.purpose.create'),
                        descriptionText: tr('masterData.cm.purpose.explain'),
                        onPress: () {
                          context.push(MasterDataRoute.createPurpose.path);
                        },
                      );
                    }
                    return ListView.builder(
                      itemCount: state.purposes.length,
                      itemBuilder: (context, index) {
                        return _buildItemCard(context,
                            purpose: state.purposes[index],
                            onUpdated: _onUpdated,
                            language: language);
                      },
                    );
                  }
                  if (state is PurposeError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }
                  return const Center(
                    child: LoadingIndicator(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push(MasterDataRoute.createPurpose.path).then((value) {
            if (value != null) {
              _onUpdated(value as UpdatedReturn<PurposeModel>);
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  MasterDataItemCard _buildItemCard(
    BuildContext context, {
    required PurposeModel purpose,
    required Function(UpdatedReturn<PurposeModel> updated) onUpdated,
    required String language,
  }) {
    final description = purpose.description.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );
    final warningDescription = purpose.warningDescription.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );

    return MasterDataItemCard(
      title: description.text,
      subtitle: warningDescription.text,
      status: purpose.status,
      onTap: () async {
        await context
            .push(MasterDataRoute.editPurpose.path
                .replaceFirst(':id', purpose.id))
            .then((value) {
          if (value != null) {
            onUpdated(value as UpdatedReturn<PurposeModel>);
          }
        });
      },
    );
  }
}
