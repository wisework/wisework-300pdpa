import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/process_data_subject_right/process_data_subject_right_cubit.dart';
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
  });

  final String dataSubjectRightId;
  final ProcessRequestModel processRequest;
  final ProcessRequestModel initialProcessRequest;

  @override
  State<ProcessProofOfAction> createState() => _ProcessProofOfActionState();
}

class _ProcessProofOfActionState extends State<ProcessProofOfAction> {
  final GlobalKey<FormState> _proofFormKey = GlobalKey<FormState>();

  void _onUploadProofOfActionFile(File? file, Uint8List? data, String path) {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    final currentUser = cubit.state.currentUser;

    cubit.uploadProofOfActionFile(
      file,
      data,
      kIsWeb && data != null
          ? UtilFunctions.getUniqueFileNameByUint8List(data)
          : UtilFunctions.getUniqueFileName(path),
      UtilFunctions.getProcessDsrProofPath(
        currentUser.currentCompany,
        widget.dataSubjectRightId,
      ),
      widget.processRequest.id,
    );
  }

  void _onDownloadProofOfActionFile(String path) {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    cubit.downloadProofFile(path);

    showToast(context, text: 'ดาวน์โหลดไฟล์สำเร็จ');
  }

  void _onProofOfActionChanged(String value, String id) {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    cubit.setProofOfActionText(value, id);
  }

  void _onSubmitPressed() {
    if (!_proofFormKey.currentState!.validate()) return;

    final cubit = context.read<ProcessDataSubjectRightCubit>();
    cubit.submitProcessRequest(widget.processRequest.id);
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
