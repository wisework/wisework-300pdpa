import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/requester_verification_model.dart';
import 'package:pdpa/app/data/models/etc/updated_return.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/data/presets/identity_proofing_preset.dart';
import 'package:pdpa/app/data/presets/power_verification_preset.dart';
import 'package:pdpa/app/data/presets/request_actions_preset.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/data_subject_right/bloc/data_subject_right/data_subject_right_bloc.dart';
import 'package:pdpa/app/features/data_subject_right/bloc/edit_data_subject_right/edit_data_subject_right_bloc.dart';
import 'package:pdpa/app/features/data_subject_right/screens/process_data_subject_right/process_data_subject_right.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/utils/toast.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_radio_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/download_file_field.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class EditDataSubjectRightScreen extends StatefulWidget {
  const EditDataSubjectRightScreen({
    super.key,
    required this.dataSubjectRightId,
    required this.processRequestId,
  });

  final String dataSubjectRightId;
  final String processRequestId;

  @override
  State<EditDataSubjectRightScreen> createState() =>
      _EditDataSubjectRightScreenState();
}

class _EditDataSubjectRightScreenState
    extends State<EditDataSubjectRightScreen> {
  late UserModel currentUser;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    final bloc = context.read<SignInBloc>();
    if (bloc.state is SignedInUser) {
      currentUser = (bloc.state as SignedInUser).user;
    } else {
      currentUser = UserModel.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditDataSubjectRightBloc>(
      create: (context) => serviceLocator<EditDataSubjectRightBloc>()
        ..add(
          GetCurrentDataSubjectRightEvent(
            dataSubjectRightId: widget.dataSubjectRightId,
            companyId: currentUser.currentCompany,
          ),
        ),
      child: BlocConsumer<EditDataSubjectRightBloc, EditDataSubjectRightState>(
        listener: (context, state) {
          if (state is CreatedCurrentDataSubjectRight) {
            showToast(
              context,
              text: tr('dataSubjectRight.editDataSubjectRight.createSuccess'),
            );

            final event = UpdateDataSubjectRightsEvent(
              dataSubjectRight: state.dataSubjectRight,
              updateType: UpdateType.created,
            );
            context.read<DataSubjectRightBloc>().add(event);

            context.pop();
          }

          if (state is UpdatedCurrentDataSubjectRight) {
            showToast(
              context,
              text: tr('dataSubjectRight.editDataSubjectRight.updateSuccess'),
            );
          }
        },
        builder: (context, state) {
          if (state is GotCurrentDataSubjectRight) {
            return EditDataSubjectRightView(
              initialDataSubjectRight: state.dataSubjectRight,
              processRequestSelected: widget.processRequestId,
              requestTypes: state.requestTypes,
              reasonTypes: state.reasonTypes,
              rejectTypes: state.rejectTypes,
              userEmails: state.userEmails,
              currentUser: currentUser,
            );
          }
          if (state is UpdatedCurrentDataSubjectRight) {
            return EditDataSubjectRightView(
              initialDataSubjectRight: state.dataSubjectRight,
              processRequestSelected: widget.processRequestId,
              requestTypes: state.requestTypes,
              reasonTypes: state.reasonTypes,
              rejectTypes: state.rejectTypes,
              userEmails: state.userEmails,
              currentUser: currentUser,
            );
          }
          if (state is EditDataSubjectRightError) {
            return ErrorMessageScreen(message: state.message);
          }

          return const LoadingScreen();
        },
      ),
    );
  }
}

class EditDataSubjectRightView extends StatefulWidget {
  const EditDataSubjectRightView({
    super.key,
    required this.initialDataSubjectRight,
    required this.processRequestSelected,
    required this.requestTypes,
    required this.reasonTypes,
    required this.rejectTypes,
    required this.userEmails,
    required this.currentUser,
  });

  final DataSubjectRightModel initialDataSubjectRight;
  final String processRequestSelected;
  final List<RequestTypeModel> requestTypes;
  final List<ReasonTypeModel> reasonTypes;
  final List<RejectTypeModel> rejectTypes;
  final List<String> userEmails;
  final UserModel currentUser;

