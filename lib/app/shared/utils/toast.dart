import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';

void showToast(
  BuildContext context, {
  required String text,
}) {
  BotToast.showText(
    text: text,
    contentColor: Theme.of(context).colorScheme.secondary.withOpacity(0.75),
    borderRadius: BorderRadius.circular(8.0),
    textStyle: Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(color: Theme.of(context).colorScheme.onPrimary),
    duration: UiConfig.toastDuration,
  );
}
