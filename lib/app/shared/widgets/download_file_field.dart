import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/utils/functions.dart';

import 'customs/custom_icon_button.dart';
import 'customs/custom_text_field.dart';

class DownloadFileField extends StatefulWidget {
  const DownloadFileField({
    super.key,
    required this.fileUrl,
    required this.onDownloaded,
    this.alignment = Alignment.center,
  });

  final String fileUrl;
  final Function(String path) onDownloaded;
  final Alignment alignment;

  @override
  State<DownloadFileField> createState() => _DownloadFileFieldState();
}

class _DownloadFileFieldState extends State<DownloadFileField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Visibility(
          visible: widget.fileUrl.isNotEmpty,
          child: Align(
            alignment: widget.alignment,
            child: _buildFilePreview(),
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: CustomTextField(
                controller: TextEditingController(
                  text: UtilFunctions.getFileNameFromUrl(widget.fileUrl),
                ),
                hintText: 'ไม่ได้ระบุลิงก์ URL',
                maxLines: 5,
                readOnly: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: CustomIconButton(
                padding: const EdgeInsets.all(12.0),
                onPressed: () {
                  widget.onDownloaded(widget.fileUrl);
                },
                icon: Icons.file_download_outlined,
                iconColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column _buildFilePreview() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 180.0,
          child: Image.network(
            widget.fileUrl,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
      ],
    );
  }
}
