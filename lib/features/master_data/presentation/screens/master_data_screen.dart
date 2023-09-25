import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pdpa/features/master_data/presentation/widgets/consent_masterdata.dart';
import 'package:pdpa/features/master_data/presentation/widgets/datasubjectright_masterdata.dart';

class MasterDataScreen extends StatelessWidget {
  const MasterDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Wrap(
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  // Builder(
                  //   builder: (context) {
                  //     return IconButton(
                  //       onPressed: () {
                  //         Scaffold.of(context).openDrawer();
                  //       },
                  //       icon: Padding(
                  //         padding: const EdgeInsets.symmetric(vertical: 5.0),
                  //         child: Container(
                  //           padding: const EdgeInsets.all(5.0),
                  //           decoration: const BoxDecoration(
                  //             shape: BoxShape.circle,
                  //           ),
                  //           child: SvgPicture.asset(
                  //               "assets/icons/svg/menu-drawer.svg"),
                  //         ),
                  //       ),
                  //       color: Theme.of(context).colorScheme.secondary,
                  //     );
                  //   },
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      tr('app.feature.masterdata'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
      ),
      backgroundColor: Theme.of(context).colorScheme.outline,
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              ConsentMaster(),
              SizedBox(height: 10.0),
              DataSubjectRightMaster(),
            ],
          ),
        ),
      ),
    );
  }
}

