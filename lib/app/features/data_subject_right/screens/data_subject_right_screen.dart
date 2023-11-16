import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/data_subject_right/bloc/data_subject_right/data_subject_right_bloc.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/features/data_subject_right/widgets/data_subject_right_card.dart';
import 'package:pdpa/app/shared/drawers/pdpa_drawer.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/loading_indicator.dart';
import 'package:pdpa/app/shared/widgets/screens/example_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class DataSubjectRightScreen extends StatefulWidget {
  const DataSubjectRightScreen({super.key});

  @override
  State<DataSubjectRightScreen> createState() => _DataSubjectRightScreenState();
}

class _DataSubjectRightScreenState extends State<DataSubjectRightScreen> {
  late String language;

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
      language = (bloc.state as SignedInUser).user.defaultLanguage;
    }

    final event = GetDataSubjectRightsEvent(companyId: companyId);
    context.read<DataSubjectRightBloc>().add(event);
  }

  @override
  Widget build(BuildContext context) {
    return DataSubjectRightView(
      language: language,
    );
  }
}

class DataSubjectRightView extends StatefulWidget {
  const DataSubjectRightView({
    super.key,
    required this.language,
  });

  final String language;

  @override
  State<DataSubjectRightView> createState() => _DataSubjectRightViewState();
}

class _DataSubjectRightViewState extends State<DataSubjectRightView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PdpaAppBar(
        leadingIcon: CustomIconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icons.menu_outlined,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          tr('app.features.datasubjectright'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          CustomIconButton(
            onPressed: () {},
            icon: Ionicons.link_outline,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
          CustomIconButton(
            onPressed: () {},
            icon: Ionicons.search_outline,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ContentWrapper(
          child: BlocBuilder<DataSubjectRightBloc, DataSubjectRightState>(
            builder: (context, state) {
              if (state is GotDataSubjectRights) {
                return _buildDataSubjectRightView(
                  context,
                  dataSubjectRights: state.dataSubjectRights,
                );
              }
              if (state is DataSubjectRightError) {
                return CustomContainer(
                  margin: const EdgeInsets.all(UiConfig.lineSpacing),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: UiConfig.defaultPaddingSpacing * 4,
                    ),
                    child: Center(
                      child: Text(
                        state.message,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                );
              }
              return const CustomContainer(
                margin: EdgeInsets.all(UiConfig.lineSpacing),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: UiConfig.defaultPaddingSpacing * 4,
                  ),
                  child: Center(
                    child: LoadingIndicator(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(DataSubjectRightRoute.createDataSubjectRight.path);
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

  CustomContainer _buildDataSubjectRightView(
    BuildContext context, {
    required List<DataSubjectRightModel> dataSubjectRights,
  }) {
    return CustomContainer(
      margin: const EdgeInsets.all(UiConfig.lineSpacing),
      child: Column(
        children: <Widget>[
          if (dataSubjectRights.isNotEmpty)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UiConfig.defaultPaddingSpacing,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          tr('consentManagement.consentForm.consentList'), //!
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      CustomButton(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2.0,
                          horizontal: 8.0,
                        ),
                        onPressed: () {
                          // _sortConsentForms(!_sortAscending);
                        },
                        buttonType: CustomButtonType.text,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              tr("consentManagement.listage.filter.date"),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(width: 2.0),
                            Icon(
                              1 != 1 //_sortAscending
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              size: 20.0,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: UiConfig.textSpacing),
              ],
            ),
          dataSubjectRights.isNotEmpty
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: dataSubjectRights.length,
                  itemBuilder: (context, index) {
                    return _buildDataSubjectRightCard(
                      context,
                      dataSubjectRight: dataSubjectRights[index],
                    );
                  },
                )
              : ExampleScreen(
                  headderText: tr(
                    'consentManagement.consentForm.consentForms',
                  ),
                  buttonText: tr(
                    'consentManagement.consentForm.createForm.create',
                  ),
                  descriptionText: tr(
                    'consentManagement.consentForm.explain',
                  ),
                  onPress: () {
                    context.push(
                      DataSubjectRightRoute.createDataSubjectRight.path,
                    );
                  },
                ),
        ],
      ),
    );
  }

  DataSubjectRightCard _buildDataSubjectRightCard(
    BuildContext context, {
    required DataSubjectRightModel dataSubjectRight,
  }) {
    final requests = ['เพิกถอนความยินยอม', 'ลบข้อมูลส่วนบุคคล'];
    return DataSubjectRightCard(
      title: dataSubjectRight.dataRequester.first.text,
      subtitle: requests,
      date: dataSubjectRight.updatedDate,
      status: UtilFunctions.getRequestProcessStatus(dataSubjectRight),
      onTap: () {
        context.push(
          DataSubjectRightRoute.processDataSubjectRight.path
              .replaceFirst(':id', dataSubjectRight.id),
        );
      },
    );
  }
}
