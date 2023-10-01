import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/features/master_data/widgets/master_data_item_card.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';

class RequestTypeScreen extends StatefulWidget {
  const RequestTypeScreen({super.key});

  @override
  State<RequestTypeScreen> createState() => _RequestTypeScreenState();
}

class _RequestTypeScreenState extends State<RequestTypeScreen> {
  late String companyId;

  @override
  void initState() {
    super.initState();

    _getCompanyId();
  }

  void _getCompanyId() {
    final signInBloc = BlocProvider.of<SignInBloc>(context, listen: false);
    if (signInBloc.state is SignedInUser) {
      final signedIn = signInBloc.state as SignedInUser;
      companyId = signedIn.user.currentCompany;
    } else {
      companyId = '';
    }
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
  final reqeustModel = [
    RequestTypeModel(
        requestTypeId: '1',
        requestCode: '1',
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
              child: ListView.builder(
                itemCount: reqeustModel.length,
                itemBuilder: (context, index) {
                  return _buildItemCard(
                    context,
                    requestType: reqeustModel[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(MasterDataRoute.createRequestType.path);
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
            'requestType',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  MasterDataItemCard _buildItemCard(
    BuildContext context, {
    required RequestTypeModel requestType,
  }) {
    final description = requestType.description;
    final warningDescription = requestType.requestCode;

    return MasterDataItemCard(
      title: description,
      subtitle: warningDescription,
      status: requestType.status,
      onTap: () {},
    );
  }
}
