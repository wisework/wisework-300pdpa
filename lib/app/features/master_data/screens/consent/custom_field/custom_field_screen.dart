import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/consent/custom_field/custom_field_bloc.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/features/master_data/widgets/master_data_item_card.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/screens/example_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class CustomFieldScreen extends StatefulWidget {
  const CustomFieldScreen({super.key});

  @override
  State<CustomFieldScreen> createState() => _CustomFieldScreenState();
}

class _CustomFieldScreenState extends State<CustomFieldScreen> {
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
        .read<CustomFieldBloc>()
        .add(GetCustomFieldEvent(companyId: companyId));
  }

  @override
  Widget build(BuildContext context) {
    return const CustomFieldView();
  }
}

class CustomFieldView extends StatefulWidget {
  const CustomFieldView({super.key});

  @override
  State<CustomFieldView> createState() => _CustomFieldViewState();
}

class _CustomFieldViewState extends State<CustomFieldView> {
  final Map<TextInputType, String> customInputTypeNames = {
    TextInputType.text: tr('app.text'),
    TextInputType.multiline: tr('app.multiline'),
    TextInputType.number: tr('app.number'),
    TextInputType.phone: tr('app.phone'),
    TextInputType.emailAddress: tr('app.emailAddress'),
    TextInputType.url: tr('app.url'),
  };

  @override
  Widget build(BuildContext context) {
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
          tr('masterData.cm.customfields.list'),
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
              child: BlocBuilder<CustomFieldBloc, CustomFieldState>(
                builder: (context, state) {
                  if (state is GotCustomFields) {
                    return state.customfields.isNotEmpty
                        ? ListView.builder(
                            itemCount: state.customfields.length,
                            itemBuilder: (context, index) {
                              return _buildItemCard(
                                context,
                                customfield: state.customfields[index],
                              );
                            },
                          )
                        : ExampleScreen(
                            headderText: tr('masterData.cm.customfields.list'),
                            buttonText: tr('masterData.cm.customfields.create'),
                            descriptionText:
                                tr('masterData.cm.customfields.explain'),
                            onPress: () {
                              context
                                  .push(MasterDataRoute.createCustomField.path);
                            });
                  }
                  if (state is CustomfieldError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(MasterDataRoute.createCustomField.path);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  MasterDataItemCard _buildItemCard(
    BuildContext context, {
    required CustomFieldModel customfield,
  }) {
    const language = 'en-US';
    final title = customfield.title.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );

    return MasterDataItemCard(
      title: title.text,
      subtitle: customInputTypeNames[customfield.inputType].toString(),
      status: customfield.status,
      onTap: () {
        context.push(
          MasterDataRoute.editCustomField.path
              .replaceFirst(':id', customfield.id),
        );
      },
    );
  }
}
