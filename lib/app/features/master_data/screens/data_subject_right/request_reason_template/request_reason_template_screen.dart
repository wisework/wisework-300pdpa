import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/master_data/request_reason_template_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/request_reason_tp/request_reason_tp_bloc.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/features/master_data/widgets/master_data_item_card.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class RequestReasonTemplateScreen extends StatefulWidget {
  const RequestReasonTemplateScreen({super.key});

  @override
  State<RequestReasonTemplateScreen> createState() =>
      _RequestReasonTemplateScreenState();
}

class _RequestReasonTemplateScreenState
    extends State<RequestReasonTemplateScreen> {
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
        .read<RequestReasonTpBloc>()
        .add(GetRequestReasonTpEvent(companyId: companyId));
  }

  @override
  Widget build(BuildContext context) {
    return const RequestReasonTemplateView();
  }
}

class RequestReasonTemplateView extends StatefulWidget {
  const RequestReasonTemplateView({super.key});

  @override
  State<RequestReasonTemplateView> createState() =>
      _RequestReasonTemplateViewState();
}

class _RequestReasonTemplateViewState extends State<RequestReasonTemplateView> {
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
          tr('masterData.dsr.requestreasons.title'),
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
              child: BlocBuilder<RequestReasonTpBloc, RequestReasonTpState>(
                builder: (context, state) {
                  if (state is GotRequestReasons) {
                    return ListView.builder(
                      itemCount: state.requestReasons.length,
                      itemBuilder: (context, index) {
                        return _buildItemCard(
                          context,
                          requestReason: state.requestReasons[index],
                        );
                      },
                    );
                  }
                  if (state is RequestReasonError) {
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
          context.push(MasterDataRoute.createRequestReason.path);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  MasterDataItemCard _buildItemCard(
    BuildContext context, {
    required RequestReasonTemplateModel requestReason,
  }) {
    final requestId = requestReason.requestTypeId;

    // final requestName = requestId.description.firstWhere(
    //   (item) => item.language == language,
    //   orElse: LocalizedModel.empty,
    // );
    // BlocBuilder<RequestTypeBloc, RequestTypeState>(
    //   builder: (context, state) {
    //     if (state is GotRequestTypes) {
    //       final requestName = state.requestTypes.where(
    //           (id) => requestReason.requestTypeId.contains(id.requestTypeId));
    //       print(requestName);
    //       final requestNamefilter =
    //           requestName.map((e) => e.description.first.text).toString();
    //       print(requestNamefilter);

    //       return MasterDataItemCard(
    //         title: requestNamefilter,
    //         subtitle: '',
    //         status: requestReason.status,
    //         onTap: () {
    //           context.push(
    //             MasterDataRoute.editRequestReason.path
    //                 .replaceFirst(':id', requestReason.requestReasonTemplateId),
    //           );
    //         },
    //       );
    //     }
    //     if (state is RequestTypeError) {
    //       return Center(
    //         child: Text(
    //           state.message,
    //           style: Theme.of(context).textTheme.bodyMedium,
    //         ),
    //       );
    //     }
    //     return const Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   },
    // );
    return MasterDataItemCard(
      title: requestId,
      subtitle: '',
      status: requestReason.status,
      onTap: () {
        context.push(
          MasterDataRoute.editRequestReason.path
              .replaceFirst(':id', requestReason.id),
        );
      },
    );
  }
}
