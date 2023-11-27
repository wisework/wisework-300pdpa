import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';

import 'customs/custom_icon_button.dart';
import 'customs/custom_text_field.dart';

class UploadFileField extends StatefulWidget {
  const UploadFileField({
    super.key,
    required this.fileUrl,
    required this.onUploaded,
    this.onRemoved,
  });

  final String fileUrl;
  final Function(
    Uint8List data,
    String fileName,
  ) onUploaded;
  final VoidCallback? onRemoved;

  @override
  State<UploadFileField> createState() => _UploadFileFieldState();
}

class _UploadFileFieldState extends State<UploadFileField> {
  PlatformFile file = PlatformFile(name: '', size: 0);
  Uint8List data = Uint8List(10);
  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: fileType,
    );

    if (result != null && result.files.isNotEmpty) {
      data = result.files.first.bytes!;
      if (kIsWeb) {
        widget.onUploaded(data, result.files.first.name);
      }
    }

    if (result == null) return;
    setState(() {
      file = result.files.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Visibility(
          visible: widget.fileUrl.isNotEmpty,
          child: _buildFilePreview(),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: CustomTextField(
                controller: TextEditingController(
                  text: UtilFunctions.getFileNameFromUrl(widget.fileUrl),
                ),
                hintText: 'ไม่ได้เลือกไฟล์',
                maxLines: 5,
                readOnly: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: CustomIconButton(
                padding: const EdgeInsets.all(12.0),
                onPressed: _pickFile,
                icon: Icons.file_upload_outlined,
                iconColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Stack _buildFilePreview() {
    final extension = p.extension(
      UtilFunctions.getFileNameFromUrl(widget.fileUrl),
    );
    const color = Colors.blue;
    return Stack(
      children: <Widget>[
        Column(
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
        ),
        if (widget.onRemoved != null)
          Positioned(
            top: 4.0,
            right: 4.0,
            child: MaterialInkWell(
              backgroundColor: Colors.white,
              borderRadius: BorderRadius.circular(11.0),
              onTap: widget.onRemoved!,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 3.0,
                  top: 2.0,
                  right: 3.0,
                  bottom: 4.0,
                ),
                child: Icon(
                  Ionicons.close_outline,
                  size: 16.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
