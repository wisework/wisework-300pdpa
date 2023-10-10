import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/reject_type/reject_type_bloc.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/features/master_data/widgets/master_data_item_card.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
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
  final reqeustModel = [
    RejectTypeModel(
      rejectTypeId: '1',
      rejectCode: '1',
      description: const [],
      status: ActiveStatus.active,
      createdBy: '',
      createdDate: DateTime.fromMillisecondsSinceEpoch(0),
      updatedBy: '',
      updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
    )
  ];
  @override
  Widget build(BuildContext context) {
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
          tr('masterData.dsr.rejections.list'),
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
              child: BlocBuilder<RejectTypeBloc, RejectTypeState>(
                builder: (context, state) {
                  if (state is GotRejectTypes) {
                    return ListView.builder(
                      itemCount: state.rejectTypes.length,
                      itemBuilder: (context, index) {
                        return _buildItemCard(
                          context,
                          rejectType: state.rejectTypes[index],
                        );
                      },
                    );
                  }
                  if (state is RejectTypeError) {
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
          context.push(MasterDataRoute.createRejectType.path);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  MasterDataItemCard _buildItemCard(
    BuildContext context, {
    required RejectTypeModel rejectType,
  }) {
    const language = 'en-US';
    final description = rejectType.description.firstWhere(
      (item) => item.language == language,
      orElse: LocalizedModel.empty,
    );
    final rejectCode = rejectType.rejectCode;

    return MasterDataItemCard(
      title: description.text,
      subtitle: rejectCode,
      status: rejectType.status,
      onTap: () {
        context.push(
          MasterDataRoute.editRejectType.path
              .replaceFirst(':id', rejectType.rejectTypeId),
        );
      },
    );
  }
}