  @override
  State<EditDataSubjectRightView> createState() =>
      _EditDataSubjectRightViewState();
}

class _EditDataSubjectRightViewState extends State<EditDataSubjectRightView> {
  late DataSubjectRightModel dataSubjectRight;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    dataSubjectRight = widget.initialDataSubjectRight;
  }

  void _goBackAndUpdate() {
    context.pop(
      UpdatedReturn<DataSubjectRightModel>(
        object: widget.initialDataSubjectRight,
        type: UpdateType.updated,
      ),
    );
  }

  void _onProcessRequestPressed() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProcessDataSubjectRightScreen(
          initialDataSubjectRight: dataSubjectRight,
          requestTypes: widget.requestTypes,
          reasonTypes: widget.reasonTypes,
          rejectTypes: widget.rejectTypes,
          processRequestSelected: widget.processRequestSelected,
          currentUser: widget.currentUser,
          userEmails: widget.userEmails,
        ),
      ),
    ).then((result) {
      if (result != null) {
        final updated = result as DataSubjectRightModel;
        if (dataSubjectRight != updated) {
          _updateEditDsrState(updated);
        }
      }
    });
  }

  void _updateEditDsrState(DataSubjectRightModel dataSubjectRight) {
    final event = UpdateEditDataSubjectRightStateEvent(
      dataSubjectRight: dataSubjectRight,
    );
    context.read<EditDataSubjectRightBloc>().add(event);
  }

  void _onDownloadFile(String path) {
    final event = DownloadDataSubjectRightFileEvent(path: path);
    context.read<EditDataSubjectRightBloc>().add(event);

    showToast(context, text: 'ดาวน์โหลดไฟล์สำเร็จ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(),
        title: Text(
          tr('dataSubjectRight.editDataSubjectRight.title1'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: ContentWrapper(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: UiConfig.lineSpacing),
                    CustomContainer(
                      child: _buildDataSubjectRightForm(context),
                    ),
                    const SizedBox(height: UiConfig.lineSpacing),
                  ],
                ),
              ),
            ),
          ),
          ContentWrapper(
            child: Container(
              padding: const EdgeInsets.all(
                UiConfig.defaultPaddingSpacing,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.outline,
                    blurRadius: 1.0,
                    offset: const Offset(0, -2.0),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  CustomButton(
                    onPressed: _onProcessRequestPressed,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 12.0,
                      ),
                      child: Text(
                        tr('dataSubjectRight.editDataSubjectRight.conductAninspection'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  CustomIconButton _buildPopButton() {
    return CustomIconButton(
      onPressed: _goBackAndUpdate,
      icon: Icons.chevron_left_outlined,
      iconColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  Column _buildDataSubjectRightForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          tr('dataSubjectRight.editDataSubjectRight.detail'),
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        _buildDivider(context),
        _buildDataRequesterInfo(context),
        _buildDivider(context),
        _buildCheckDataOwner(context),
        _buildDivider(context),
        if (!dataSubjectRight.isDataOwner)
          Column(
            children: <Widget>[
              _buildPowerProofInfo(
                context,
                verifications: dataSubjectRight.powerVerifications,
              ),
              _buildDivider(context),
              _buildDataOwnerInfo(context),
              _buildDivider(context),
              _buildIdentityProofInfo(
                context,
                verifications: dataSubjectRight.identityVerifications,
              ),
              _buildDivider(context),
            ],
          ),
        _buildProcessRequestInfo(context),
      ],
    );
  }

  Column _buildDataRequesterInfo(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          tr('dataSubjectRight.editDataSubjectRight.ApplicantInformation'),
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final input = dataSubjectRight.dataRequester[index];
            final title = input.title.firstWhere(
              (item) => item.language == widget.currentUser.defaultLanguage,
              orElse: () => const LocalizedModel.empty(),
            );

            return Column(
              children: <Widget>[
                TitleRequiredText(text: title.text),
                CustomTextField(
                  controller: TextEditingController(
                    text: input.text,
                  ),
                  readOnly: true,
                ),
              ],
            );
          },
          itemCount: dataSubjectRight.dataRequester.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: UiConfig.lineSpacing,
          ),
        ),
      ],
    );
  }

  Column _buildCheckDataOwner(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          tr('dataSubjectRight.editDataSubjectRight.title2'),
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomRadioButton<bool>(
              value: true,
              selected: dataSubjectRight.isDataOwner,
              onChanged: null,
              activeColor: Theme.of(context).colorScheme.outlineVariant,
              margin: const EdgeInsets.only(right: UiConfig.actionSpacing),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  tr('dataSubjectRight.editDataSubjectRight.applicantDs'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: UiConfig.lineGap),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomRadioButton<bool>(
              value: false,
              selected: dataSubjectRight.isDataOwner,
              onChanged: null,
              activeColor: Theme.of(context).colorScheme.outlineVariant,
              margin: const EdgeInsets.only(right: UiConfig.actionSpacing),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  tr('dataSubjectRight.editDataSubjectRight.ApplicantAds'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column _buildPowerProofInfo(
    BuildContext context, {
    required List<RequesterVerificationModel> verifications,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'เอกสารพิสูจน์อำนาจดำเนินการแทน',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        Text(
          'ทั้งนี้ข้าพเจ้าได้แนบเอกสารดังต่อไปนี้เพื่อการตรวจสอบอำนาจตัวตนและถิ่นที่อยู่ของผู้ยื่นคำร้องและเจ้าของข้อมูลส่วนบุคคลเพื่อให้บริษัทสามารถดำเนินการตามสิทธิที่ร้องขอได้อย่างถูกต้อง',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final verification = UtilFunctions.getVerificationById(
              powerVerificationsPreset,
              verifications[index].id,
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${index + 1}. ${verification.title}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (!verification.additionalReq)
                  Padding(
                    padding: const EdgeInsets.only(top: UiConfig.lineGap),
                    child: Text(
                      'ประเภทเอกสาร: ${verifications[index].text}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                const SizedBox(height: UiConfig.lineGap),
                DownloadFileField(
                  fileUrl: verifications[index].imageUrl,
                  onDownloaded: _onDownloadFile,
                  alignment: Alignment.centerLeft,
                ),
              ],
            );
          },
          itemCount: verifications.length,
        ),
      ],
    );
  }

  Column _buildDataOwnerInfo(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          tr('dataSubjectRight.editDataSubjectRight.title3'),
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final input = dataSubjectRight.dataOwner[index];
            final title = input.title.firstWhere(
              (item) => item.language == widget.currentUser.defaultLanguage,
              orElse: () => const LocalizedModel.empty(),
            );

            return Column(
              children: <Widget>[
                TitleRequiredText(text: title.text),
                CustomTextField(
                  controller: TextEditingController(
                    text: input.text,
                  ),
                  readOnly: true,
                ),
              ],
            );
          },
          itemCount: dataSubjectRight.dataRequester.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: UiConfig.lineSpacing,
          ),
        ),
      ],
    );
  }

  Column _buildIdentityProofInfo(
    BuildContext context, {
    required List<RequesterVerificationModel> verifications,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'เอกสารพิสูจน์ตัวตนและ/หรือพิสูจน์ถิ่นที่อยู่เจ้าของข้อมูล',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        Text(
          'ข้าพเจ้าได้แนบเอกสารดังต่อไปนี้เพื่อการตรวจสอบตัวตนและที่อยู่ของผู้ยื่นคำร้องเพื่อให้บริษัทฯสามารถดำเนินการตามสิทธิที่ร้องขอได้อย่างถูกต้อง',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final verification = UtilFunctions.getVerificationById(
              identityProofingPreset,
              verifications[index].id,
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${index + 1}. ${verification.title}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (!verification.additionalReq)
                  Padding(
                    padding: const EdgeInsets.only(top: UiConfig.lineGap),
                    child: Text(
                      'ประเภทเอกสาร: ${verifications[index].text}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                const SizedBox(height: UiConfig.lineGap),
                DownloadFileField(
                  fileUrl: verifications[index].imageUrl,
                  onDownloaded: _onDownloadFile,
                  alignment: Alignment.centerLeft,
                ),
              ],
            );
          },
          itemCount: verifications.length,
        ),
      ],
    );
  }

  Column _buildProcessRequestInfo(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          tr('dataSubjectRight.editDataSubjectRight.title4'),
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final processRequest = dataSubjectRight.processRequests[index];

            return _buildProcessRequestCard(
              context,
              index: index + 1,
              dataSubjectRightId: dataSubjectRight.id,
              processRequest: processRequest,
            );
          },
          itemCount: dataSubjectRight.processRequests.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: UiConfig.lineSpacing,
          ),
        ),
      ],
    );
  }

  Column _buildProcessRequestCard(
    BuildContext context, {
    required int index,
    required String dataSubjectRightId,
    required ProcessRequestModel processRequest,
  }) {
    final requestType = UtilFunctions.getRequestTypeById(
      widget.requestTypes,
      processRequest.requestType,
    );
    final description = requestType.description.firstWhere(
      (item) => item.language == widget.currentUser.defaultLanguage,
      orElse: () => const LocalizedModel.empty(),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: <Widget>[
              Text(
                '$index. ${description.text}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        ExpandedContainer(
          expand: true,
          duration: const Duration(milliseconds: 400),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: UiConfig.lineSpacing),
                _buildRequestActionInfo(
                  context,
                  processRequest: processRequest,
                ),
                const SizedBox(height: UiConfig.lineGap * 2),
                _buildRequestReasonInfo(
                  context,
                  processRequest: processRequest,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column _buildRequestActionInfo(
    BuildContext context, {
    required ProcessRequestModel processRequest,
  }) {
    final requestAction = UtilFunctions.getRequestActionById(
      requestActionsPreset,
      processRequest.requestAction,
    );
    final title = requestAction.title.firstWhere(
      (item) => item.language == widget.currentUser.defaultLanguage,
      orElse: () => const LocalizedModel.empty(),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleRequiredText(
          text: tr('dataSubjectRight.editDataSubjectRight.personalInformation'),
        ),
        CustomTextField(
          controller: TextEditingController(
            text: processRequest.personalData,
          ),
          readOnly: true,
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        TitleRequiredText(
          text: tr('dataSubjectRight.editDataSubjectRight.place'),
        ),
        CustomTextField(
          controller: TextEditingController(
            text: processRequest.foundSource,
          ),
          readOnly: true,
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        TitleRequiredText(
          text: tr('dataSubjectRight.editDataSubjectRight.operation'),
        ),
        CustomTextField(
          controller: TextEditingController(
            text: title.text,
          ),
          readOnly: true,
        ),
      ],
    );
  }

  Column _buildRequestReasonInfo(
    BuildContext context, {
    required ProcessRequestModel processRequest,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          tr('dataSubjectRight.editDataSubjectRight.reasonsRequest'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: UiConfig.lineGap),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final reasonType = UtilFunctions.getReasonTypeById(
              widget.reasonTypes,
              processRequest.reasonTypes[index].id,
            );
            final description = reasonType.description.firstWhere(
              (item) => item.language == widget.currentUser.defaultLanguage,
              orElse: () => const LocalizedModel.empty(),
            );

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomCheckBox(
                  value: true,
                  activeColor: Theme.of(context).colorScheme.outlineVariant,
                ),
                const SizedBox(width: UiConfig.actionSpacing),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      processRequest.reasonTypes[index].text.isNotEmpty
                          ? processRequest.reasonTypes[index].text
                          : description.text,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            );
          },
          itemCount: processRequest.reasonTypes.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: UiConfig.lineSpacing,
          ),
        ),
      ],
    );
  }

  Padding _buildDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: UiConfig.lineSpacing,
      ),
      child: Divider(
        color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
      ),
    );
  }
}
