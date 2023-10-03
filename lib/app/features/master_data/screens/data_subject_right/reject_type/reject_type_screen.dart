import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';

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

    debugPrint(companyId); // <-- use this company ID
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
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
              // child: ListView.builder(
              //   itemCount: purposes.length,
              //   itemBuilder: (context, index) {
              //     return _buildItemCard(
              //       context,
              //       purpose: purposes[index],
              //     );
              //   },
              // ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(MasterDataRoute.createPurpose.path);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: <Widget>[
          CustomIconButton(
            onPressed: () {
              context.pop();
            },
            icon: Ionicons.chevron_back_outline,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
          const SizedBox(width: UiConfig.appBarTitleSpacing),
          Text(
            'Purpose',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  // MasterDataItemCard _buildItemCard(
  //   BuildContext context, {
  //   required PurposeModel purpose,
  // }) {
  //   const language = 'en-US';
  //   final description = purpose.description.firstWhere(
  //     (item) => item.language == language,
  //     orElse: LocalizedText.empty,
  //   );
  //   final warningDescription = purpose.warningDescription.firstWhere(
  //     (item) => item.language == language,
  //     orElse: LocalizedText.empty,
  //   );

  //   return MasterDataItemCard(
  //     title: description.text,
  //     subtitle: warningDescription.text,
  //     status: purpose.status,
  //   );
  // }
}
