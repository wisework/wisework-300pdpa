import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/features/master_data/widgets/master_data_item_card.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
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

    debugPrint(companyId); // <-- use this company ID
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
  final reasontypemodel = [
    ReasonTypeModel(
        reasonTypeId: '1',
        reasonCode: '1',
        description: 'Test1',
        requiredInputReasonText: false,
        status: ActiveStatus.active,
        createdBy: '',
        createdDate: DateTime.fromMillisecondsSinceEpoch(0),
        updatedBy: '',
        updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        companyId: '1')
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
          title: Text(tr('masterData.dsr.reason.title'))),
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
              child: ListView.builder(
                itemCount: reasontypemodel.length,
                itemBuilder: (context, index) {
                  return _buildItemCard(
                    context,
                    reasontype: reasontypemodel[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(MasterDataRoute.createReasonType.path);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  MasterDataItemCard _buildItemCard(
    BuildContext context, {
    required ReasonTypeModel reasontype,
  }) {
    final description = reasontype.description;

    final reasoncode = reasontype.reasonCode;

    return MasterDataItemCard(
      title: description,
      subtitle: reasoncode,
      status: reasontype.status,
      onTap: () {
        context.push(
          MasterDataRoute.editPurpose.path
              .replaceFirst(':id', reasontype.reasonTypeId),
        );
      },
    );
  }
}
