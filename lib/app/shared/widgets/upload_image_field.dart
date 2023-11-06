import 'dart:io';

import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';

import 'customs/custom_icon_button.dart';
import 'customs/custom_text_field.dart';

class UploadImageField extends StatefulWidget {
  const UploadImageField({
    super.key,
    required this.imageUrl,
    required this.onUploaded,
    this.onRemoved,
  });

  final String imageUrl;
  final Function(
    File? image,
    Uint8List? data,
    String path,
  ) onUploaded;
  final VoidCallback? onRemoved;

  @override
  State<UploadImageField> createState() => _UploadImageFieldState();
}

class _UploadImageFieldState extends State<UploadImageField> {
  void _pickImage() async {
    final imagePicker = ImagePicker();
    final result = await imagePicker.pickImage(source: ImageSource.gallery);

    Uint8List data = Uint8List(10);
    if (result != null) {
      data = await result.readAsBytes();
    }

    if (result == null) return;

    if (kIsWeb) {
      widget.onUploaded(null, data, result.path);
    } else {
      widget.onUploaded(File(result.path), null, result.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Visibility(
          visible: widget.imageUrl.isNotEmpty,
          child: _buildImagePreview(),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: CustomTextField(
                controller: TextEditingController(
                  text: UtilFunctions.getFileNameFromUrl(widget.imageUrl),
                ),
                hintText: 'No image file selected',
                maxLines: 3,
                readOnly: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: CustomIconButton(
                onPressed: _pickImage,
                icon: Icons.file_upload_outlined,
                iconColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Stack _buildImagePreview() {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              height: 180.0,
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.contain,
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
