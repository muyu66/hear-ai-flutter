import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hearai/tools/haptics_manager.dart';

Future<void> showConfirm({
  required BuildContext context,
  required String title,
  required DialogType dialogType,
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
}) async {
  final c = Theme.of(context).colorScheme;
  final t = Theme.of(context).textTheme;

  await AwesomeDialog(
    transitionAnimationDuration: const Duration(milliseconds: 200),
    context: context,
    headerAnimationLoop: false,
    dialogType: dialogType,
    animType: AnimType.scale,
    title: title,
    titleTextStyle: t.labelLarge,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    btnOkText: '',
    btnOkIcon: Icons.check,
    btnOkColor: c.tertiary,
    btnCancelText: '',
    btnCancelIcon: Icons.close,
    btnCancelColor: c.error,
    btnCancelOnPress:
        onCancel ??
        () {
          HapticsManager.light();
        },
    btnOkOnPress: onConfirm,
  ).show();
}

Future<void> showNotify({
  required BuildContext context,
  required String title,
}) async {
  final t = Theme.of(context).textTheme;

  await AwesomeDialog(
    transitionAnimationDuration: const Duration(milliseconds: 200),
    context: context,
    headerAnimationLoop: false,
    customHeader: Text("😊", style: TextStyle(fontSize: 46)),
    animType: AnimType.scale,
    title: title,
    titleTextStyle: t.titleMedium,
    padding: EdgeInsets.fromLTRB(12, 0, 12, 24),
    autoHide: Duration(milliseconds: 1500),
  ).show();
}

Future<void> showOk({required BuildContext context}) async {
  final t = Theme.of(context).textTheme;

  await AwesomeDialog(
    transitionAnimationDuration: const Duration(milliseconds: 150),
    context: context,
    headerAnimationLoop: false,
    animType: AnimType.scale,
    dialogType: DialogType.success,
    body: null,
    titleTextStyle: t.titleLarge,
    padding: EdgeInsets.zero,
    autoHide: Duration(milliseconds: 800),
    dialogBackgroundColor: Colors.transparent,
  ).show();
}

Future<void> showClassicNotify({
  required BuildContext context,
  required String title,
  required DialogType dialogType,
}) async {
  final t = Theme.of(context).textTheme;

  await AwesomeDialog(
    transitionAnimationDuration: const Duration(milliseconds: 200),
    context: context,
    headerAnimationLoop: false,
    dialogType: dialogType,
    animType: AnimType.scale,
    title: title,
    titleTextStyle: t.titleMedium,
    padding: EdgeInsets.fromLTRB(12, 0, 12, 24),
    autoHide: Duration(milliseconds: 1500),
  ).show();
}
