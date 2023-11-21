import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/data/presets/reject_types_preset.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/features/master_data/widgets/master_data_item_card.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/screens/example_screen.dart';

class RejectTypePresetTab extends StatefulWidget {
  const RejectTypePresetTab({super.key});

  @override
  State<RejectTypePresetTab> createState() => _RejectTypePresetTabState();
}

class _RejectTypePresetTabState extends State<RejectTypePresetTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SignInBloc>();

    String language = '';
    if (bloc.state is SignedInUser) {
      language = (bloc.state as SignedInUser).user.defaultLanguage;
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: ContentWrapper(
          child: CustomContainer(
            margin: const EdgeInsets.all(UiConfig.lineSpacing),
            child: rejectTypesPreset.isNotEmpty
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: rejectTypesPreset.length,
                    itemBuilder: (context, index) {
                      return _buildItemCard(
                        context,
                        rejectType: rejectTypesPreset[index],
                        language: language,
                      );
                    },
                  )
                : ExampleScreen(
                    headderText: tr(
                      'masterData.cm.RejectType.list',
                    ),
                    buttonText: tr(
                      'masterData.cm.RejectType.create',
                    ),
                    descriptionText: tr(
                      'masterData.cm.RejectType.explain',
                    ),
                    onPress: () {
                      context.push(MasterDataRoute.createRejectType.path);
                    },
                  ),
          ),
        ),
      ),
    );
  }

  MasterDataItemCard _buildItemCard(
    BuildContext context, {
    required RejectTypeModel rejectType,
    required String language,
  }) {
    final description = rejectType.description.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );
    final rejectTypeCode = rejectType.rejectCode;

    return MasterDataItemCard(
      title: description.text,
      subtitle: rejectTypeCode,
      status: rejectType.status,
    );
  }
}
