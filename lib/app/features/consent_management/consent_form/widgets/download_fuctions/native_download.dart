import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';

Future<bool> downloadQrCode(GlobalKey qrCodeKey) async {
  final boundary =
      qrCodeKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  final qrCodeImage = await boundary?.toImage();

  if (qrCodeImage != null) {
    final byteData = await qrCodeImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final bytes = byteData!.buffer.asUint8List();

    await ImageGallerySaver.saveImage(bytes);

    return true;
  }
  return false;
}
