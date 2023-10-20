import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/request_type/request_type_bloc.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/features/master_data/widgets/master_data_item_card.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
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
        .add(GetRequestTypeEvent(companyId: companyId));
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
          tr('masterData.dsr.request.list'),
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
              child: BlocBuilder<RequestTypeBloc, RequestTypeState>(
                builder: (context, state) {
                  if (state is GotRequestTypes) {
                    return ListView.builder(
                      itemCount: state.requestTypes.length,
                      itemBuilder: (context, index) {
                        return _buildItemCard(
                          context,
                          requestType: state.requestTypes[index],
                        );
                      },
                    );
                  }
                  if (state is RequestTypeError) {
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
          context.push(MasterDataRoute.createRequestType.path);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  MasterDataItemCard _buildItemCard(
    BuildContext context, {
    required RequestTypeModel requestType,
  }) {
    const language = 'en-US';
    final description = requestType.description.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );
    final requestCode = requestType.requestCode;

    return MasterDataItemCard(
      title: description.text,
      subtitle: requestCode,
      status: requestType.status,
      onTap: () {
        context.push(
          MasterDataRoute.editRequestType.path
              .replaceFirst(':id', requestType.requestTypeId),
        );
      },
    );
  }
}
