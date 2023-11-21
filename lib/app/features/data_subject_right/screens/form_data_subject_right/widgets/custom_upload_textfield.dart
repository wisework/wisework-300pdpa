import 'package:flutter/material.dart';
import 'package:pdpa/app/features/data_subject_right/screens/form_data_subject_right/widgets/file_preview.dart';

class CustomUploadTextField extends StatelessWidget {
  const CustomUploadTextField({
    Key? key,
    this.title,
    this.text,
    this.errorText,
    this.placeholder,
    this.backgroundColor,
    this.filePath,
    this.fileUrl,
    required this.onPressed,
    required this.onRemoved,
    this.padding,
    this.isFilled,
    this.isError,
    this.isRequired,
  }) : super(key: key);

  final String? title;
  final String? text;
  final String? errorText;
  final String? placeholder;
  final Color? backgroundColor;
  final String? filePath;
  final String? fileUrl;
  final VoidCallback onPressed;
  final VoidCallback onRemoved;
  final EdgeInsets? padding;
  final bool? isFilled;
  final bool? isError;
  final bool? isRequired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
              child: Row(
                children: <Widget>[
                  Text(title ?? "",
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          )),
                  if (isRequired ?? false)
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Text("*",
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  )),
                    ),
                ],
              ),
            ),
          if (fileUrl != null)
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
              child: FilePreview(
                filePath: filePath ?? "",
                fileUrl: fileUrl ?? "",
                onRemoved: onRemoved,
                isImagePreview: true,
              ),
            ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  key: key,
                  readOnly: true,
                  controller: TextEditingController(text: text ?? ""),
                  minLines: 1,
                  maxLines: 10,
                  decoration: InputDecoration(
                    counterText: isError ?? false ? "" : null,
                    filled: isFilled ?? false,
                    fillColor: backgroundColor ??
                        Theme.of(context).colorScheme.tertiary,
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: isError ?? false
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.outline,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: isError ?? false
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.outline,
                        )),
                    hintText: placeholder ?? "ไม่ได้เลือกไฟล์",
                    hintStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 10.0,
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                  onChanged: (_) {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: IconButton(
                  onPressed: onPressed,
                  icon: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Icon(
                      Icons.file_upload,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (errorText != null && (isError ?? false))
            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 5.0),
              child: Text(errorText.toString(),
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      )),
            ),
        ],
      ),
    );
  }
}
