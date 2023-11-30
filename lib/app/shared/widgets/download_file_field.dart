import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:path/path.dart' as p;

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
                maxLines: 2,
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
    final extension = p.extension(
      UtilFunctions.getFileNameFromUrl(widget.fileUrl),
    );
    const color = Colors.blue;
    return Column(
      children: <Widget>[
        extension == '.jpg' || extension == '.png'
            ? SizedBox(
                height: 180.0,
                child: Image.network(
                  widget.fileUrl,
                  fit: BoxFit.contain,
                ),
              )
            : Container(
                height: 120.0,
                width: 120.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  extension,
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(color: Colors.white),
                ),
              ),
        const SizedBox(height: UiConfig.lineSpacing),
      ],
    );
  }
}
