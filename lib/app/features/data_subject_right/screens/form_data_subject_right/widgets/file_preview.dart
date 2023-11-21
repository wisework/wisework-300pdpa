import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/functions.dart';

class FilePreview extends StatelessWidget {
  const FilePreview({
    super.key,
    this.size,
    required this.filePath,
    required this.fileUrl,
    this.fileTypeStyle,
    this.borderRadius,
    required this.onRemoved,
    this.isRemoveIconVisible,
    this.isImagePreview,
  });

  final double? size;
  final String filePath;
  final String fileUrl;
  final TextStyle? fileTypeStyle;
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback onRemoved;
  final bool? isRemoveIconVisible;
  final bool? isImagePreview;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 175.0,
      child: Stack(
        children: <Widget>[
          Builder(builder: (context) {
            final fileType = UtilFunctions.getFileType(filePath);
            if (fileImageType.contains(fileType) && (isImagePreview ?? false)) {
              return CachedNetworkImage(
                imageUrl: fileUrl,
                placeholder: (context, url) => Container(
                  height: size ?? 175.0,
                  color: Theme.of(context).colorScheme.tertiary,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: size ?? 175.0,
                  color: Theme.of(context).colorScheme.tertiary,
                  child: Center(
                    child: Icon(
                      Icons.error_rounded,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
                fit: BoxFit.cover,
              );
            }
            return SizedBox(
              height: size ?? 175.0,
              child: Stack(
                children: [
                  Icon(
                    Icons.insert_drive_file,
                    color: Theme.of(context).colorScheme.tertiary,
                    size: size ?? 175.0,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: EdgeInsets.only(
                        top: (size ?? 175.0) * 0.035,
                        left: (size ?? 175.0) * 0.08,
                        right: (size ?? 175.0) * 0.08,
                        bottom: (size ?? 175.0) * 0.02,
                      ),
                      margin: EdgeInsets.only(
                        left: (size ?? 175.0) * 0.05,
                        bottom: (size ?? 175.0) * 0.2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius:
                            borderRadius ?? BorderRadius.circular(10.0),
                      ),
                      child: Text(fileType.toUpperCase(),
                          style: fileTypeStyle ??
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  )),
                    ),
                  ),
                ],
              ),
            );
          }),
          if (isRemoveIconVisible ?? true)
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: onRemoved,
                icon: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.circle,
                        color: Theme.of(context).colorScheme.onSecondary,
                        size: 20,
                      ),
                    ),
                    Icon(
                      Icons.cancel,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
