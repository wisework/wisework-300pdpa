import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/reject_type/reject_type_bloc.dart';
import 'package:pdpa/app/features/master_data/screens/data_subject_right/reject_type/tabs/reject_type_custom.dart';
import 'package:pdpa/app/features/master_data/screens/data_subject_right/reject_type/tabs/reject_type_preset.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

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

    context
        .read<RejectTypeBloc>()
        .add(GetRejectTypeEvent(companyId: companyId));
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
            tr('masterData.dsr.reject.list'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                text: tr(
                  'คำปฏิเสธทีสามารถแก้ไข',
                ),
              ),
              Tab(
                text: tr(
                  'คำปฏิเสธตั้งต้น',
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
            RejectTypeCustomTab(),
            RejectTypePresetTab(),
          ],
        ),
      ),
    );
  }
}
