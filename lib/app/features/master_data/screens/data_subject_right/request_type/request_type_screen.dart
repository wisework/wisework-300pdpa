import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/request_type/request_type_bloc.dart';
import 'package:pdpa/app/features/master_data/screens/data_subject_right/request_type/tabs/request_type_custom.dart';
import 'package:pdpa/app/features/master_data/screens/data_subject_right/request_type/tabs/request_type_preset.dart';
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
        .add(GetRequestTypesEvent(companyId: companyId));
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int tabIndex = 0;

  void _setTabIndex(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
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
            tr('masterData.dsr.request.list'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                text: tr(
                  'คำขอทีสามารถแก้ไข',
                ),
              ),
              Tab(
                text: tr(
                  'คำขอตั้งต้น',
                ),
              ),
            ],
            // isScrollable: true,
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Theme.of(context).colorScheme.primary,
            labelStyle: Theme.of(context).textTheme.bodySmall,
            onTap: _setTabIndex,
          ),
          appBarHeight: 100.0,
        ),
        body: const TabBarView(
          children: <Widget>[
            RequestTypeCustomTab(),
            RequestTypePresetTab(),
          ],
        ),
      ),
    );
  }
}
