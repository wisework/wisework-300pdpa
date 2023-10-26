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

    context
        .read<DataSubjectRightBloc>()
        .add(GetDataSubjectRightsEvent(companyId: companyId));
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
              child: BlocBuilder<DataSubjectRightBloc, DataSubjectRightState>(
                builder: (context, state) {
                  if (state is GotDataSubjectRights) {
                    return ListView.builder(
                      itemCount: state.dataSubjectRights.length,
                      itemBuilder: (context, index) {
                        return _buildDataSubjectRightCard(
                          context,
                          dataSubjectRight: state.dataSubjectRights[index],
                        );
                      },
                    );
                  }
                  if (state is DataSubjectRightError) {
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
          DataSubjectRightRoute.editDataSubjectRight.path
              .replaceFirst(':id', dataSubjectRight.id),
        );
      },
    );
  }
}
