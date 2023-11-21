import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/data/presets/reason_types_preset.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/features/master_data/widgets/master_data_item_card.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/screens/example_screen.dart';

class ReasonTypePresetTab extends StatefulWidget {
  const ReasonTypePresetTab({super.key});

  @override
  State<ReasonTypePresetTab> createState() => _ReasonTypePresetTabState();
}

class _ReasonTypePresetTabState extends State<ReasonTypePresetTab> {
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
            child: reasonTypesPreset.isNotEmpty
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: reasonTypesPreset.length,
                    itemBuilder: (context, index) {
                      return _buildItemCard(
                        context,
                        reasonType: reasonTypesPreset[index],
                        language: language,
                      );
                    },
                  )
                : ExampleScreen(
                    headderText: tr(
                      'masterData.cm.ReasonType.list',
                    ),
                    buttonText: tr(
                      'masterData.cm.ReasonType.create',
                    ),
                    descriptionText: tr(
                      'masterData.cm.ReasonType.explain',
                    ),
                    onPress: () {
                      context.push(MasterDataRoute.createReasonType.path);
                    },
                  ),
          ),
        ),
      ),
    );
  }

  MasterDataItemCard _buildItemCard(
    BuildContext context, {
    required ReasonTypeModel reasonType,
    required String language,
  }) {
    final description = reasonType.description.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );
    final reasonTypeCode = reasonType.reasonCode;

    return MasterDataItemCard(
      title: description.text,
      subtitle: reasonTypeCode,
      status: reasonType.status,
    );
  }
}
