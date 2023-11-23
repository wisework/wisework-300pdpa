import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/data/models/email_js/process_request_params.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/process_data_subject_right/process_data_subject_right_cubit.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/utils/toast.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/download_file_field.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/loading_indicator.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';
import 'package:pdpa/app/shared/widgets/upload_file_field.dart';

class ProcessProofOfAction extends StatefulWidget {
  const ProcessProofOfAction({
    super.key,
    required this.dataSubjectRightId,
    required this.processRequest,
    required this.initialProcessRequest,
    required this.requestTypes,
    required this.language,
  });

  final String dataSubjectRightId;
  final ProcessRequestModel processRequest;
  final ProcessRequestModel initialProcessRequest;
  final List<RequestTypeModel> requestTypes;
  final String language;

  @override
  State<ProcessProofOfAction> createState() => _ProcessProofOfActionState();
}

class _ProcessProofOfActionState extends State<ProcessProofOfAction> {
  final GlobalKey<FormState> _proofFormKey = GlobalKey<FormState>();

  void _onUploadProofOfActionFile(Uint8List data, String fileName) {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    final currentUser = cubit.state.currentUser;

    cubit.uploadProofOfActionFile(
      data,
      fileName,
      UtilFunctions.getProcessDsrProofPath(
        currentUser.currentCompany,
        widget.dataSubjectRightId,
      ),
      widget.processRequest.id,
    );
  }

  void _onDownloadProofOfActionFile(String path) {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    cubit.downloadFile(path);

    showToast(context, text: 'ดาวน์โหลดไฟล์สำเร็จ');
  }

  void _onProofOfActionChanged(String value, String id) {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    cubit.setProofOfActionText(value, id);
  }

  void _onSubmitPressed() {
    if (!_proofFormKey.currentState!.validate()) return;

    final cubit = context.read<ProcessDataSubjectRightCubit>();

    final emailParams = _getEmailParams();
    final fromName = '${cubit.state.currentUser.firstName}'
        '${cubit.state.currentUser.lastName.isNotEmpty ? cubit.state.currentUser.lastName : ''}';

    cubit.submitProcessRequest(
      widget.processRequest.id,
      toRequesterParams: emailParams,
      toUserParams: emailParams?.copyWith(
        toName: '',
        toEmail: '',
        fromName: fromName,
        fromEmail: cubit.state.currentUser.email,
      ),
    );
  }

  ProcessRequestTemplateParams? _getEmailParams() {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    final dataSubjectRight = cubit.state.dataSubjectRight;

    final emptyRequest = ProcessRequestModel.empty();
    final processRequest = dataSubjectRight.processRequests.firstWhere(
      (request) => request.id == cubit.state.processRequestSelected,
      orElse: () => emptyRequest,
    );

    if (processRequest != emptyRequest) {
      final Map<ProcessRequestStatus, String> statusTexts = {
        ProcessRequestStatus.notProcessed: 'ยังไม่ดำเนินการ',
        ProcessRequestStatus.inProgress: 'อยู่ระหว่างการดำเนินการ',
        ProcessRequestStatus.refused: 'ปฏิเสธการดำเนินการ',
        ProcessRequestStatus.completed: 'ดำเนินการเสร็จสิ้น',
      };

      final status = UtilFunctions.getProcessRequestStatus(
        dataSubjectRight,
        processRequest,
      );
      final requestType = UtilFunctions.getRequestTypeById(
        widget.requestTypes,
        processRequest.requestType,
      );
      final description = requestType.description.firstWhere(
        (item) => item.language == widget.language,
        orElse: () => const LocalizedModel.empty(),
      );

      return ProcessRequestTemplateParams(
        toName: dataSubjectRight.dataRequester[0].text,
        toEmail: dataSubjectRight.dataRequester[2].text,
        id: dataSubjectRight.id,
        processRequest: description.text,
        processStatus: '${statusTexts[status]}',
        link: processRequest.proofOfActionFile,
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'ดำเนินการ',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: UiConfig.lineGap),
          _buildUploadProofAction(context),
          const SizedBox(height: UiConfig.lineSpacing),
          _buildProofActionDetail(context),
          ExpandedContainer(
            expand: widget.initialProcessRequest.proofOfActionText.isEmpty,
            duration: const Duration(milliseconds: 400),
            child: Padding(
              padding: const EdgeInsets.only(top: UiConfig.lineGap * 2),
              child: _buildSubmitButton(context),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildUploadProofAction(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const TitleRequiredText(text: 'หลักฐานดำเนินการ'),
        widget.initialProcessRequest.proofOfActionFile.isEmpty
            ? UploadFileField(
                fileUrl: widget.processRequest.proofOfActionFile,
                onUploaded: _onUploadProofOfActionFile,
              )
            : DownloadFileField(
                fileUrl: widget.initialProcessRequest.proofOfActionFile,
                onDownloaded: _onDownloadProofOfActionFile,
              ),
      ],
    );
  }

  Form _buildProofActionDetail(BuildContext context) {
    return Form(
      key: _proofFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TitleRequiredText(
            text: 'รายละเอียดดำเนินการ',
            required: widget.initialProcessRequest.proofOfActionText.isEmpty,
          ),
          CustomTextField(
            initialValue: widget.processRequest.proofOfActionText,
            hintText: 'เนื่องด้วย...',
            maxLines: 5,
            onChanged: (value) {
              _onProofOfActionChanged(
                value,
                widget.processRequest.id,
              );
            },
            readOnly: widget.initialProcessRequest.proofOfActionText.isNotEmpty,
            required: true,
          ),
        ],
      ),
    );
  }

  BlocBuilder _buildSubmitButton(BuildContext context) {
    return BlocBuilder<ProcessDataSubjectRightCubit,
        ProcessDataSubjectRightState>(
      builder: (context, state) {
        final isLoading =
            state.loadingStatus.processingRequest == widget.processRequest.id;

        return CustomButton(
          height: 45.0,
          onPressed: _onSubmitPressed,
          child: isLoading
              ? LoadingIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 28.0,
                  loadingType: LoadingType.horizontalRotatingDots,
                )
              : Text(
                  'ส่งผลการตรวจสอบ',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
        );
      },
    );
  }
}
