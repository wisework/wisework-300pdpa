import 'dart:ui' as ui;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

Future<bool> downloadQrCode(GlobalKey qrCodeKey) async {
  final boundary =
      qrCodeKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  final qrCodeImage = await boundary?.toImage();

  if (qrCodeImage != null) {
    final byteData = await qrCodeImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final bytes = byteData!.buffer.asUint8List();

    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'qr_code.png';

    anchor.click();

    html.Url.revokeObjectUrl(url); // Release the object URL

    return true;
  }
  return false;
}
