import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/services.dart';

Future<void> showConfirmDialog({
  required BuildContext context,
  required String title,
  required DialogType dialogType,
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
}) async {
  final c = Theme.of(context).colorScheme;

  await AwesomeDialog(
    transitionAnimationDuration: const Duration(milliseconds: 200),
    context: context,
    headerAnimationLoop: false,
    dialogType: dialogType,
    animType: AnimType.scale,
    title: title,
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    btnOkText: '',
    btnOkIcon: Icons.check,
    btnOkColor: c.tertiary,
    btnCancelText: '',
    btnCancelIcon: Icons.close,
    btnCancelColor: c.error,
    btnCancelOnPress: onCancel ?? HapticFeedback.lightImpact,
    btnOkOnPress: onConfirm,
  ).show();
}

Future<void> showNotifyDialog({
  required BuildContext context,
  required String title,
}) async {
  await AwesomeDialog(
    transitionAnimationDuration: const Duration(milliseconds: 200),
    context: context,
    headerAnimationLoop: false,
    dialogType: DialogType.info,
    animType: AnimType.scale,
    title: title,
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    autoHide: Duration(milliseconds: 1500),
  ).show();
}
