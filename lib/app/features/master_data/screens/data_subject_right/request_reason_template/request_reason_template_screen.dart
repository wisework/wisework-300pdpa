import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/etc/updated_return.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/request_reason_template_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
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
    return RequestReasonTemplateView();
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
                          request: state.requests,
                          language: language,
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
    required List<RequestTypeModel> request,
    required String language,
  }) {
    final requestId = requestReason.requestTypeId;
    final requestFilter =
        request.firstWhere((element) => element.id.contains(requestId));
    final title = requestFilter.description.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );
    return MasterDataItemCard(
      title: title.text,
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

  // MasterDataItemCard _buildItemCard(
  //   BuildContext context, {
  //   required RequestReasonTemplateModel requestReason,
  //   required Function(UpdatedReturn<RequestReasonTemplateModel> updated)
  //       onUpdated,
  //   required String language,
  // }) {

  //   final title = requestReason.requestTypeId.firstWhere(
  //     (item) => item.language == language,
  //     orElse: () => const LocalizedModel.empty(),
  //   );

  //   final reason = requestReason.reasonTypesId.firstWhere(
  //     (item) => item.language == language,
  //     orElse: () => const LocalizedModel.empty(),
  //   );

  //   return MasterDataItemCard(
  //     title: title.text,
  //     subtitle: reason.text,
  //     status: requestReason.status,
  //     onTap: () async {
  //       await context
  //           .push(MasterDataRoute.editRequestReason.path
  //               .replaceFirst(':id', requestReason.id))
  //           .then((value) {
  //         if (value != null) {
  //           onUpdated(value as UpdatedReturn<RequestReasonTemplateModel>);
  //         }
  //       });
  //     },
  //   );
  // }
}
