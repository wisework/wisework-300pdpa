import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/master_data/request_reject_template_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/request_reject_tp/request_reject_tp_bloc.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/features/master_data/widgets/master_data_item_card.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class RequestRejectTemplateScreen extends StatefulWidget {
  const RequestRejectTemplateScreen({super.key});

  @override
  State<RequestRejectTemplateScreen> createState() =>
      _RequestRejectTemplateScreenState();
}

class _RequestRejectTemplateScreenState
    extends State<RequestRejectTemplateScreen> {
  void _initialData() {
    final bloc = context.read<SignInBloc>();

    String companyId = '';
    if (bloc.state is SignedInUser) {
      companyId = (bloc.state as SignedInUser).user.currentCompany;
    }

    context
        .read<RequestRejectTpBloc>()
        .add(GetRequestRejectTpEvent(companyId: companyId));
  }

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  @override
  Widget build(BuildContext context) {
    return const RequestRejectTemplateView();
  }
}

class RequestRejectTemplateView extends StatefulWidget {
  const RequestRejectTemplateView({super.key});

  @override
  State<RequestRejectTemplateView> createState() =>
      _RequestRejectTemplateViewState();
}

class _RequestRejectTemplateViewState extends State<RequestRejectTemplateView> {
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
          tr('masterData.dsr.requestrejects.title'),
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
              child: BlocBuilder<RequestRejectTpBloc, RequestRejectTpState>(
                builder: (context, state) {
                  if (state is GotRequestRejects) {
                    return ListView.builder(
                      itemCount: state.requestRejects.length,
                      itemBuilder: (context, index) {
                        return _buildItemCard(
                          context,
                          requestReason: state.requestRejects[index],
                        );
                      },
                    );
                  }
                  if (state is RequestRejectError) {
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
          context.push(MasterDataRoute.createRequestReject.path);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  MasterDataItemCard _buildItemCard(
    BuildContext context, {
    required RequestRejectTemplateModel requestReason,
  }) {
    final description = requestReason.requestTypeId;

    return MasterDataItemCard(
      title: description,
      subtitle: '',
      status: requestReason.status,
      onTap: () {
        context.push(
          MasterDataRoute.editRequestType.path
              .replaceFirst(':id', requestReason.requestRejectTemplateId),
        );
      },
    );
  }
}
