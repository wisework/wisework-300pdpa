import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_request_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/features/data_subject_right/widgets/data_subject_right_item_card.dart';
import 'package:pdpa/app/features/master_data/bloc/consent/purpose/purpose_bloc.dart';
import 'package:pdpa/app/shared/drawers/pdpa_drawer.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class DataSubjectRightScreen extends StatefulWidget {
  const DataSubjectRightScreen({super.key});

  @override
  State<DataSubjectRightScreen> createState() => _DataSubjectRightScreenState();
}

class _DataSubjectRightScreenState extends State<DataSubjectRightScreen> {
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
    return const DataSubjectRightView();
  }
}

class DataSubjectRightView extends StatefulWidget {
  const DataSubjectRightView({super.key});

  @override
  State<DataSubjectRightView> createState() => _DataSubjectRightViewState();
}

class _DataSubjectRightViewState extends State<DataSubjectRightView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final dsrMock = [
      DataSubjectRightRequestModel(
        id: '1',
        dataRequester: const [
          LocalizedModel(language: 'en-US', text: 'Test1'),
        ],
        dataOwner: const [],
        isDataOwner: true,
        powerVerifications: const [],
        identityVerifications: const [],
        processRequests: const [
          LocalizedModel(language: 'en-US', text: 'Inprogess'),
        ],
        requestExpirationDate: DateTime.now(),
        notifyEmail: const [],
        requestFormVerified: true,
        verifyRequest: const [],
        resultRequest: true,
        verifyReason: '',
        lastSeenBy: '',
        status: ActiveStatus.active,
        createdBy: '',
        createdDate: DateTime.now(),
        updatedBy: '',
        updatedDate: DateTime.now(),
      ),
      DataSubjectRightRequestModel(
        id: '2',
        dataRequester: const [
          LocalizedModel(language: 'en-US', text: 'Test2'),
        ],
        dataOwner: const [],
        isDataOwner: true,
        powerVerifications: const [],
        identityVerifications: const [],
        processRequests: const [
          LocalizedModel(language: 'en-US', text: 'Inprogess'),
        ],
        requestExpirationDate: DateTime.now(),
        notifyEmail: const [],
        requestFormVerified: true,
        verifyRequest: const [],
        resultRequest: true,
        verifyReason: '',
        lastSeenBy: '',
        status: ActiveStatus.active,
        createdBy: '',
        createdDate: DateTime.now(),
        updatedBy: '',
        updatedDate: DateTime.now(),
      ),
    ];
    return Scaffold(
      key: _scaffoldKey,
      appBar: PdpaAppBar(
        leadingIcon: CustomIconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Ionicons.menu_outline,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          tr('app.features.datasubjectright'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        // appBarHeight: 100,
        actions: [
          CustomIconButton(
            onPressed: () {},
            icon: Ionicons.link,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
          const SizedBox(width: UiConfig.lineSpacing),
          CustomIconButton(
            onPressed: () {},
            icon: Ionicons.search,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
        ],
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
                    return ListView.builder(
                      itemCount: dsrMock.length,
                      itemBuilder: (context, index) {
                        return _buildItemCard(context,
                            dsrRequest: dsrMock[index]);
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
          context.push(DataSubjectRightRouter.intro.path);
        },
        child: const Icon(Icons.add),
      ),
      drawer: PdpaDrawer(
        onClosed: () {
          _scaffoldKey.currentState?.closeDrawer();
        },
      ),
    );
  }

  DataSubjectRightItemCard _buildItemCard(
    BuildContext context, {
    required DataSubjectRightRequestModel dsrRequest,
  }) {
    const language = 'en-US';
    final description = dsrRequest.dataRequester.firstWhere(
      (item) => item.language == language,
      orElse: LocalizedModel.empty,
    );
    final requestCode = dsrRequest.processRequests.firstWhere(
      (item) => item.language == language,
      orElse: LocalizedModel.empty,
    );

    return DataSubjectRightItemCard(
      title: description.text,
      subtitle: requestCode.text,
      date: dsrRequest.requestExpirationDate.toString(),
      onTap: () {
        // context.push(
        //   DataSubjectRightRouter
        // );
      },
    );
  }
}
