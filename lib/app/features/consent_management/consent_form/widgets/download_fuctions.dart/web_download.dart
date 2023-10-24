// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html';

import 'dart:ui' as ui;
import 'dart:html' as html;
import 'dart:html';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void downloadQrcode(GlobalKey qrKey) async {
  try {
    final boundary =
        qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    final qrCodeImage = await boundary?.toImage();

    if (qrCodeImage != null) {
      final byteData = await qrCodeImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      final bytes = byteData!.buffer.asUint8List();
      final blob = html.Blob([bytes]);
      final url1 = Url.createObjectUrlFromBlob(blob);
      final anchor = document.createElement('a') as AnchorElement
        ..href = url1
        ..style.display = 'none'
        ..download = 'QR Code.png';
      // document.body?.children.add(anchor);
      anchor.click();
    }
  } catch (e) {
    BotToast.showText(text: "Download QR Code failed");
  }
}
