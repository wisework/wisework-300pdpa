import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/features/master_data/widgets/master_data_list_tile.dart';
import 'package:pdpa/app/shared/drawers/pdpa_drawer.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class MasterDataScreen extends StatelessWidget {
  MasterDataScreen({super.key});

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
          icon: Ionicons.menu_outline,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          tr('app.features.masterdata'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            _buildMandatorySection(context),
            const SizedBox(height: UiConfig.lineSpacing),
            _buildConsentSection(context),
            const SizedBox(height: UiConfig.lineSpacing),
            // _buildDataSubjectRightSection(context),
            // const SizedBox(height: UiConfig.lineSpacing),
          ],
        ),
      ),
      drawer: PdpaDrawer(
        onClosed: () {
          _scaffoldKey.currentState?.closeDrawer();
        },
      ),
    );
  }

  CustomContainer _buildMandatorySection(BuildContext context) {
    return CustomContainer(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                tr('masterData.main.mandatories'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          MasterDataListTile(
            trail: true,
            title: tr('masterData.main.mandatoryFields.list'),
            onTap: () {
              context.push(MasterDataRoute.mandatoryFields.path);
            },
          ),
        ],
      ),
    );
  }

  CustomContainer _buildConsentSection(BuildContext context) {
    return CustomContainer(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                tr('masterData.cm.consents'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          // MasterDataListTile(
          //   trail: true,
          //   title: tr('masterData.cm.customfields.list'),
          //   onTap: () {
          //     context.push(MasterDataRoute.customFields.path);
          //   },
          // ),
          MasterDataListTile(
            trail: true,
            title: tr('masterData.cm.purpose.list'),
            onTap: () {
              context.push(MasterDataRoute.purposes.path);
            },
          ),
          MasterDataListTile(
            trail: true,
            title: tr('masterData.cm.purposeCategory.list'),
            onTap: () {
              context.push(MasterDataRoute.purposesCategories.path);
            },
          ),
        ],
      ),
    );
  }

  // CustomContainer _buildDataSubjectRightSection(BuildContext context) {
  //   return CustomContainer(
  //     child: Column(
  //       children: <Widget>[
  //         Row(
  //           children: <Widget>[
  //             Text(
  //               tr('masterData.dsr.datasubjectright'),
  //               style: Theme.of(context).textTheme.titleLarge,
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: UiConfig.lineSpacing),
  //         MasterDataListTile(
  //           trail: true,
  //           title: tr('masterData.dsr.request.list'),
  //           onTap: () {
  //             context.push(MasterDataRoute.requestType.path);
  //           },
  //         ),
  //         MasterDataListTile(
  //           trail: true,
  //           title: tr('masterData.dsr.rejections.list'),
  //           onTap: () {
  //             context.push(MasterDataRoute.rejectType.path);
  //           },
  //         ),
  //         MasterDataListTile(
  //           trail: true,
  //           title: tr('masterData.dsr.reason.list'),
  //           onTap: () {
  //             context.push(MasterDataRoute.reasonType.path);
  //           },
  //         ),
  //         MasterDataListTile(
  //           trail: true,
  //           title: tr('masterData.dsr.requestrejects.list'),
  //           onTap: () {
  //             context.push(MasterDataRoute.requestReject.path);
  //           },
  //         ),
  //         MasterDataListTile(
  //           trail: true,
  //           title: tr('masterData.dsr.requestreasons.list'),
  //           onTap: () {
  //             context.push(MasterDataRoute.requestReason.path);
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
